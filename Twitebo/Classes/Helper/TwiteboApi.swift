//
//  TwiteboApi.swift
//  Twitebo
//
//  Created by Tobias Scholze on 09.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import Foundation

/// `TwiteboApi` is a static container class for all
/// request-related methods of the app.
class TwiteboApi
{
    // MARK: - Internal properties -

    static var shared: TwiteboApi = TwiteboApi()

    // MARK: - Internal helpers -

    func loadTeam(_ completion: (Team?) -> Void)
    {
        completion(nil)
    }
}
