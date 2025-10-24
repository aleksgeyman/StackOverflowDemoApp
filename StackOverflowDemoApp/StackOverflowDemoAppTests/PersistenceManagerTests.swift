//
//  PersistenceManagerTests.swift
//  StackOverflowDemoAppTests
//
//  Created by Aleksandar Geyman on 24.10.25.
//

import XCTest
@testable import StackOverflowDemoApp

final class PersistenceManagerTests: XCTestCase {
    
    func testIsFollowed() {
        let sut = makeSUT()
        
        sut.setFollowed(id: 0, isFollowed: true)
        sut.setFollowed(id: 1, isFollowed: false)
        
        XCTAssertTrue(sut.isFollowed(id: 0))
        XCTAssertFalse(sut.isFollowed(id: 1))
        XCTAssertFalse(sut.isFollowed(id: 2))
    }
    
    func testSetFollowed() {
        let sut = makeSUT()
        
        sut.setFollowed(id: 0, isFollowed: true)
        sut.setFollowed(id: 1, isFollowed: false)
        
        XCTAssertTrue(sut.isFollowed(id: 0))
        XCTAssertFalse(sut.isFollowed(id: 1))
        XCTAssertFalse(sut.isFollowed(id: 2))
    }
    
    func testStoreToPersistence() {
        let persistence = PersistenceManagingMock()
        var sut = PersistenceManager(persistence: persistence)
        
        sut.setFollowed(id: 0, isFollowed: true)
        sut.storeToPersistence()
        sut = PersistenceManager(persistence: persistence)
        
        XCTAssertTrue(sut.isFollowed(id: 0))
    }
    
    private func makeSUT() -> PersistenceManager {
        PersistenceManager(persistence: PersistenceManagingMock())
    }
}

fileprivate final class PersistenceManagingMock: PersistenceManaging {
    private var storage: [String: [String: String]] = [:]
    
    func set(_ value: Any?, forKey defaultName: String) {
        storage["Key"] = value as? [String: String]
    }
    
    func object(forKey defaultName: String) -> Any? {
        storage["Key"]
    }
}
