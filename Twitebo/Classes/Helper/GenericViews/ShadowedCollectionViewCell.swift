//
//  ShadowedCollectionViewCell.swift
//  Twitebo
//
//  Created by Tobias Scholze on 17.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

class ShadowedCollectionViewCell: UICollectionViewCell
{
    override func awakeFromNib()
    {
        super.awakeFromNib()

        // Setup cell's styling.
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
    }
}
