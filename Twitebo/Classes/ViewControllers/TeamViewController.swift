//
//  TeamViewController.swift
//  Twitebo
//
//  Created by Tobias Scholze on 09.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

/// `TeamViewController` provides the functionallity to search a
/// team and show all team-related information.
/// It also contains information about the team members.
class TeamViewController: UIViewController
{
    // MARK: - Outlets-

    @IBOutlet private weak var teamBackgroundImageView: UIImageView!
    @IBOutlet private weak var teamLogoImageView: UIImageView!
    @IBOutlet private weak var teamNameLabel: UILabel!
    @IBOutlet private weak var teamInfoLabel: UILabel!

    // MARK: - Private properties -

    // Fullscreen blocking loading view.
    private let loadingView = LoadingView.instantiateFromNib()

    // Collection view controller that will represent all team members.
    private var membersViewController: MembersCollectionViewControlller?

    // TODO: Add another cvc that only represents online members.

    // MARK: - View life cycle -

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setup()
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?)
    {
        // Check if members view controller
        if let membersViewController = segue.destination as? MembersCollectionViewControlller
        {
            self.membersViewController = membersViewController
        }
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
                self.teamInfoLabel.attributedText = team.info.htmlAsAttributedString

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

                // Set received team to sub view controllers
                self.membersViewController?.setup(forTeam: team)
            }
        }
    }
}
