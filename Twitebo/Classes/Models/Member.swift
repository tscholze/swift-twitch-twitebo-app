//
//  Member.swift
//  Twitebo
//
//  Created by Tobias Scholze on 09.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import Foundation

struct Member: Codable
{
    let id: String
    let isMature: Bool
    let status: String
    let broadcasterLanguage: String
    let displayName: String
    let game: String
    let language: String
    let name: String
    let createdAt: Date
    let updatedAt: Date
    let logo: String?
    let videoBanner: String?
    let profileBanner: String?
    let profileBannerBackgroundColor: String?
    let partner: Bool
    let url: String
    let views: Int
    let followers: Int

    enum CodingKeys: String, CodingKey
    {
        case id = "_id"
        case isMature = "mature"
        case status
        case broadcasterLanguage = "broadcaster_language"
        case displayName = "display_name"
        case game
        case language
        case name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case logo
        case videoBanner = "video_banner"
        case profileBanner = "profile_banner"
        case profileBannerBackgroundColor = "profile_banner_background_color"
        case partner
        case url
        case views
        case followers
    }
}
