//
//  StreamViewController.swift
//  Twitebo
//
//  Created by Tobias Scholze on 15.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit
import WebKit

/// `StreamViewController` provides a web-based detail of the given
/// member's stream.
class StreamViewController: UIViewController
{
    // MARK: - Outlets -

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Private properties -

    private let loadingView = LoadingView.instantiateFromNib()

    /// Underlying required member.
    var member: Member?

    // MARK: - View life cycle -

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Setup web view
        webView.navigationDelegate = self

        // Ensure that all required data is available.
        guard let member = member,
            let url = URL(string: member.url) else
        {
            return
        }

        // Create and load request.
        let request = URLRequest(url: url)
        webView.load(request)
    }

    // MARK: - Actions -

    @IBAction
    private func onCloseButtonTapped(_: Any)
    {
        dismiss(animated: true)
    }
}

// MARK: - WKNavigationDelegate -

extension StreamViewController: WKNavigationDelegate
{
    func webView(_: WKWebView, didFinish _: WKNavigation!)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        { [weak self] in
            self?.webView.alpha = 1
            self?.activityIndicator.alpha = 0
        }
    }
}
