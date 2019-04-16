//
//  TestVC.swift
//  Twitebo
//
//  Created by Tobias Scholze on 16.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

class TestVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let loadingView = LoadingView.instantiateFromNib()
        loadingView.present(on: view)
    }
}
