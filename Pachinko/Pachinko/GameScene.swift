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

    var scoreLabel: SKLabelNode!

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    var editLabel: SKLabelNode!

    var isInEditMode = false {
        didSet {
            editLabel.text = isInEditMode ? "Done" : "Edit"
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

        editLabel = SKLabelNode(fontNamed: "Chalkboard")
        editLabel.position = CGPoint(x: 80, y: 700)
        editLabel.text = "Edit"
        addChild(editLabel)

        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self

        for i in 0..<5 {
            makeSlot(at: CGPoint(x: 128 + (256 * i), y: 0), isGoodBase: i % 2 == 0)
            makeBouncer(at: CGPoint(x: 256 * i, y: 0))
        }

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {

            let position = touch.location(in: self)
            let objects = nodes(at: position)
            if objects.contains(editLabel) {
                isInEditMode.toggle()
                return
            }
            if isInEditMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let color = UIColor(
                    red: CGFloat.random(in: 0...1),
                    green: CGFloat.random(in: 0...1),
                    blue: CGFloat.random(in: 0...1),
                    alpha: 1)
                let boxNode = SKSpriteNode(color: color, size: size)
                boxNode.zRotation = CGFloat.random(in: 0...3)
                boxNode.position = position
                boxNode.physicsBody = SKPhysicsBody(rectangleOf: boxNode.size)
                boxNode.physicsBody?.isDynamic = false
                addChild(boxNode)
            } else {
                let redBallNode = SKSpriteNode(imageNamed: "ballRed")
                redBallNode.position = touch.location(in: self)
                redBallNode.physicsBody = SKPhysicsBody(circleOfRadius: redBallNode.size.width / 2)
                redBallNode.physicsBody?.contactTestBitMask = redBallNode.physicsBody?.collisionBitMask ?? 0
                redBallNode.physicsBody?.restitution = 0.4
                redBallNode.name = "ball"
                addChild(redBallNode)
            }
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

    private func collisionHappenedBetween(ball: SKNode, and object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }

    private func destroy(ball: SKNode) {
        if let fireParticleNode = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticleNode.position = ball.position
            addChild(fireParticleNode)
        }
        ball.removeFromParent()
    }

}
