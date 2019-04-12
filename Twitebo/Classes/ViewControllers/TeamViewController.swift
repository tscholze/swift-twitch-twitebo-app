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

    @IBOutlet private weak var teamBackgroundImageView: UIImageView!
    @IBOutlet private weak var teamLogoImageView: UIImageView!
    @IBOutlet private weak var teamNameLabel: UILabel!
    @IBOutlet private weak var teamInfoLabel: UILabel!

    // MARK: - Private properties -

    private let loadingView = LoadingView.instantiateFromNib()

    // MARK: - View life cycle -

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setup()
    }

    // MARK: - Private helper -

    /// Will setup the view with all required data.
    private func setup()
    {
        // Clear all labels from development values.
        teamNameLabel.text = nil
        teamInfoLabel.text = nil
        
        // Get values from server.
        TwiteboApi.shared.loadTeam(withName: "livecoders")
        { [weak self] team in

            // Check if required data is set.
            guard let self = self,
                let team = team else
            {
                // TODO: Handle this state
                print("No team found")
                return
            }

            // Change to main (ui) thread.
            DispatchQueue.main.async
            {
                // Set text values
                self.teamNameLabel.text = team.displayName

                // TODO: Escape info text (its html)
                self.teamInfoLabel.text = team.info

                // Check if team banner is available.
                //  - Yes: Load it from url.
                //  - No: Hide Image view
                if let banner = team.banner, let bannerUrl = URL(string: banner)
                {
                    self.teamBackgroundImageView.image(fromUrl: bannerUrl)
                }
                else
                {
                    self.teamBackgroundImageView.alpha = 0
                }

                // Load team logo from url.
                if let logoUrl = URL(string: team.logo)
                {
                    self.teamLogoImageView.image(fromUrl: logoUrl)
                }
            }
        }
    }
}
