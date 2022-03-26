//
//  AstronautListerTests.swift
//  AstronautListerTests
//
//  Created by Sunny Kumar on 25/3/22.
//  Copyright © 2022 Sunny Kumar. All rights reserved.
//

import XCTest
@testable import AstronautLister

class AstronautListerTests: XCTestCase {
    func testSuccessScenarioForAstronautList() {
        let expectationForSuccess = XCTestExpectation(description: "Success")
        var stubNetworkHandler = StubNetworkHandler()
        stubNetworkHandler.status = NetworkStubStatus.successList
        let viewModel = AstronautListViewModel(networkHandler: stubNetworkHandler)
        viewModel.fetchDetails()
        _ = viewModel.dispalyDetails.sink { data in
            switch stubNetworkHandler.status {
            case .successList:
                do {
                    if try data.details.get().count > 0 {
                        expectationForSuccess.fulfill()
                    } else {
                     XCTFail("Success Scenario failed for AstronautList")
                    }
                }
                catch {
                    XCTFail("Success Scenario failed for AstronautList")
                }
            default:
                XCTFail("Success Scenario failed for AstronautList")
            }
        }
        
        wait(for: [expectationForSuccess], timeout: 0.2)
    }
    
    func testErrorScenarioForAstronautList() {
        let expectationForError = XCTestExpectation(description: "Success")
        var stubNetworkHandler = StubNetworkHandler()
        stubNetworkHandler.status = NetworkStubStatus.errorList
        let viewModel = AstronautListViewModel(networkHandler: stubNetworkHandler)
        viewModel.fetchDetails()
        _ = viewModel.dispalyDetails.sink { data in
            switch stubNetworkHandler.status {
            case .errorList:
                expectationForError.fulfill()
            default:
                XCTFail("Error Scenario failed for AstronautList")
            }
        }
        
        wait(for: [expectationForError], timeout: 0.2)
    }
    
    func testAscendingOrderForAstronautList() {
        var stubNetworkHandler = StubNetworkHandler()
        stubNetworkHandler.status = NetworkStubStatus.successList
        let viewModel = AstronautListViewModel(networkHandler: stubNetworkHandler)
        viewModel.fetchDetails()
        viewModel.updateDetails(asendingOrder: true)
        if case let .success(list) = viewModel.dispalyDetails.value.details {
           XCTAssertTrue(list.first?.id == 276)
        }
    }
    
    func testDescendingOrderForAstronautList() {
        var stubNetworkHandler = StubNetworkHandler()
        stubNetworkHandler.status = NetworkStubStatus.successList
        let viewModel = AstronautListViewModel(networkHandler: stubNetworkHandler)
        viewModel.fetchDetails()
        viewModel.updateDetails(asendingOrder: false)
        if case let .success(list) = viewModel.dispalyDetails.value.details {
           XCTAssertTrue(list.first?.id == 225)
        }
    }
    
    func testgetIDForAstronautList() {
        var stubNetworkHandler = StubNetworkHandler()
        stubNetworkHandler.status = NetworkStubStatus.successList
        let viewModel = AstronautListViewModel(networkHandler: stubNetworkHandler)
        viewModel.fetchDetails()
        viewModel.updateDetails(asendingOrder: false)
        if case .success = viewModel.dispalyDetails.value.details {
            XCTAssertTrue(viewModel.getId(at: 0) == "225")
        }
    }
    
}
