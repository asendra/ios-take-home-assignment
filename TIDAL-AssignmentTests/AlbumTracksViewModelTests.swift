//
//  AlbumTracksViewModelTests.swift
//  TIDAL-AssignmentTests
//
//  Created by Alberto Sendra Estrella on 19/8/22.
//

import XCTest
@testable import TIDAL_Assignment

class AlbumTracksViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialization() throws {
        
        let service = MockAlbumTracksApiService(client: ApiClient())
        let artist = Artist(id: 1, name: "Test artist", picture: URL(string: "http://api.deezer.com/artist/1878/image")!)
        let album = Album(id: 1,
                          title: "Test album",
                          cover: URL(string: "http://api.deezer.com/album/246819422/image")!,
                          coverXL: URL(string: "http://e-cdn-images.dzcdn.net/images/cover/e42a0291e9acf1c8bf2512c3e04a31bf/1000x1000-000000-80-0-0.jpg")!)
        
        let viewModel = AlbumTracksViewModel(service: service, artist: artist, album: album)
        
        XCTAssertNotNil(viewModel)
        XCTAssertTrue(viewModel.artistName() == artist.name)
        XCTAssertTrue(viewModel.albumName() == album.title)
        XCTAssertTrue(viewModel.numberOfVolumes() == 0)
    }

    func testTrackFetching() throws {
        let service = MockAlbumTracksApiService(client: ApiClient())
        let artist = Artist(id: 1,
                            name: "Test artist",
                            picture: URL(string: "http://api.deezer.com/artist/1878/image")!)
        
        let album = Album(id: 1,
                          title: "Test album",
                          cover: URL(string: "http://api.deezer.com/album/246819422/image")!,
                          coverXL: URL(string: "http://e-cdn-images.dzcdn.net/images/cover/e42a0291e9acf1c8bf2512c3e04a31bf/1000x1000-000000-80-0-0.jpg")!)
        
        let viewModel = AlbumTracksViewModel(service: service, artist: artist, album: album)
        
        XCTAssertNotNil(viewModel)
        XCTAssertTrue(viewModel.artistName() == artist.name)
        XCTAssertTrue(viewModel.albumName() == album.title)
        XCTAssertTrue(viewModel.albumCover() == album.coverXL)
        XCTAssertTrue(viewModel.numberOfVolumes() == 0)
        
        viewModel.start()
        
        XCTAssertTrue(viewModel.numberOfVolumes() == 1)
        XCTAssertTrue(viewModel.volumeNameFor(section: 0) == "Volume 1")
        XCTAssertTrue(viewModel.numberOfTracksFor(section: 0) == 1)
        
        let trackData = viewModel.trackDataFor(path: IndexPath(row: 0, section: 0))
        XCTAssertTrue(trackData.title == "Test Track")
        XCTAssertTrue(trackData.position == "1.")
        XCTAssertTrue(trackData.duration == "01:40")
        XCTAssertTrue(trackData.artists == "Track Artist")
    }
    
    func testMultipleVolumes() throws {
        let service = MockAlbumTracksApiService(client: ApiClient())
        let artist = Artist(id: 1,
                            name: "Test artist",
                            picture: URL(string: "http://api.deezer.com/artist/1878/image")!)
        
        let album = Album(id: 2,
                          title: "Test album 2",
                          cover: URL(string: "http://api.deezer.com/album/246819422/image")!,
                          coverXL: URL(string: "http://e-cdn-images.dzcdn.net/images/cover/e42a0291e9acf1c8bf2512c3e04a31bf/1000x1000-000000-80-0-0.jpg")!)
        
        let viewModel = AlbumTracksViewModel(service: service, artist: artist, album: album)
    
        viewModel.start()
        
        XCTAssertTrue(viewModel.numberOfVolumes() == 2)
        XCTAssertTrue(viewModel.volumeNameFor(section: 0) == "Volume 1")
        XCTAssertTrue(viewModel.volumeNameFor(section: 1) == "Volume 2")
        XCTAssertTrue(viewModel.numberOfTracksFor(section: 0) == 1)
        
        let trackData1 = viewModel.trackDataFor(path: IndexPath(row: 0, section: 0))
        XCTAssertTrue(trackData1.title == "Test Track 1")
        XCTAssertTrue(trackData1.position == "1.")
        XCTAssertTrue(trackData1.duration == "01:40")
        XCTAssertTrue(trackData1.artists == "Track Artist")
        
        let trackData2 = viewModel.trackDataFor(path: IndexPath(row: 0, section: 1))
        XCTAssertTrue(trackData2.title == "Test Track 2")
        XCTAssertTrue(trackData2.position == "1.")
        XCTAssertTrue(trackData2.duration == "03:20")
        XCTAssertTrue(trackData2.artists == "Track Artist")
    }
    
    func testMultipleTracks() throws {
        let service = MockAlbumTracksApiService(client: ApiClient())
        let artist = Artist(id: 1,
                            name: "Test artist",
                            picture: URL(string: "http://api.deezer.com/artist/1878/image")!)
        
        let album = Album(id: 3,
                          title: "Test album 3",
                          cover: URL(string: "http://api.deezer.com/album/246819422/image")!,
                          coverXL: URL(string: "http://e-cdn-images.dzcdn.net/images/cover/e42a0291e9acf1c8bf2512c3e04a31bf/1000x1000-000000-80-0-0.jpg")!)
        
        let viewModel = AlbumTracksViewModel(service: service, artist: artist, album: album)
    
        viewModel.start()
        
        XCTAssertTrue(viewModel.numberOfVolumes() == 1)
        XCTAssertTrue(viewModel.volumeNameFor(section: 0) == "Volume 1")
        XCTAssertTrue(viewModel.numberOfTracksFor(section: 0) == 2)
        
        let trackData1 = viewModel.trackDataFor(path: IndexPath(row: 0, section: 0))
        XCTAssertTrue(trackData1.title == "Test Track 1")
        XCTAssertTrue(trackData1.position == "1.")
        XCTAssertTrue(trackData1.duration == "01:40")
        XCTAssertTrue(trackData1.artists == "Track Artist")
        
        let trackData2 = viewModel.trackDataFor(path: IndexPath(row: 1, section: 0))
        XCTAssertTrue(trackData2.title == "Test Track 2")
        XCTAssertTrue(trackData2.position == "2.")
        XCTAssertTrue(trackData2.duration == "03:20")
        XCTAssertTrue(trackData2.artists == "Track Artist")
    }
}
