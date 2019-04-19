//
//  TeamInformationViewController.swift
//  Twitebo
//
//  Created by Tobias Scholze on 16.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

/// Name to identify the gradient layer
private let kGradientLayerIdentifier = "gradientLayer"

/// `TeamInformationViewControllerDelegate` can be adopted by an object to get
/// notified on changes in `TeamInformationViewController`.
protocol TeamInformationViewControllerDelegate: AnyObject
{
    /// Tells the delegate that the user requested a new search.
    ///
    /// - Parameter teamInformationViewController: View controller that called the delegate.
    func teamInformationViewControllerRequestedSearch(_ teamInformationViewController: TeamInformationViewController)
}

/// `TeamInformationViewController` provides all information about
/// the underlying team object.
class TeamInformationViewController: UIViewController
{
    // MARK: - Outlets -

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var infoTextView: UITextView!

    // MARK: - Private  properties -

    /// Underlying team.

    private var team: Team?

    private weak var delegate: TeamInformationViewControllerDelegate?

    // MARK: - View life cycle -

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Setup view.
        view.translatesAutoresizingMaskIntoConstraints = false

        // Clear controls
        logoImageView.image = nil
        nameLabel.text = nil
        infoTextView.text = nil
        infoTextView.attributedText = nil
        infoTextView.contentOffset = CGPoint(x: 0, y: 0)
    }

    override func viewDidLayoutSubviews()
    {
        // Clear already existing gradient
        for sublayer in view.layer.sublayers ?? [] where sublayer.name == kGradientLayerIdentifier
        {
            sublayer.removeFromSuperlayer()
        }

        // Add gradient.
        let gradientTopLayer: CAGradientLayer = CAGradientLayer()
        gradientTopLayer.name = kGradientLayerIdentifier
        gradientTopLayer.colors = UIColor.brandGradient as [Any]
        gradientTopLayer.locations = [0.0, 1.0]
        gradientTopLayer.frame = view.bounds
        view.layer.insertSublayer(gradientTopLayer, at: 0)
    }

    // MARK: - Internal helper -

    /// Sets up the view for given.
    ///
    /// - Parameter team: Underlying team.
    func setup(forTeam team: Team?, with delegate: TeamInformationViewControllerDelegate)
    {
        // Set delegate.
        self.delegate = delegate

        // Set text values.
        nameLabel.text = team?.displayName
        infoTextView.attributedText = team?.info.replacingOccurrences(of: "\n", with: "").htmlAsAttributedString

        // Load team logo from url.
        if let logo = team?.logo, let logoUrl = URL(string: logo)
        {
            logoImageView.image(fromUrl: logoUrl)
        }
    }

    // MARK: - Actions -

    @IBAction
    private func onSearchButtonTapped(_: Any)
    {
        // Call the delegate if user tapped on the search button.
        delegate?.teamInformationViewControllerRequestedSearch(self)
    }
}
