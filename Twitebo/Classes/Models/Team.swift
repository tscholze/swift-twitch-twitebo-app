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
    enum CodingKeys: String, CodingKey
    {
        case name
    }

    var name: String?
}
