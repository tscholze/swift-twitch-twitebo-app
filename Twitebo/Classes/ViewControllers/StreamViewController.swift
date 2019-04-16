//
//  StreamViewController.swift
//  Twitebo
//
//  Created by Tobias Scholze on 15.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

/// `StreamViewController` provides a web-based detail of the given
/// member's stream.
class StreamViewController: UIViewController
{
    // MARK: - Private properties -

    private let loadingView = LoadingView.instantiateFromNib()

    // MARK: - Internal properties -

    /// Underlying required member.
    var member: Member?

    // MARK: - View life cycle -

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    // MARK: - Actions -

    @IBAction
    private func onCloseButtonTapped(_: Any)
    {
        dismiss(animated: true)
    }
}
