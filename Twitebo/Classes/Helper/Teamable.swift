//
//  Teamable.swift
//  Twitebo
//
//  Created by Tobias Scholze on 16.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import Foundation

protocol Teamable: AnyObject
{
    /// Sets up the view for given team's members.
    ///
    /// - Parameter team: Underlying team.
    func setup(forTeam team: Team?)
}
