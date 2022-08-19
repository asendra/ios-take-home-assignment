//
//  ApiClientTests.swift
//  TIDAL-AssignmentTests
//
//  Created by Alberto Sendra Estrella on 19/8/22.
//

import XCTest
@testable import TIDAL_Assignment

class ApiClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialization() throws {
        
        let session = MockURLSession()
        let client = ApiClient(session: session)
        
        XCTAssertEqual(client.baseURL, "https://api.deezer.com/")
    }
}
