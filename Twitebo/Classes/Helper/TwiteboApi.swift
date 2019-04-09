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

    /// Shared instance of the API.
    static var shared: TwiteboApi = TwiteboApi()

    // MARK: - Internal helpers -

    func loadTeam(withName _: String, _ completion: @escaping (Team?) -> Void)
    {
        // Assemble url.
        let endpoint = Configuration.twitchApiTeamsEndpoint + "/name"

        // Create url.
        guard let url = URL(string: endpoint) else
        {
            fatalError("Could not build valid teams endpoint url")
        }

        // Create request from url.
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 30)

        // Set required http header fields.
        request.setValue("application/vnd.twitchtv.v5+json", forHTTPHeaderField: "Accept")
        request.setValue("Client-ID", forHTTPHeaderField: Configuration.twitchClientId)

        URLSession.shared.dataTask(with: request)
        { _, response, error in
            // Check for erros.
            if let error = error
            {
                print("An error occured: \(error.localizedDescription)")
                completion(nil)
                return
            }

            // Check for correct response values.
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else
            {
                print("Invalid status code.")
                completion(nil)
                return
            }

            // TODO: Parsing

            completion(nil)
        }.resume()
    }
}
