//
//  ViewController.swift
//  MiniBrowser
//
//  Created by Manish Charhate on 13/05/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    // MARK:- Properties

    @objc private var webView: WKWebView!
    private var progressView: UIProgressView!
    private let websites = ["apple.com", "linkedin.com", "google.com"]

    // MARK:- Lifecycle methods

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        self.view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Open",
            style: .plain,
            target: self,
            action: #selector(openButtonTapped))

        progressView = UIProgressView(progressViewStyle: .bar)
        let progressViewItem = UIBarButtonItem(customView: progressView)
        let spacingItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refreshButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [progressViewItem, spacingItem, refreshButtonItem]
        navigationController?.isToolbarHidden = false

        addObserver(
            self,
            forKeyPath: #keyPath(webView.estimatedProgress),
            options: [.new, .old],
            context: nil)
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    // MARK:- Private helpers

    @objc private func openButtonTapped() {
        let alertController = UIAlertController(title: "Open ...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            alertController.addAction(UIAlertAction(title: website, style: .default, handler: openWebsite))
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }

    private func openWebsite(action: UIAlertAction) {
        guard let actionTitle = action.title,
            let url = URL(string: "https://" + actionTitle) else {
                return
        }
        webView.load(URLRequest(url: url))
    }

    // MARK:- WKNavigationDelegate

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    /**
     For allowing user to visit sites only from the one we specified.
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }

        print("## Prohibiting user from accessing URL - \(url)")
        decisionHandler(.cancel)
    }

    // MARK:- KVO

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(webView.estimatedProgress) {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

}

