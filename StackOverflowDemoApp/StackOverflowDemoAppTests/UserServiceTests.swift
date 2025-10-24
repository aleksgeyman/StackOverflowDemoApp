//
//  UserServiceTests.swift
//  StackOverflowDemoAppTests
//
//  Created by Aleksandar Geyman on 24.10.25.
//

import XCTest
@testable import StackOverflowDemoApp

final class UserServiceTests: XCTestCase {
    
    func testGetAllWithSuccess() async throws {
        let response = try XCTUnwrap(HTTPURLResponse(
            url: URL(string: "https://any-url.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ))
        let userModel = UserModel(id: 0, name: "", reputation: 0, imageURL: "")
        let serviceResponse = UserServiceResponse(items: [userModel])
        let mockData = try XCTUnwrap(serviceResponse.toData)
        let sut = makeSUT(result: .success(mockData, response))
        let expectation = XCTestExpectation()
        
        sut.getAll { result in
            switch result {
            case .success:
                expectation.fulfill()
            default:
                break
            }
        }
        
        await fulfillment(of: [expectation], timeout: 0.1)
    }
    
    func testGetAllWithFailure() async throws {
        let sut = makeSUT(result: .failure(NSError(domain: "", code: 0)))
        let expectation = XCTestExpectation()
        
        sut.getAll { result in
            switch result {
            case .failure:
                expectation.fulfill()
            default:
                break
            }
        }
        
        await fulfillment(of: [expectation], timeout: 0.1)
    }
    
    private func makeSUT(result: HTTPClientResult) -> UserService {
        let client = HTTPClientMock(result: result)
        return UserService(client: client)
    }
}

fileprivate final class HTTPClientMock: HTTPClient {
    let result: HTTPClientResult
    
    init(result: HTTPClientResult) {
        self.result = result
    }
    
    func perform(request: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
        completion(result)
    }
}

fileprivate extension Encodable {
    var toData: Data? {
        return try? JSONEncoder().encode(self)
    }
}
