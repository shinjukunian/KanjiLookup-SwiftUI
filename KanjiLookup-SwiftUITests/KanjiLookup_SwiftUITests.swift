//
//  KanjiLookup_SwiftUITests.swift
//  KanjiLookup-SwiftUITests
//
//  Created by Morten Bertz on 2020/06/17.
//  Copyright © 2020 telethon k.k. All rights reserved.
//

import XCTest
@testable import KanjiLookup_SwiftUI

class KanjiLookup_SwiftUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDictionary() throws {
        let dict=KanjiDictionary(url: KanjiDictionary.dictionaryURL)
        XCTAssertNotNil(dict.kanjiCaracter(for: "手"))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
