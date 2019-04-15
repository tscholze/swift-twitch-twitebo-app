//
//  StreamViewController.swift
//  Twitebo
//
//  Created by Tobias Scholze on 15.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

class StreamViewController: UIViewController
{
    // MARK: - Private properties -

    private let loadingView = LoadingView.instantiateFromNib()

    // MARK: - View life cycle -

    override func viewDidLoad()
    {
        super.viewDidLoad()

        loadingView.present(on: view)
    }
}
