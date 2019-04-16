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

class TeamInformationViewController: UIViewController
{
    // MARK: - Outlets -

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var infoTextView: UITextView!

    // MARK: - Internal properties -

    /// Underlying team.
    var team: Team?

    // MARK: - View life cycle -

    override func viewDidLoad()
    {
        super.viewDidLoad()

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
    func setup(forTeam team: Team?)
    {
        // Set text values
        nameLabel.text = team?.displayName
        infoTextView.attributedText = team?.info.replacingOccurrences(of: "\n", with: "").htmlAsAttributedString
        infoTextView.sizeToFit()

        // Load team logo from url.
        if let logo = team?.logo, let logoUrl = URL(string: logo)
        {
            logoImageView.image(fromUrl: logoUrl)
        }
    }
}