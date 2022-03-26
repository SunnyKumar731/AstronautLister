//
//  AstronautDetailsTests.swift
//  AstronautListerTests
//
//  Created by Sunny Kumar on 26/3/22.
//  Copyright © 2022 Sunny Kumar. All rights reserved.
//

import XCTest
@testable import AstronautLister

class AstronautDetailsTests: XCTestCase {
    func testSuccessScenarioForAstronautList() {
        let expectationForSuccess = XCTestExpectation(description: "Success")
        var stubNetworkHandler = StubNetworkHandler()
        stubNetworkHandler.status = NetworkStubStatus.successDetails
        let viewModel = AstronautDetailsViewModel(id: "", networkHandler: stubNetworkHandler)
        viewModel.getDetails { result in
            switch result {
            case let .success(details):
                XCTAssertTrue(details.id == 225)
                expectationForSuccess.fulfill()
            default:
                XCTFail("Error Scenario failed for AstronautList")
         }
        }
        wait(for: [expectationForSuccess], timeout: 0.2)
    }
    
    func testErrorScenarioForAstronautList() {
        let expectationForError = XCTestExpectation(description: "Success")
        var stubNetworkHandler = StubNetworkHandler()
        stubNetworkHandler.status = NetworkStubStatus.errorDetails
        let viewModel = AstronautDetailsViewModel(id: "", networkHandler: stubNetworkHandler)
        viewModel.getDetails { result in
            switch result {
            case .failure:
                expectationForError.fulfill()
            default:
                XCTFail("Error Scenario failed for AstronautList")
         }
        }
        wait(for: [expectationForError], timeout: 0.2)
    }
}
