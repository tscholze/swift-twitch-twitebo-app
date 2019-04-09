//
//  Team.swift
//  Twitebo
//
//  Created by Tobias Scholze on 09.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import Foundation

struct Team: Codable
{
    let id: Int
    let name, info, displayName: String
    let createdAt, updatedAt: Date
    let logo: String
    let banner: String?
    let background: String?
    let members: [Member]

    enum CodingKeys: String, CodingKey
    {
        case id = "_id"
        case name
        case info
        case displayName = "display_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case logo
        case banner
        case background
        case members = "users"
    }
}
