//
//  TeamViewController.swift
//  Twitebo
//
//  Created by Tobias Scholze on 09.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController
{
    // MARK: - Outlets-

    @IBOutlet private weak var teamLogoImageView: UIImageView!
    @IBOutlet private weak var teamNameLabel: UILabel!

    // MARK: - Private properties -

    private let loadingView = LoadingView.instantiateFromNib()

    // MARK: - View life cycle -

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setup()
    }

    // MARK: - Private helper -

    private func setup()
    {
        TwiteboApi.shared.loadTeam(withName: "livecoders")
        { [weak self] team in
            guard let self = self else { return }

            guard let team = team else
            {
                // TODO: Handle this state
                print("No team found")
                return
            }

            DispatchQueue.main.async
            {
                self.teamNameLabel.text = team.displayName

                if let logoUrl = URL(string: team.logo)
                {
                    self.teamLogoImageView.image(fromUrl: logoUrl)
                }
            }
        }
    }
}
