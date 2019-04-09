//
//  ApiTests.swift
//  TwiteboTests
//
//  Created by Tobias Scholze on 09.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

@testable import Twitebo
import XCTest

/// Default team name to use in tests
private let kDefaultTeamName = "livecoders"

/// `ApiTests` contains all `TwiteboApi` related tests.
/// It will use default team name (`kDefaultTeamName`).
class ApiTests: XCTestCase
{
    /// Tests the Api.loadTeam(name:) method.
    func testLoadTeam_IsAsExpected_IfNoErrorsOccure()
    {
        let exp = expectation(description: "Team has been successful loaded.")

        TwiteboApi.shared.loadTeam(withName: kDefaultTeamName)
        { team in
            if team != nil, team?.name == kDefaultTeamName
            {
                exp.fulfill()
            }
        }

        waitForExpectations(timeout: 2, handler: nil)
    }
}
