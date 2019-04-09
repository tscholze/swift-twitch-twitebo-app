//
//  Configuration.swift
//  Twitebo
//
//  Created by Tobias Scholze on 09.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import Foundation

/// Contains all app's configuration related
/// values.
enum Configuration
{
    // MARK: - Configureable values -

    /// Twitch API client id.
    /// See: http://dev.twitch.tv/console/apps
    static let twitchClientId = ""

    // MARK: - API Endpoint values -

    /// Endpoint for the teams request.
    static let twitchApiTeamsEndpoint = "https://api.twitch.tv/kraken/teams"
}
