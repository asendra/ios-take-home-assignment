//
//  AlbumTracksApiServiceTests.swift
//  TIDAL-AssignmentTests
//
//  Created by Alberto Sendra Estrella on 19/8/22.
//

import XCTest
@testable import TIDAL_Assignment

class AlbumTracksApiServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialization() throws {
        
        let client = MockApiClient()
        let service = AlbumTracksApiService(client: client)
        let album = Album(id: 1, title: "Album",
                          cover: URL(string: "http://api.deezer.com/album/246819422/image")!,
                          coverXL: URL(string: "http://api.deezer.com/album/246819422/image")!)
        
        let exp = expectation(description: "Loading tracks")
        
        service.getTracks(forAlbum: album) { result in
            switch result {
            case .success(let tracks):
                XCTAssertEqual(tracks.count, 12)
            case .failure(_):
                fatalError()
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }

}
