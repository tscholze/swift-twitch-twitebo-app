//
//  MemberCell.swift
//  Twitebo
//
//  Created by Tobias Scholze on 12.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

/// `MemberCell` is a subclass of `ShadowedCollectionViewCell`
/// and responsible to represent member-related information.
class MemberCell: ShadowedCollectionViewCell
{
    // MARK: - Outlets -

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var matureIdentifierLabel: UILabel!
    @IBOutlet private weak var onlineIndicatorView: CircleView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!

    // MARK: - Interal properties -

    /// Cell's identifier.
    static let identifier = "MemberCell"

    // MARK: - View life cycle -

    override func prepareForReuse()
    {
        super.prepareForReuse()

        logoImageView.image = UIImage.robotHead
    }

    // MARK: - Internal helper -

    /// Sets up the cell for given member.
    ///
    /// - Parameter member: Underlying member.
    func setup(for member: Member)
    {
        // Load image.
        if let logo = member.logo,
            let url = URL(string: logo)
        {
            // Set image if not found.
            logoImageView.image(fromUrl: url)
        }
        else
        {
            // Set background to a placeholder one.
            // This state should not be occur. An image is mandatory.
            logoImageView.backgroundColor = UIColor.accentLight
        }

        // Set color values.
        if member.isOnline == true
        {
            onlineIndicatorView.backgroundColor = UIColor.online
        }
        else
        {
            onlineIndicatorView.backgroundColor = UIColor.offline
        }

        // Set text values.
        matureIdentifierLabel.text = member.isMature ? "🚨" : "👨‍👧‍👦"
        nameLabel.text = member.displayName

        // Style status label text.
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle]
        statusLabel.attributedText = NSAttributedString(string: member.status, attributes: attributes)
    }
}
