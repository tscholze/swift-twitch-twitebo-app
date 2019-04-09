//
//  UIImageView+Url.swift
//  Twitebo
//
//  Created by Tobias Scholze on 09.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

extension UIImageView
{
    /// Sets the image of self by the content of the given url.
    /// It will use the given placeholder image if no image is
    /// available yet or it will use a default name.
    ///
    /// - Parameters:
    ///   - fromUrl: Image url.
    ///   - placeholderImageName: Optional placeholder image's name.
    func image(fromUrl url: URL,
               withPlaceholderImageName placeholderImageName: String = "robot-head")
    {
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request)
        { data, _, _ -> Void in
            guard let imageData = data as Data? else
            {
                return
            }

            DispatchQueue.main.async
            {
                guard let image = UIImage(data: imageData) else
                {
                    self.image = UIImage(named: placeholderImageName)
                    return
                }

                self.image = image
            }
        }

        task.resume()
    }
}
