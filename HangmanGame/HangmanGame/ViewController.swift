//
//  ViewController.swift
//  HangmanGame
//
//  Created by Manish Charhate on 25/05/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var words = [String]()
    private var usedLetters = [String]()
    private var guessedLetters = [String]()
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var remainingGuessesLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!

    private var remainingGuesses = 0 {
        didSet {
            remainingGuessesLabel.text = "Remaining Guesses: \(remainingGuesses)"
        }
    }

    private var score = 0 {
        didSet {
            scoreLabel.text = "Current score: \(score)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hangman"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Guess",
            style: .plain,
            target: self,
            action: #selector(guessLetter))
        score = 0
        performSelector(inBackground: #selector(loadData), with: nil)
    }

    @objc private func loadData() {
        if let wordsFileURL = Bundle.main.url(forResource: "words", withExtension: "txt"),
        let fileContents = try? String(contentsOf: wordsFileURL) {
            words = fileContents.components(separatedBy: "\n")
            words.shuffle()
        }
        performSelector(onMainThread: #selector(loadNextWord), with: nil, waitUntilDone: false)
    }

    @objc private func loadNextWord() {
        remainingGuesses = 7
        usedLetters.removeAll()
        guessedLetters.removeAll()
        guard let randomWord = words.randomElement() else { return }
        for letter in randomWord {
            usedLetters.append(String(letter))
            guessedLetters.append("?")
        }
        wordLabel.text = guessedLetters.joined()
    }

    @objc private func guessLetter() {
        let alertController = UIAlertController(
            title: "Guess",
            message: "Enter a letter to guess. \nWord contains letters in the range a-z",
            preferredStyle: .alert)
        alertController.addTextField { [weak self] (textField) in
            textField.autocapitalizationType = .none
            textField.delegate = self
        }
        alertController.addAction(UIAlertAction(
            title: "Submit",
            style: .default, handler: { [weak self, weak alertController]_ in
                self?.checkLetter(alertController?.textFields?[0].text)
        }))

        present(alertController, animated: true)
    }

    private func checkLetter(_ inputLetter: String?) {
        guard let inputLetter = inputLetter, !inputLetter.isEmpty else { return }

        if usedLetters.contains(inputLetter) {
            for index in 0..<guessedLetters.count {
                if usedLetters[index] == inputLetter {
                    guessedLetters[index] = inputLetter
                }
            }

            wordLabel.text = guessedLetters.joined()
            if guessedLetters.contains("?") {
                return
            }
            score += 1
            showSuccessMessage()
        } else {
            remainingGuesses -= 1
            if remainingGuesses == 0 {
                showFailureMessage()
            }
        }
    }

    private func showSuccessMessage() {
        let alertController = UIAlertController(
            title: "Well Done!!",
            message: "You correctly guessed the word. Wanna try next one?",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(
            title: "Yes",
            style: .default,
            handler: { [weak self] _ in
                self?.loadNextWord()
        }))
        present(alertController, animated: true)
    }

    private func showFailureMessage() {
        let alertController = UIAlertController(
            title: "Opps!",
            message: "You failed to guess the word in given attempts. \nYour score is \(score)",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(
            title: "Play again",
            style: .default,
            handler: { [weak self] _ in
                self?.playAgain()
        }))
        present(alertController, animated: true)
    }

    private func playAgain() {
        score = 0
        loadNextWord()
    }

}

extension ViewController: UITextFieldDelegate {

    // Restrict user from entering more than one character
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 1
    }
}

