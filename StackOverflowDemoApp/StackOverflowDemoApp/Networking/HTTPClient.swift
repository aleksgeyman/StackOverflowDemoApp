//
//  HTTPClient.swift
//  StackOverflowDemoApp
//
//  Created by Aleksandar Geyman on 24.10.25.
//

import Foundation

enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

protocol HTTPClient {
    func perform(request: URLRequest, completion: @escaping (HTTPClientResult) -> Void)
}
