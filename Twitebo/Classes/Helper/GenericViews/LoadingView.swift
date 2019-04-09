//
//  LoadingView.swift
//  Twitebo
//
//  Created by Tobias Scholze on 09.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

/// `LoadingView` reprents a fullscreen view blocking
/// loading animation.
class LoadingView: UIView
{
    // MARK: - Outlets -

    @IBOutlet private weak var imageView: UIImageView!

    // MARK: - Helper -

    /// Presents the loadingview on a given view or without animation.
    ///
    /// - Parameters:
    ///   - view: View the loading view should be added to
    ///   - animated: Defines wether the view will fade in or pop in.
    func present(on view: UIView, animated: Bool = false)
    {
        if superview != view
        {
            removeFromSuperview()
        }

        defer
        {
            // Disable scrolling if superview is a scrollview
            if let scrollview = superview as? UIScrollView
            {
                scrollview.isScrollEnabled = false
            }

            if animated
            {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                    self.alpha = 1
                })
            }
            else
            {
                alpha = 1
            }

            startAnimation()
        }

        // Only add loadingview to given view, if not already added
        guard superview == nil else
        {
            return
        }

        // Add view to base view and align it
        view.addSubview(self)

        let top = NSLayoutConstraint(item: self,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: view,
                                     attribute: .top,
                                     multiplier: 1,
                                     constant: 0)

        let leading = NSLayoutConstraint(item: self,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: view,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: 0)

        let trailing = NSLayoutConstraint(item: self,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: view,
                                          attribute: .trailing,
                                          multiplier: 1,
                                          constant: 0)

        let bottom = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: 0)

        top.isActive = true
        leading.isActive = true
        trailing.isActive = true
        bottom.isActive = true
    }

    /// Dismisses the loading view
    ///
    /// - Parameter animated: If `true`, the view will have a fade out (default value: true)
    func dismiss(animated: Bool = true)
    {
        defer
        {
            // Re-enable scrolling if superview is a scrollview
            if let scrollview = superview as? UIScrollView
            {
                scrollview.isScrollEnabled = true
            }
        }

        guard animated else
        {
            alpha = 0.0
            stopAnimation()
            return
        }

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: { _ in
            self.stopAnimation()
        })
    }

    // MARK: - Private Helper -

    private func startAnimation()
    {
        stopAnimation()

        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = 2.0 * .pi
        animation.duration = 3
        animation.isCumulative = true
        animation.repeatCount = Float.greatestFiniteMagnitude
        imageView.layer.add(animation, forKey: "rotationAnimation")
    }

    private func stopAnimation()
    {
        imageView.layer.removeAllAnimations()
    }
}
