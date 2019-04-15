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

    @IBOutlet private weak var teamView: UIView!
    @IBOutlet private weak var teamBackgroundImageView: UIImageView!
    @IBOutlet private weak var teamLogoImageView: UIImageView!
    @IBOutlet private weak var teamNameLabel: UILabel!
    @IBOutlet private weak var teamInfoTextView: UITextView!
    @IBOutlet private weak var footerView: UIView!

    // MARK: - Private properties -

    // Fullscreen blocking loading view.
    private let loadingView = LoadingView.instantiateFromNib()

    // Collection view controller that will represent all team members.
    private var membersViewController: MembersCollectionViewController?

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
        if let membersViewController = segue.destination as? MembersCollectionViewController
        {
            self.membersViewController = membersViewController
            self.membersViewController?.delegate = self
        }
    }

    // MARK: - Private helper -

    /// Will setup the view with all required data.
    private func setup()
    {
        view.translatesAutoresizingMaskIntoConstraints = false

        // Setup team view
        let gradientTopLayer: CAGradientLayer = CAGradientLayer()
        gradientTopLayer.colors = UIColor.brandGradient as [Any]
        gradientTopLayer.locations = [0.0, 0.7]
        gradientTopLayer.frame = teamView.bounds
        teamView.layer.insertSublayer(gradientTopLayer, at: 0)

        // Setup footer view
        let gradientBottomLayer: CAGradientLayer = CAGradientLayer()
        gradientBottomLayer.colors = UIColor.brandGradient.reversed() as [Any]
        gradientBottomLayer.locations = [0.0, 1.0]
        gradientBottomLayer.frame = footerView.bounds
        footerView.layer.insertSublayer(gradientBottomLayer, at: 0)

        // Setup team info view
        teamInfoTextView.contentOffset = CGPoint(x: 0, y: 0)

        // Clear all labels from development values.
        teamNameLabel.text = nil
        teamInfoTextView.text = nil

        // Show loading view
        loadingView.present(on: view)

        // Get values from server.
        TwiteboApi.shared.loadTeam(withName: "livecoders")
        { [weak self] team in
            // Ensure self exists
            guard let self = self else { return }

            // Ensurerequired data is set.

            guard let team = team else
            {
                DispatchQueue.main.async
                {
                    // TODO: Handle this state
                    print("No team found")
                    self.loadingView.dismiss()
                }
                return
            }

            // Change to main (ui) thread.
            DispatchQueue.main.async
            {
                // Set text values
                self.teamNameLabel.text = team.displayName
                self.teamInfoTextView.attributedText = team.info.replacingOccurrences(of: "\n", with: "").htmlAsAttributedString

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

                // Dismiss loadingview
                self.loadingView.dismiss()
            }
        }
    }
}

extension TeamViewController: MembersCollectionViewControllerDelegate
{
    func membersCollectionViewControllerDidSelectMember(_ member: Member)
    {
        guard let streamVc = storyboard?.instantiateViewController(withIdentifier: "StreamScene")
            as? StreamViewController else
        {
            return
        }

        // Set selected member to the instantiated view controller.
        streamVc.member = member

        // Show member.
        show(streamVc, sender: nil)
    }
}
