//
//  QiitaAPIExTests.swift
//  QiitaAPIExTests
//
//  Created by EnchantCode on 2020/07/08.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import XCTest
@testable import QiitaAPIEx

class QiitaAPIExTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        var path = URL(string: "https://qiita.com")!
        path.appendPathComponent("/api/v2/auth")
        
        var params: [String: String] = [:]
        params["content-type"] = "json"
        params["content-size"] = "114514"
        print(path.setParams(params))
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
