//
//  ViewController.swift
//  SevenLittleWords
//
//  Created by Manish Charhate on 21/05/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var cluesLabel: UILabel!
    private var answersLabel: UILabel!
    private var answerTextField: UITextField!
    private var scoreLabel: UILabel!
    private var letterButtons = [UIButton]()
    private var solutions = [String]()
    private var level = 1
    private var selectedButtons = [UIButton]()
    private var attemptsLeft = 0
    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    // MARK:- Lifecycle

    override func loadView() {
        let view = UIView()
        setupSubviewsAndConstraints(for: view)
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadLevel()
    }

    // MARK:- Private methods

    private func setupSubviewsAndConstraints(for view: UIView) {
        view.backgroundColor = .white

        cluesLabel = UILabel()
        cluesLabel.numberOfLines = 0
        cluesLabel.font = .systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .vertical)
        view.addSubview(cluesLabel)

        answersLabel = UILabel()
        answersLabel.numberOfLines = 0
        answersLabel.font = .systemFont(ofSize: 24)
        answersLabel.textAlignment = .right
        answersLabel.text = "ANSWERS"
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .vertical)
        view.addSubview(answersLabel)

        scoreLabel = UILabel()
        scoreLabel.textAlignment = .right
        scoreLabel.textAlignment = .right
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)

        answerTextField = UITextField()
        answerTextField.placeholder = "Tap letters to guess.."
        answerTextField.font = .systemFont(ofSize: 44)
        answerTextField.isUserInteractionEnabled = false
        answerTextField.textAlignment = .center
        answerTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(answerTextField)

        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)

        let clearButton = UIButton(type: .system)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearButton)

        let buttonsContainerView = UIView()
        buttonsContainerView.layer.borderWidth = 0.4
        buttonsContainerView.layer.borderColor = UIColor.gray.cgColor
        buttonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsContainerView)

        let buttonWidth = 150
        let buttonHeight = 80

        for row in 0 ..< 4 {
            for column in 0 ..< 5 {
                let letterButton = UIButton(type: .system)
                letterButton.frame = CGRect(x: column * buttonWidth, y: row * buttonHeight, width: buttonWidth, height: buttonHeight)
                letterButton.addTarget(self, action: #selector(letterButtonTapped), for: .touchUpInside)
                letterButton.titleLabel?.font = .systemFont(ofSize: 28)
                buttonsContainerView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }

        NSLayoutConstraint.activate([
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),

            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),

            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),

            answerTextField.topAnchor.constraint(equalTo: answersLabel.bottomAnchor, constant: 20),
            answerTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerTextField.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),

            submitButton.topAnchor.constraint(equalTo: answerTextField.bottomAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),

            clearButton.topAnchor.constraint(equalTo: submitButton.topAnchor),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),

            buttonsContainerView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            buttonsContainerView.heightAnchor.constraint(equalToConstant: 320),
            buttonsContainerView.widthAnchor.constraint(equalToConstant: 750),
            buttonsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsContainerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
        ])
    }

    private func loadLevel() {
        score = 0
        var answersString = ""
        var cluesString = ""
        var letterBits = [String]()

        let loadDataWork = DispatchWorkItem { [weak self] in
            guard let strongSelf = self else { return }
            if let levelFileURL = Bundle.main.url(forResource: "level\(strongSelf.level)", withExtension: "txt") {
                if let fileContents = try? String(contentsOf: levelFileURL) {
                    var lines = fileContents.components(separatedBy: "\n")
                    lines.shuffle()
                    strongSelf.attemptsLeft = lines.count
                    for (index, line) in lines.enumerated() {
                        let components = line.components(separatedBy: ": ")
                        let answer = components[0]
                        let clue = components[1]

                        cluesString += "\(index + 1). \(clue)\n"

                        let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                        strongSelf.solutions.append(solutionWord)
                        answersString += "\(solutionWord.count) letters\n"

                        let answerBits = answer.components(separatedBy: "|")
                        letterBits += answerBits
                    }
                }
            }
        }

        DispatchQueue.global(qos: .utility).async(execute: loadDataWork)

        // Execute following UI updation on main thread when data load task is finished
        loadDataWork.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.answersLabel.text = answersString
            strongSelf.cluesLabel.text = cluesString
            letterBits.shuffle()

            if strongSelf.letterButtons.count == letterBits.count {
                for index in 0 ..< letterBits.count {
                    strongSelf.letterButtons[index].setTitle(letterBits[index], for: .normal)
                }
            }
        }
    }

    @objc private func submitButtonTapped() {
        guard let answer = answerTextField.text else { return }
        guard !answer.isEmpty else { return }

        attemptsLeft -= 1
        if let solutionPosition = solutions.firstIndex(of: answer) {
            selectedButtons.removeAll()

            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answer
            answersLabel.text = splitAnswers?.joined(separator: "\n")

            answerTextField.text = ""
            score += 1
        } else {
            score -= 1
            let alertController = UIAlertController(
                title: "Oops!",
                message: "That's a wrong one",
                preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
                self?.clearButtonTapped()
            })
            present(alertController, animated: true)
            return
        }

        if attemptsLeft == 0 {
            let alertController = UIAlertController(
                title: "Well done!",
                message: "Wanna try out next level?",
                preferredStyle: .alert)
            alertController.addAction(UIAlertAction(
                title: "Let's go",
                style: .default,
                handler: levelUp))
            present(alertController, animated: true)
        }
    }

    @objc private func clearButtonTapped() {
        answerTextField.text = ""
        for button in selectedButtons {
            button.isHidden = false
        }
        selectedButtons.removeAll()
    }

    @objc private func letterButtonTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }

        answerTextField.text = answerTextField.text?.appending(buttonTitle)
        selectedButtons.append(sender)
        sender.isHidden = true
    }

    private func levelUp(_ action: UIAlertAction) {
        level += 1
        solutions.removeAll()
        for button in letterButtons {
            button.isHidden = false
        }

        loadLevel()
    }

}

