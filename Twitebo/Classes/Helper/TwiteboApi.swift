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

    // MARK: - Private properties -

    // TODO: Set date format parsing values.
    private let decoder = JSONDecoder()

    // MARK: - Internal helpers -

    func loadTeam(withName name: String, _ completion: @escaping (Team?) -> Void)
    {
        // Assemble url.
        let endpoint = Configuration.twitchApiTeamsEndpoint + "/" + name

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
        request.setValue(Configuration.twitchClientId, forHTTPHeaderField: "Client-ID")

        URLSession.shared.dataTask(with: request)
        { [weak self] data, response, error in
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

            guard let data = data else
            {
                print("No data found.")
                completion(nil)
                return
            }

            do
            {
                let team = try self?.decoder.decode(Team.self, from: data)
                completion(team)
            }
            catch
            {
                print("---")
                print(String(data: data, encoding: .utf8) ?? "<no data found>")
                print("---")
                print("An error occured: '\(error)'")
            }

            completion(nil)
        }.resume()
    }
}
