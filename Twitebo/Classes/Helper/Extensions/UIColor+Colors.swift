//
//  UIColor+Colors.swift
//  Twitebo
//
//  Created by Tobias Scholze on 12.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

/// Color set is based on:
/// https://colorpalettes.net/color-palette-2661/
extension UIColor
{
    // MARK: - Color definitions -

    /// Brand color.
    static let brand = UIColor(named: "brand")

    // Dark accent colors.
    static let accentDark = UIColor(named: "accent-dark")

    // Light accent colors.
    static let accentLight = UIColor(named: "accent-light")

    // Dark color.
    static let dark = UIColor(named: "dark")

    // Light color.
    static let light = UIColor(named: "light")

    // Online color.
    static let online = UIColor(named: "online")

    // Offline color.
    static let offline = UIColor(named: "offline")

    // MARK: - Gradients -

    // Brand color gradient.
    static let brandGradient = [brand?.cgColor, white.cgColor]
}
