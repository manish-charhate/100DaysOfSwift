//
//  DetailViewController.swift
//  FeedDemo
//
//  Created by Manish Charhate on 19/05/21.
//  Copyright © 2021 Manish Charhate. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    private let webView: WKWebView
    private let petition: Petition

    init(with petition: Petition) {
        self.petition = petition
        webView = WKWebView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let htmlString = """
        <html>
            <head>
                <meta name="viewport" content="initial-scale=1.0"/>
                <style>
                    body { font-size: 130%; font-style: italic; }
                </style>
            </head>
            <body>
                \(petition.petitionBody)
            </body>
        </html>
        """
        webView.loadHTMLString(htmlString, baseURL: nil)
    }

}
