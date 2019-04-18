//
//  SearchConfiguration.swift
//  Twitebo
//
//  Created by Tobias Scholze on 18.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import Foundation

struct SearchConfiguration: Codable
{
    let teamName: String
    let showMatureStreamer: Bool
    let showOnlyApStreamer: Bool

    static var empty: SearchConfiguration
    {
        return SearchConfiguration(teamName: "",
                                   showMatureStreamer: true,
                                   showOnlyApStreamer: false)
    }
}
