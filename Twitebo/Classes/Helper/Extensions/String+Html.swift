//
//  String+Html.swift
//  Twitebo
//
//  Created by Tobias Scholze on 14.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

extension String
{
    // MARK: - Private properties -

    /// Gets the html `<style>` tag to unify html-based
    /// `NSAttributedString` with the app's style.
    private var prefixedHtmlStyling: String
    {
        return "<style>body{ padding: 0; margin: 0; font-size: 14px; font-family: -apple-system,system-ui; color: #011D44; line-height: 20px;}</style>"
    }

    // MARK: - Internal prperties -

    /// Gets a html-based string as an `NSAttributedString`.
    /// Inspired by: https://medium.com/swift2go/swift-how-to-convert-html-using-nsattributedstring-8c6ffeb7046f
    var htmlAsAttributedString: NSAttributedString
    {
        // Check if raw data is valid.
        let styledString = prefixedHtmlStyling + self

        guard let stringData = styledString.data(using: .utf8) else
        {
            return NSAttributedString()
        }

        // Try to convert string.
        do
        {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue,
            ]

            return try NSAttributedString(data: stringData,
                                          options: options,
                                          documentAttributes: nil)
        }

        // In case of an exception, return an empty attributed string.
        catch
        {
            print("An error occured during html to attributed string convertions")
            return NSAttributedString()
        }
    }
}
