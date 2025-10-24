//
//  UsersListViewModelTests.swift
//  StackOverflowDemoAppTests
//
//  Created by Aleksandar Geyman on 24.10.25.
//

import XCTest
@testable import StackOverflowDemoApp

final class UsersListViewModelTests: XCTestCase {
    
    func testFetchWithSuccess() async {
        let user = UserModel(id: 0, name: "name", reputation: 0, imageURL: "")
        let service = UserServiceMock(result: .success([user]))
        let persistence = FollowedPersistenceManagingMock()
        let sut = UsersListViewModel(service: service, persistence: persistence)
        let expectation = XCTestExpectation()
        var isComplete = false
        
        sut.fetch { isSuccess in
            isComplete = isSuccess
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertTrue(isComplete)
        XCTAssertEqual(sut.usersCount, 1)
    }
    
    func testFetchWithFailure() async {
        let service = UserServiceMock(result: .failure(NSError(domain: "", code: 0)))
        let sut = UsersListViewModel(service: service)
        let expectation = XCTestExpectation()
        var isComplete = true
        
        sut.fetch { isSuccess in
            isComplete = isSuccess
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertEqual(sut.usersCount, 0)
        XCTAssertFalse(isComplete)
    }
    
    func testGetUser() async {
        let user = UserModel(id: 0, name: "name", reputation: 0, imageURL: "")
        let service = UserServiceMock(result: .success([user]))
        let persistence = FollowedPersistenceManagingMock()
        let sut = UsersListViewModel(service: service, persistence: persistence)
        
        XCTAssertNil(sut.getUser(at: 0))
        
        let expectation = XCTestExpectation()
        
        sut.fetch { _ in
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertNotNil(sut.getUser(at: 0))
        XCTAssertNil(sut.getUser(at: 10))
    }
    
    func testOnAction() async throws {
        let userResponse = UserModel(id: 0, name: "name", reputation: 0, imageURL: "")
        let service = UserServiceMock(result: .success([userResponse]))
        let persistence = FollowedPersistenceManagingMock()
        let sut = UsersListViewModel(service: service, persistence: persistence)
        
        await withCheckedContinuation { continuation in
            sut.fetch { _ in
                continuation.resume()
            }
        }
        
        var user = try XCTUnwrap(sut.getUser(at: 0))
        XCTAssertFalse(user.isFollowed)
        sut.onAction(id: 0, isFollowed: true)
        await withCheckedContinuation { continuation in
            sut.fetch { _ in
                continuation.resume()
            }
        }
        user = try XCTUnwrap(sut.getUser(at: 0))
        XCTAssertTrue(user.isFollowed)
    }
}

fileprivate final class UserServiceMock: UserServiceRetriever {
    let result: GetAllUsersServiceResult
    
    init(result: GetAllUsersServiceResult) {
        self.result = result
    }
    
    func getAll(completion: @escaping (GetAllUsersServiceResult) -> Void) {
        completion(result)
    }
}

fileprivate final class FollowedPersistenceManagingMock: FollowedPersistenceManaging {
    private var storage: [Int: Bool] = [:]
    
    func isFollowed(id: Int) -> Bool {
        return storage[id] ?? false
    }
    
    func setFollowed(id: Int, isFollowed: Bool) {
        storage[id] = isFollowed
    }
    
    func storeToPersistence() { }
}
