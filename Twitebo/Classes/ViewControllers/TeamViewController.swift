//
//  TeamViewController.swift
//  Twitebo
//
//  Created by Tobias Scholze on 09.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

/// UserDefaults key to get or set the search configuration.
private let kUserDefaultsSearchConfigurationKey = "search-configuration"

/// `TeamViewController` provides the functionallity to search a
/// team and show all team-related information.
/// It also contains information about the team members.
class TeamViewController: UIViewController
{
    // MARK: - Outlets-

    @IBOutlet private weak var footerView: UIView!

    // MARK: - Private properties -

    /// Fullscreen blocking loading view.
    private let loadingView = LoadingView.instantiateFromNib()

    /// Collection view controller that will represent only team members.
    private var onlineMembersViewController: MembersCollectionViewController?

    /// Collection view controller that will represent all team members.
    private var allMembersViewController: MembersCollectionViewController?

    /// View controller that will represent the team's information.
    private var teamInformationViewController: TeamInformationViewController?

    /// Last search configuration.
    /// Value will be written to disk during set, and read from disk by get.
    ///
    /// If no value was found on disk, a default `SearchConfiguration`
    /// will be returned.
    private var searchConfiguration: SearchConfiguration?
    {
        set
        {
            // If new value is nil, "delete" stored property on disk.
            if newValue == nil
            {
                UserDefaults.standard.set(nil, forKey: kUserDefaultsSearchConfigurationKey)
            }

            // Ensure team name is valid.
            guard newValue?.teamName.isEmpty == false else { return }

            // Try to encode and store the new value.
            if let encoded = try? JSONEncoder().encode(newValue)
            {
                UserDefaults.standard.set(encoded, forKey: kUserDefaultsSearchConfigurationKey)
            }
        }
        get
        {
            // Try to read and parse the retrieved data into an instance of `SearchConfiguration`.
            // If this fails, return nil.
            guard let data = UserDefaults.standard.object(forKey: kUserDefaultsSearchConfigurationKey) as? Data,
                let configuration = try? JSONDecoder().decode(SearchConfiguration.self, from: data) else
            {
                return nil
            }

            return configuration
        }
    }

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

        // If no search configuration is available,
        // present `SearchScene` to create one.
        guard searchConfiguration != nil else
        {
            presentSearchView()
            return
        }

        // Load team with already created search configuration.
        loadTeam()
    }

    /// Handles the process if the loading of a team from the
    /// API has failed.
    private func handleLoadTeamFailed()
    {
        // Present alert to the user to inform that no team could be
        // loaded.
        let alertController = UIAlertController(title: "No team found",
                                                message: "There are no team with the name \(searchConfiguration?.teamName ?? "-") on Twitch.",
                                                preferredStyle: .alert)

        // After user tapps on `OK`. Show `SearchScene` and hide fullscreen loading view.
        let action = UIAlertAction(title: "OK", style: .default)
        { [weak self] _ in
            self?.presentSearchView()
            self?.loadingView.dismiss()
        }
        alertController.addAction(action)

        // Reset invalid search configuration.
        searchConfiguration = nil

        // Present alert to the user.
        present(alertController, animated: true)
    }

    /// Loads a team from the API using
    private func loadTeam()
    {
        // Ensure that required data is set.
        guard let searchConfiguration = searchConfiguration else { return }

        // Show loading view.
        loadingView.present(on: view)

        // Get values from server.
        TwiteboApi.shared.loadTeam(withName: searchConfiguration.teamName)
        { [weak self] team in
            // Ensure self exists
            guard let self = self else { return }

            // Ensure required data is set.
            guard let team = team else
            {
                // Elsewise, handle error state.
                DispatchQueue.main.async
                {
                    self.handleLoadTeamFailed()
                }
                return
            }

            // Filter team members according to `showMatureStreamer`property.
            if searchConfiguration.showMatureStreamer == false
            {
                team.members = team.members.filter { $0.isMature == false }
            }

            // Filter team members according to `showOnlyApStreamer`property.
            if searchConfiguration.showOnlyApStreamer
            {
                team.members = team.members.filter { $0.partner == true }
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

    /// Presents the `SearchScene` modally.
    private func presentSearchView()
    {
        // Instantiates the `SearchScene`.
        guard let searchVc = storyboard?.instantiateViewController(withIdentifier: "SearchScene") as? SearchViewController else
        {
            return
        }

        // Setup the search view controller.
        searchVc.setup(for: searchConfiguration ?? SearchConfiguration.empty, with: self)
        searchVc.modalPresentationStyle = .overCurrentContext
        searchVc.view.backgroundColor = UIColor.clear

        // Present the search view controller.
        present(searchVc, animated: true)
    }
}

// MARK: - MembersCollectionViewControllerDelegate -

extension TeamViewController: MembersCollectionViewControllerDelegate
{
    func membersCollectionViewControllerDidSelectMember(_: MembersCollectionViewController, member: Member)
    {
        // Ensure that member is online.
        // Elsewise, present an alert to inform the user that no stream is
        // available.
        guard member.isOnline == true else
        {
            let alertController = UIAlertController(title: "Streamer is offline",
                                                    message: "The selected streamer is offline. No stream is available to watch.",
                                                    preferredStyle: .alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: .default))
            present(alertController, animated: true)
            return
        }

        // Get a new instance of the stream view controller.
        guard let streamVc = storyboard?.instantiateViewController(withIdentifier: "StreamScene")
            as? StreamViewController else
        {
            return
        }

        // Set selected member to the instantiated view controller.
        streamVc.member = member

        // Show stream.
        present(streamVc, animated: true)
    }
}

// MARK: - TeamInformationViewControllerDelegate -

extension TeamViewController: TeamInformationViewControllerDelegate
{
    func teamInformationViewControllerRequestedSearch(_: TeamInformationViewController)
    {
        // Present search view if user requested it.
        // The Search view will trigger the `SearchViewControllerDelegate`.
        presentSearchView()
    }
}

// MARK: - SearchViewControllerDelegate -

extension TeamViewController: SearchViewControllerDelegate
{
    func searchViewController(_: SearchViewController, requestedSearchWith configuration: SearchConfiguration)
    {
        // Save new search configuration.
        searchConfiguration = configuration

        // Load team with new search configuration.
        loadTeam()
    }
}
