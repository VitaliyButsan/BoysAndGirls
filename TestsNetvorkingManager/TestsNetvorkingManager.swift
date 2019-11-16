//
//  BoysAndGirlsTests.swift
//  BoysAndGirlsTests
//
//  Created by Vitaliy on 15.11.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import XCTest
@testable import BoysAndGirls

class NetworkManagerTests: XCTestCase {

    var netManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        netManager = NetworkManager.instance
    }

    override func tearDown() {
        netManager = nil
        super.tearDown()
    }

    // check response status code
    func testValidCallToUnsplashServerGetsHTTPStatusCode200() {
        let promise = expectation(description: "Status code: 200")
        
        netManager.request(searchingWord: "boy") { (_, response, error) in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else if statusCode == 200 {
                promise.fulfill()
            } else {
                XCTFail("Status code \(statusCode)")
            }
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    // check request host and path
    func testGetPhotosWithExpectedURLHostAndPath() {
        let promise = expectation(description: "Chack path and host")
        
        netManager.request(searchingWord: "boy") { (_, response, _) in
            guard let url = (response as? HTTPURLResponse)?.url else { return }
            XCTAssertEqual(url.host, "api.unsplash.com")
            XCTAssertEqual(url.path, "/search/photos")
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    // check UnsplashPhoto objects is received
    func testGetUnsplashPhotoObjects() {
        let promise = expectation(description: "Check received photo objects")
        var photos: [UnsplashPhoto]?
        
        netManager.request(searchingWord: "boy") { (data, _, _) in
            guard let data = data else { return }
            
            let jsonData = try! JSONDecoder().decode(PhotoDataWrapper.self, from: data)
            photos = jsonData.results
            promise.fulfill()

            XCTAssertNotNil(photos)
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    // check error is nil
    func testGetPhotosReturnError() {
        let promise = expectation(description: "Check get error")
        
        netManager.request(searchingWord: "boy") { (_, _, error) in
            XCTAssertNil(error)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    // check decode data to JSON
    func testGetPhotosInvalidJSONReturnsError() {
        let promise = expectation(description: "Check parse JSON")
        
        netManager.request(searchingWord: "boy") { (data, _, _) in
            guard let data = data else { return }
            
            let jsonData = try? JSONDecoder().decode(PhotoDataWrapper.self, from: data)
            XCTAssertNotNil(jsonData)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
}


