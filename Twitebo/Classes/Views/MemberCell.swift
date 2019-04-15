//
//  MemberCell.swift
//  Twitebo
//
//  Created by Tobias Scholze on 12.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

/// `MemberCell` is responsible to represent member-related
/// information.
class MemberCell: UICollectionViewCell
{
    // MARK: - Outlets -

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!

    // MARK: - Interal properties -

    /// Cell's identifier.
    static var identifier = "MemberCell"

    // MARK: - View life cycle -

    override func awakeFromNib()
    {
        super.awakeFromNib()

        // Setup cell's styling.
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 20

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.75
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }

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
            logoImageView.image(fromUrl: url)
        }
        else
        {
            // TODO: Show placeholder if no logo is available.
        }

        // Set text values.
        nameLabel.text = member.displayName
        statusLabel.text = member.status
    }
}
