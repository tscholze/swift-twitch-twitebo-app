//
//  SearchViewController.swift
//  Twitebo
//
//  Created by Tobias Scholze on 18.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject
{
    func searchViewController(_ searchViewController: SearchViewController, requestedSearchWith configuration: SearchConfiguration)
}

class SearchViewController: UIViewController
{
    // MARK: - Outlets -

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var showMatureStreamerSwitch: UISwitch!
    @IBOutlet private weak var showOnlyApStreamerSwitch: UISwitch!
    @IBOutlet private weak var searchButton: UIButton!

    // MARK: - Private properties -

    private weak var delegate: SearchViewControllerDelegate?
    private var configuration: SearchConfiguration?

    private var validTeamName: String?
    {
        guard let teamName = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            teamName.isEmpty == false else
        {
            return nil
        }

        return teamName
    }

    // MARK: - View life cycle -

    override func viewDidLoad()
    {
        super.viewDidLoad()

        guard let configuration = configuration else { return }

        // Setup controls.
        nameTextField.text = configuration.teamName
        showMatureStreamerSwitch.isOn = configuration.showMatureStreamer
        showOnlyApStreamerSwitch.isOn = configuration.showOnlyApStreamer
    }

    // MARK: - Internal helper -

    func setup(for configuration: SearchConfiguration, with delegate: SearchViewControllerDelegate)
    {
        // Setup delegates.
        self.delegate = delegate
        self.configuration = configuration
    }

    // MARK: - Private helper -

    private func searchRequested()
    {
        guard let teamName = validTeamName else { return }

        let searchConfiguration = SearchConfiguration(teamName: teamName,
                                                      showMatureStreamer: showMatureStreamerSwitch.isOn,
                                                      showOnlyApStreamer: showOnlyApStreamerSwitch.isOn)

        delegate?.searchViewController(self,
                                       requestedSearchWith: searchConfiguration)

        nameTextField.resignFirstResponder()

        // TODO: Check if delegate should be fired in completion block
        dismiss(animated: true)
    }

    @IBAction
    private func onNameTextFieldValueChanged(_: Any)
    {
        if validTeamName != nil
        {
            searchButton.isEnabled = true
        }
        else
        {
            searchButton.isEnabled = false
        }
    }

    // MARK: - Actions -

    @IBAction
    private func onSearchButtonTapped(_: Any)
    {
        searchRequested()
    }

    @IBAction
    private func onCloseButtonTapped(_: Any)
    {
        dismiss(animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_: UITextField) -> Bool
    {
        searchRequested()
        return true
    }
}
