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
            // Requirements to fullfill the test:
            // 1. Team has to be set
            // 2. The team has to be the team that should be requested
            // 3. he enriched online status has to be set
            if team != nil, team?.name == kDefaultTeamName
            {
                for member in team?.members ?? []
                {
                    if member.isOnline == nil
                    {
                        XCTFail("`isOnline` has to be set")
                    }
                }

                exp.fulfill()
            }
        }

        waitForExpectations(timeout: 2, handler: nil)
    }
}
