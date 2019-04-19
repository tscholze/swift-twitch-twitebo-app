//
//  SearchViewController.swift
//  Twitebo
//
//  Created by Tobias Scholze on 18.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

/// `SearchViewControllerDelegate` can be adopted by an object to get notified on
/// changes in `SearchViewController`.
protocol SearchViewControllerDelegate: AnyObject
{
    /// Tells the delegate that the user entered a valid search configuration.
    ///
    /// - Parameters:
    ///   - searchViewController: View controller that called the delegate.
    ///   - configuration: User created search configuration.
    func searchViewController(_ searchViewController: SearchViewController, requestedSearchWith configuration: SearchConfiguration)
}

/// `SearchViewController` provides a input mask to search
/// teams.
class SearchViewController: UIViewController
{
    // MARK: - Outlets -

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var showMatureStreamerSwitch: UISwitch!
    @IBOutlet private weak var showOnlyApStreamerSwitch: UISwitch!
    @IBOutlet private weak var searchButton: UIButton!

    // MARK: - Private properties -

    /// Attached delegate.
    private weak var delegate: SearchViewControllerDelegate?

    /// Underlying search configuration.
    private var configuration: SearchConfiguration?

    /// Gets a validated string of the team name.
    /// If entered team name is not valid, it will return nil.
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

        // Ensure required data is set.
        guard let configuration = configuration else { return }

        // Setup controls.
        nameTextField.text = configuration.teamName
        showMatureStreamerSwitch.isOn = configuration.showMatureStreamer
        showOnlyApStreamerSwitch.isOn = configuration.showOnlyApStreamer

        // If an empty configuration is set, select the text input view.
        // The keyboard will be visible and ready to type without tapping
        // the control.
        if configuration.teamName.isEmpty
        {
            nameTextField.becomeFirstResponder()
        }
    }

    // MARK: - Internal helper -

    /// Sets up the view controller with given configuration and delegate.
    ///
    /// - Parameters:
    ///   - configuration: Underlying configuration.
    ///   - delegate: Observing delegate.
    func setup(for configuration: SearchConfiguration, with delegate: SearchViewControllerDelegate)
    {
        // Setup private properties.
        self.delegate = delegate
        self.configuration = configuration
    }

    // MARK: - Private helper -

    /// Will request a search by calling the delegate with updated
    /// search configuration.
    /// If configuration is valid, it will also dismiss the view.
    private func requestSearch()
    {
        // Ensure entered data is valid.
        guard let teamName = validTeamName else { return }

        // Create the search configuration.
        let searchConfiguration = SearchConfiguration(teamName: teamName,
                                                      showMatureStreamer: showMatureStreamerSwitch.isOn,
                                                      showOnlyApStreamer: showOnlyApStreamerSwitch.isOn)

        // Call delegate.
        delegate?.searchViewController(self,
                                       requestedSearchWith: searchConfiguration)

        // Dismiss view.
        dismissView()
    }

    /// Will resign all first repsonders and dismisses the view.
    private func dismissView()
    {
        nameTextField.resignFirstResponder()
        dismiss(animated: true)
    }

    /// Will be called if the text field value changes.
    @IBAction
    private func onNameTextFieldValueChanged(_: Any)
    {
        // If a valid team name has been entered,
        // enable the search button - or not.
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
        requestSearch()
    }

    @IBAction
    private func onCloseButtonTapped(_: Any)
    {
        dismissView()
    }
}

// MARK: - UITextFieldDelegate -

extension SearchViewController: UITextFieldDelegate
{
    // Will be called if an enter or "go" button has been
    /// tapped by the user.
    func textFieldShouldReturn(_: UITextField) -> Bool
    {
        requestSearch()
        return true
    }
}
