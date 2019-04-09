//
//  UIView+Nib.swift
//  Twitebo
//
//  Created by Tobias Scholze on 09.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

extension UIView
{
    /// Inspired by:
    /// https://stackoverflow.com/questions/25513271/how-to-initialize-instantiate-a-custom-uiview-class-with-a-xib-file-in-swift
    private static func instanceFromNib<T: UIView>() -> T
    {
        guard let view = UINib(nibName: "\(self)", bundle: nil).instantiate(withOwner: nil, options: nil).first as? T else
        {
            fatalError("Could not load nib for \(self)")
        }

        return view
    }

    /// Instantiates itself from a nib file
    ///
    /// - Returns: Instance of self.
    static func instantiateFromNib() -> Self
    {
        return instanceFromNib()
    }
}
