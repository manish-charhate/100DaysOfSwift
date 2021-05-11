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

    private func askQuestion() {
        questionCount += 1

        // Shuffle `countryFlags` array for the next question
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
        style: .default) { _ in
            let finalAlertController = UIAlertController(
                title: "Congrats!",
                message: "You scored \(self.score) out of 10",
                preferredStyle: .alert)

            finalAlertController.addAction(UIAlertAction(
                title: "Share score with friends",
                style: .default,
                handler: { _ in
                    // Calling again this function just to update title with final score.
                    self.askQuestion()

                    self.shareScore()
                    self.score = 0
            }))

            self.present(finalAlertController, animated: true)
        }

        if questionCount != 10 {
            alertController.addAction(continueAction)
        } else {
            alertController.addAction(doneAction)
        }

        present(alertController, animated: true)
    }

    private func shareScore() {
        let activityViewController = UIActivityViewController(
            activityItems: ["Hey!! I scored \(score) out of 10 in GuessTheFlag game."],
            applicationActivities: nil)
        present(activityViewController, animated: true)
    }

}
