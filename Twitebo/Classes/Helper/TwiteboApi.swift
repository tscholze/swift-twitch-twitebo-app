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

    /// Loads `Team` object from Twitch API and enriches its data.
    ///
    /// - Parameters:
    ///   - name: Team name that will be loaded.
    ///   - completion: Completion block with optional found team.
    func loadTeam(withName name: String, _ completion: @escaping (Team?) -> Void)
    {
        // Assemble url.
        let endpoint = Configuration.twitchApiTeamsEndpoint + "/" + sanitize(teamName: name)

        // Get data frp, first endpoint.
        get(fromEndpoint: endpoint)
        { [weak self] (team: Team?) in
            // Enrich data with additonal requests.
            self?.loadOnlineStatus(forTeam: team)
            { team in
                completion(team)
            }
        }
    }

    // MARK: - Private helper -

    /// Loads online status for given team's member.
    ///
    /// - Parameters:
    ///   - team: Team of the member which will be looked for.
    ///   - completion: Completion block with optional enriched team.
    private func loadOnlineStatus(forTeam team: Team?, _ completion: @escaping (Team?) -> Void)
    {
        // Check if team has members. Elsewise complete with nil.
        guard let members = team?.members else
        {
            completion(team)
            return
        }

        // Build parameter string with each user id of member
        // E.g. exmaple.com?user_id=123&user_id=456
        var parameters = "?"
        members.forEach { parameters += "user_id=\($0.id)&" }

        // Assemble url.
        let endpoint = Configuration.twitchApiStreamsEndpoint + parameters

        // Get response from server
        get(fromEndpoint: endpoint)
        { (streams: Streams?) in
            // Get online ids.
            // The response does only contain userIds that are online.
            let onlineUserIds = streams?.data.compactMap { $0.userId } ?? []

            // Loop over members and set online status
            for member in team?.members ?? []
            {
                member.isOnline = onlineUserIds.contains(member.id)
            }

            // Call completion block with enriched data.
            completion(team)
        }
    }

    /// Performs a get request for given url and tries to parse the responded
    /// json data into given `Decodeable` object type.
    ///
    /// - Parameters:
    ///   - endpoint: Endpoint which the get request will be performed.
    ///   - completion: Optional parsed object.
    private func get<T: Decodable>(fromEndpoint endpoint: String, completion: @escaping ((T?) -> Void))
    {
        // Create url.
        guard let url = URL(string: endpoint) else
        {
            print("Could not build valid teams endpoint url")
            completion(nil)
            return
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

            // Check if required data is present.
            guard let data = data else
            {
                print("No data found.")
                completion(nil)
                return
            }

            // Try to parse the received data into given object type.
            do
            {
                let container = try self?.decoder.decode(T.self, from: data)
                completion(container)
            }
            // Log error in case of an exception.
            catch
            {
                print("---")
                print(String(data: data, encoding: .utf8) ?? "<no data found>")
                print("---")
                print("An error occured: '\(error)'")
                print("---")
            }
        }.resume()
    }

    private func sanitize(teamName: String) -> String
    {
        var name = teamName.replacingOccurrences(of: " ", with: "-")
        name = name.lowercased()
        return name
    }
}
