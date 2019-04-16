//
//  CircleView.swift
//  Twitebo
//
//  Created by Tobias Scholze on 16.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

class CircleView: UIView
{
    override func awakeFromNib()
    {
        super.awakeFromNib()

        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
    }
}
