//
//  GameScene.swift
//  Pachinko
//
//  Created by Manish Charhate on 29/05/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    private var minimumHeightRequiredForBall: CGFloat = 700
    private var balls = ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballRed", "ballYellow", "ballPurple"]

    private var scoreLabel: SKLabelNode!
    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    private var remainingBallsLabel: SKLabelNode!
    private var remainingBalls = 5 {
        didSet {
            remainingBallsLabel.text = "Balls Left: \(remainingBalls)"
        }
    }

    override func didMove(to view: SKView) {
        let backgroundNode = SKSpriteNode(imageNamed: "background")
        print(view.bounds)
        backgroundNode.position = CGPoint(x: 512, y: 384)
        backgroundNode.zPosition = -1
        backgroundNode.blendMode = .replace
        addChild(backgroundNode)

        scoreLabel = SKLabelNode(fontNamed: "Chalkboard")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)

        remainingBallsLabel = SKLabelNode(fontNamed: "Chalkboard")
        remainingBallsLabel.position = CGPoint(x: 100, y: 700)
        remainingBallsLabel.text = "Balls Left: \(remainingBalls)"
        addChild(remainingBallsLabel)

        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self

        for i in 0..<5 {
            makeSlot(at: CGPoint(x: 128 + (256 * i), y: 0), isGoodBase: i % 2 == 0)
            makeBouncer(at: CGPoint(x: 256 * i, y: 0))
        }

        loadNextLevel()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            // Restrict touches below than minimum height
            if touch.location(in: self).y < minimumHeightRequiredForBall { return }

            guard let ballName = balls.randomElement() else { return }
            let ballNode = SKSpriteNode(imageNamed: ballName)
            ballNode.position = touch.location(in: self)
            ballNode.physicsBody = SKPhysicsBody(circleOfRadius: ballNode.size.width / 2)
            ballNode.physicsBody?.contactTestBitMask = ballNode.physicsBody?.collisionBitMask ?? 0
            ballNode.physicsBody?.restitution = 0.4
            ballNode.name = "ball"
            addChild(ballNode)
        }
    }

    // MARK:- SKPhysicsContactDelegate

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
            let nodeB = contact.bodyB.node else {
                return
        }
        if nodeA.name == "ball" {
            collisionHappenedBetween(ball: nodeA, and: nodeB)
        } else if nodeB.name == "ball" {
            collisionHappenedBetween(ball: nodeB, and: nodeA)
        }
    }

    // MARK:- Private helpers

    private func makeBouncer(at position: CGPoint) {
        let bouncerNode = SKSpriteNode(imageNamed: "bouncer")
        bouncerNode.position = position
        bouncerNode.physicsBody = SKPhysicsBody(circleOfRadius: bouncerNode.size.width / 2)
        bouncerNode.physicsBody?.isDynamic = false
        addChild(bouncerNode)
    }

    private func makeSlot(at position: CGPoint, isGoodBase: Bool) {
        var slotBaseNode: SKSpriteNode
        var slotGlowNode: SKSpriteNode

        if isGoodBase {
            slotBaseNode = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlowNode = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBaseNode.name = "good"
        } else {
            slotBaseNode = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlowNode = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBaseNode.name = "bad"
        }

        slotBaseNode.position = position
        slotGlowNode.position = position
        slotBaseNode.physicsBody = SKPhysicsBody(rectangleOf: slotBaseNode.size)
        slotBaseNode.physicsBody?.isDynamic = false
        addChild(slotBaseNode)
        addChild(slotGlowNode)

        let spinAction = SKAction.rotate(byAngle: .pi, duration: 10)
        let foreverSpinAction = SKAction.repeatForever(spinAction)
        slotGlowNode.run(foreverSpinAction)
    }

    private func loadNextLevel() {
        remainingBalls = 5
        for _ in 0..<100 {
            makeObstacle(at: CGPoint(x: CGFloat.random(in: 24...1000), y: CGFloat.random(in: 200...700)))
        }
    }

    private func makeObstacle(at position: CGPoint) {
        let size = CGSize(width: Int.random(in: 16...128), height: 16)
        let color = UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1)
        let obstacleNode = SKSpriteNode(color: color, size: size)
        obstacleNode.zRotation = CGFloat.random(in: 0...3)
        obstacleNode.position = position
        obstacleNode.name = "obstacle"
        obstacleNode.physicsBody = SKPhysicsBody(rectangleOf: obstacleNode.size)
        obstacleNode.physicsBody?.isDynamic = false
        addChild(obstacleNode)
    }

    private func collisionHappenedBetween(ball: SKNode, and object: SKNode) {
        if object.name == "good" {
            destroy(object: ball)
            remainingBalls += 1
        } else if object.name == "bad" {
            destroy(object: ball)
            remainingBalls -= 1
        } else if object.name == "obstacle" {
            destroy(object: object)
        }

        if childNode(withName: "obstacle") == nil && remainingBalls >= 0 {
            score += 1
            loadNextLevel()
        } else if childNode(withName: "obstacle") != nil && remainingBalls == 0 {
            score -= 1
            loadNextLevel()
        }
    }

    private func destroy(object: SKNode) {
        if let fireParticleNode = SKEmitterNode(fileNamed: "FireParticles"),
            object.name == "ball" {
            fireParticleNode.position = object.position
            addChild(fireParticleNode)
        }
        object.removeFromParent()
    }

}
