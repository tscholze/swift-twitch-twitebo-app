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

    // Collection view controller that will represent only team members.
    private var onlineMembersViewController: MembersCollectionViewController?

    // Collection view controller that will represent all team members.
    private var allMembersViewController: MembersCollectionViewController?

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
        else if let membersViewController = segue.destination as? MembersCollectionViewController
        {
            if segue.identifier == "ShowOnlineMembersScene"
            {
                onlineMembersViewController = membersViewController
                onlineMembersViewController?.delegate = self
            }
            else if segue.identifier == "ShowAllMembersScene"
            {
                allMembersViewController = membersViewController
                allMembersViewController?.delegate = self
            }
        }
    }

    // MARK: - Private helper -

    /// Will setup the view with all required data.
    private func setup()
    {
        // Setup navigation bar.
        navigationController?.navigationBar.isHidden = true

        // Setup footer view.
        let gradientBottomLayer: CAGradientLayer = CAGradientLayer()
        gradientBottomLayer.colors = UIColor.brandGradient.reversed() as [Any]
        gradientBottomLayer.locations = [0.0, 1.0]
        gradientBottomLayer.frame = footerView.bounds
        footerView.layer.insertSublayer(gradientBottomLayer, at: 0)

        // Show loading view.
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
                self.teamInformationViewController?.setup(forTeam: team, with: self)
                self.onlineMembersViewController?.setup(forTeam: team, showOnlyOnlineMembers: true)
                self.allMembersViewController?.setup(forTeam: team)

                // Dismiss loadingview
                self.loadingView.dismiss()
            }
        }
    }
}

// MARK: - MembersCollectionViewControllerDelegate -

extension TeamViewController: MembersCollectionViewControllerDelegate
{
    func membersCollectionViewControllerDidSelectMember(_: MembersCollectionViewController, member: Member)
    {
        // Get a new instance of the stream view controller.
        guard let streamVc = storyboard?.instantiateViewController(withIdentifier: "StreamScene")
            as? StreamViewController else
        {
            return
        }

        // Set selected member to the instantiated view controller.
        streamVc.member = member

        // Show member.
        present(streamVc, animated: true)
    }
}

extension TeamViewController: TeamInformationViewControllerDelegate
{
    func teamInformationViewControllerRequestedSearch(_: TeamInformationViewController)
    {
        guard let searchVc = storyboard?.instantiateViewController(withIdentifier: "SearchScene") as? SearchViewController else
        {
            return
        }

        // TODO: Load it from disk
        searchVc.setup(for: SearchConfiguration(teamName: "",
                                                showMatureStreamer: true,
                                                showOnlyApStreamer: false), with: self)

        searchVc.modalPresentationStyle = .overCurrentContext
        searchVc.view.backgroundColor = UIColor.clear

        present(searchVc, animated: true)
    }
}

extension TeamViewController: SearchViewControllerDelegate
{
    func searchViewController(_: SearchViewController, requestedSearchWith configuration: SearchConfiguration)
    {
        print("Now I should search for team: \(configuration.teamName)")
    }
}
