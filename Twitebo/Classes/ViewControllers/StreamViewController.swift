//
//  StreamViewController.swift
//  Twitebo
//
//  Created by Tobias Scholze on 15.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import AVKit
import UIKit
import WebKit

/// `StreamViewController` provides a web-based detail of the given
/// member's stream.
class StreamViewController: UIViewController
{
    // MARK: - Outlets -

    @IBOutlet private weak var webView: WKWebView!

    // MARK: - Private properties -

    /// Fullscreen blocking loading view.
    private let loadingView = LoadingView.instantiateFromNib()

    /// Underlying required member.
    var member: Member?

    // MARK: - View life cycle -

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Observe if the web view will enter view / will become fullscreen. (Workarounds).
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDidBecomeVisibe),
                                               name: UIWindow.didBecomeVisibleNotification,
                                               object: view.window)

        // Observe if the webview 'close' button has been tapped. (Workaround).
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDidBecomeHidden),
                                               name: UIWindow.didBecomeHiddenNotification,
                                               object: view.window)

        // Ensure that all required data is available.
        guard let member = member,
            let url = URL(string: member.url) else
        {
            return
        }

        // Create and load request.
        loadingView.present(on: view)
        let request = URLRequest(url: url)
        webView.load(request)
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)

        // Remove all attached observers.
        NotificationCenter.default.removeObserver(self)
    }

    @objc
    private func onDidBecomeVisibe()
    {
        loadingView.dismiss(animated: true)
    }

    @objc
    private func onDidBecomeHidden()
    {
        dismiss(animated: true)
    }

    // MARK: - Actions -

    @IBAction
    private func onCloseButtonTapped(_: Any)
    {
        dismiss(animated: true)
    }
}
