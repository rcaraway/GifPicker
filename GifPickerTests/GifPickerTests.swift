//
//  GifPickerTests.swift
//  GifPickerTests
//
//  Created by Robert Caraway on 2/5/18.
//  Copyright © 2018 Rob Caraway. All rights reserved.
//

import XCTest
import GifPicker

class GifPickerTests: XCTestCase {
    
    let gifManager:GifManager = GifManager.shared
    
    func testA1RequestValid() {
        let rawRequest = "\(GIPHY_BASE_URL_STRING)search?q=Money&api_key=\(API_KEY)&limit=50&offset=0"
        var request:GifRequest = GifRequest(key: API_KEY, type: .search)
        request.searchQuery = "Money"
        XCTAssert(request.queryString() == rawRequest, "Must be equal")
        
        request.offset = 23
        request.limit = 23
        request.searchQuery = "Funny"
        let rawRequest2 = "\(GIPHY_BASE_URL_STRING)search?q=Funny&api_key=\(API_KEY)&limit=23&offset=23"
        XCTAssert(rawRequest != request.queryString(), "Query string should have changed")
        XCTAssert(rawRequest2 == request.queryString(), "Query string should have updated to new value")
    }
    
    func testA2SessionTask(){
        self.measure {
            var request:GifRequest = GifRequest(key: API_KEY, type: .search)
            request.searchQuery = "Typical"
            let task:GifSessionTask = GifSessionTask(request: request)
            let expecation = self.expectation(description: "Furfilled")

            var gifs:[GifAsset] = []
            
                task.executeRequest { (gs) in
                    gifs = gs
                    expecation.fulfill()
                }
            
            waitForExpectations(timeout: 5)

            XCTAssert(gifs.count > 0, "Typical should have a count")
            guard let aGif:GifAsset = gifs.first else {
                 XCTFail("A Gif must return from search Typical")
                return
            }
            XCTAssert(aGif.thumbURL != nil, "ThumbURL must return")
            XCTAssert(aGif.URL != nil, "URL must return")
        }
        
    }
    
    
    func testA4Manager(){
        self.measure {
            let expecation = self.expectation(description: "Furfilled")
            self.gifManager.searchGifs(search: "hi", completion: { (gifs) in
                self.gifManager.searchNextPage(completion: { (moreGifs, exhausted) in
                    expecation.fulfill()
                })
            })
            waitForExpectations(timeout: 8)
        }
        
    }
    

    
}
