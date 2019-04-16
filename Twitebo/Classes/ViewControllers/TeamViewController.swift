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

    @IBOutlet private weak var footerView: UIView!

    // MARK: - Private properties -

    // Fullscreen blocking loading view.
    private let loadingView = LoadingView.instantiateFromNib()

    // Collection view controller that will represent all team members.
    private var membersViewController: MembersCollectionViewController?

    /// View controller that will represent the team's information.
    private var teamInformationViewController: TeamInformationViewController?

    // TODO: Add another cvc that only represents online members.

    // MARK: - View life cycle -

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setup()
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?)
    {
        // Check if destination is the team information view controller.
        if let teamInformationViewController = segue.destination as? TeamInformationViewController
        {
            self.teamInformationViewController = teamInformationViewController
        }

        // Check if destination is members view controller
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
//        view.translatesAutoresizingMaskIntoConstraints = false

        // Setup footer view
        let gradientBottomLayer: CAGradientLayer = CAGradientLayer()
        gradientBottomLayer.colors = UIColor.brandGradient.reversed() as [Any]
        gradientBottomLayer.locations = [0.0, 1.0]
        gradientBottomLayer.frame = footerView.bounds
        footerView.layer.insertSublayer(gradientBottomLayer, at: 0)

        // Show loading view
        loadingView.present(on: view)

        // Get values from server.
        TwiteboApi.shared.loadTeam(withName: "livecoders")
        { [weak self] team in
            // Ensure self exists
            guard let self = self else { return }

            // Ensure required data is set.
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
                // Set received team to sub view controllers
                self.membersViewController?.setup(forTeam: team)
                self.teamInformationViewController?.setup(forTeam: team)

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
