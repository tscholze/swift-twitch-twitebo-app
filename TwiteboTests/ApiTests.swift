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
        // Test's expection
        let exp = expectation(description: "Team has been successful loaded.")

        // Load team from api.
        TwiteboApi.shared.loadTeam(withName: kDefaultTeamName)
        { team in
            // Requirements to fullfill the test:
            // 1. Team has to be set
            // 2. The team has to be the team that should be requested
            if let team = team, team.name == kDefaultTeamName
            {
                // 3. The enriched online status has to be set
                if team.members.contains(where: { $0.isOnline == nil })
                {
                    XCTFail("Not all online status values are set")
                }
            }
            else
            {
                XCTFail("Team is nil or invalid by name")
            }

            // If everything is ok, expection is fullfilled.
            exp.fulfill()
        }

        // Set test timeout.
        waitForExpectations(timeout: 2, handler: nil)
    }
}
