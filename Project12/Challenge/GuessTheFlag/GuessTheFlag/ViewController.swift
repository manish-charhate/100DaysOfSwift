//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Manish Charhate on 24/04/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var thirdButton: UIButton!

    private var countryFlags = [String]()
    private var score = 0
    private var correctAnswer = 0
    private var questionCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        firstButton.layer.shadowOpacity = 0.5
        secondButton.layer.shadowOpacity = 0.5
        thirdButton.layer.shadowOpacity = 0.5

        firstButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        secondButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        thirdButton.layer.shadowOffset = CGSize(width: 0, height: 2)

        countryFlags += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        askQuestion()
    }

    func askQuestion() {
        questionCount += 1

        // Shuffle array for the next question
        countryFlags.shuffle()

        correctAnswer = Int.random(in: 0...2)
        title = countryFlags[correctAnswer].uppercased() + "   Score: \(score)/10"

        firstButton.setImage(UIImage(named: countryFlags[0]), for: .normal)
        secondButton.setImage(UIImage(named: countryFlags[1]), for: .normal)
        thirdButton.setImage(UIImage(named: countryFlags[2]), for: .normal)
    }

    @IBAction func flagSelected(_ sender: Any) {
        var title: String
        var message: String

        guard let button = sender as? UIButton else {
            fatalError("Expecting a button tap")
        }
        if button.tag == correctAnswer {
            title = "Correct!"
            message = "You scored 1 point."
            score += 1
        } else {
            title = "Wrong:("
            message = "That's the flag of \(countryFlags[button.tag].uppercased())"
        }

        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)

        let continueAction = UIAlertAction(
            title: "Continue",
            style: .default,
            handler: { _ in self.askQuestion() })

        let doneAction = UIAlertAction(
        title: "Done",
        style: .default) { [weak self] _ in
            guard let strongSelf = self else { return }
            let userDefaults = UserDefaults.standard
            let highScore = userDefaults.integer(forKey: "highScore")

            var message: String?
            if highScore > 0 {
                if strongSelf.score > highScore {
                    userDefaults.set(strongSelf.score, forKey: "highScore")
                    message = "You've set a new high score!!"
                } else {
                    message = "You scored \(strongSelf.score) out of 10"
                }
            } else {
                userDefaults.set(strongSelf.score, forKey: "highScore")
                message = "You scored \(strongSelf.score) out of 10"
            }

            let finalAlertController = UIAlertController(
                title: "Congrats!",
                message: message,
                preferredStyle: .alert)

            finalAlertController.addAction(UIAlertAction(
                title: "Play again",
                style: .default,
                handler: { _ in
                    strongSelf.questionCount = 0
                    strongSelf.score = 0
                    strongSelf.askQuestion()
            }))

            strongSelf.present(finalAlertController, animated: true)
        }

        if questionCount != 10 {
            alertController.addAction(continueAction)
        } else {
            alertController.addAction(doneAction)
        }

        present(alertController, animated: true)
    }

}
