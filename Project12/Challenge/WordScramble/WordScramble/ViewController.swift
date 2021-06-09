//
//  ViewController.swift
//  WordScramble
//
//  Created by Manish Charhate on 14/05/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    // MARK:- Properties

    private var allWords = [String]()
    private var usedWords = [String]()
    private static let userDefaults = UserDefaults.standard

    // MARK:- Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAnserPrompt))
        startGame()
    }

    // MARK:- Private methods

    private func startGame() {
        let currentWord: String?
        if let savedWord = ViewController.userDefaults.string(forKey: "currentWord") {
            currentWord = savedWord
        } else {
            if let textFilePath = Bundle.main.path(forResource: "start", ofType: "txt"),
                let wordString = try? String(contentsOfFile: textFilePath) {
                allWords = wordString.components(separatedBy: "\n")
            }
            if allWords.isEmpty {
                allWords = ["silkworm"]
            }
            currentWord = allWords.randomElement()
            ViewController.userDefaults.set(currentWord, forKey: "currentWord")
        }
        title = currentWord
        if let usedWords = ViewController.userDefaults.object(forKey: "usedWords") as? [String] {
            self.usedWords = usedWords
        } else {
            usedWords.removeAll(keepingCapacity: true)
        }
        tableView.reloadData()
    }

    @objc private func openAnserPrompt() {
        let alertController = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        alertController.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] _ in
            guard let answer = alertController?.textFields?[0].text else { return }
            self?.submit(answer)
        }

        alertController.addAction(submitAction)
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }

    private func submit(_ answer: String) {
        let lowercaseAnswer = answer.lowercased()

        let errorTitle: String
        let errorMessage: String

        if isPossible(word: lowercaseAnswer) {
            if isOriginal(word: lowercaseAnswer) {
                if isReal(word: lowercaseAnswer) {
                    usedWords.insert(lowercaseAnswer, at: 0)
                    tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    ViewController.userDefaults.setValue(usedWords, forKey: "usedWords")
                    return
                } else {
                    errorTitle = "Word not recognized"
                    errorMessage = "You can't just make them up, you know!"
                }
            } else {
                errorTitle = "Word already used"
                errorMessage = "Please be more original."
            }
        } else {
            guard let title = title else { return }
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title)"
        }

        let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated: true)
    }

    private func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        for character in word {
            if let position = tempWord.firstIndex(of: character) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }

    private func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }

    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: true, language: "en_IN")
        return misspelledRange.location == NSNotFound
    }

    // MARK:- UITableView datasource, delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

}

