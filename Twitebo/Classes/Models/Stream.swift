//
//  Stream.swift
//  Twitebo
//
//  Created by Tobias Scholze on 12.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import Foundation

// MARK: - Streams -

struct Streams: Decodable
{
    // MARK: - Internal properties -

    let data: [Stream]
}

// MARK: - Stream -

struct Stream: Decodable
{
    // MARK: - Internal properties -

    let userId: String

    // MARK: - CodingKeys -

    enum CodingKeys: String, CodingKey
    {
        case userId = "user_id"
    }
}
