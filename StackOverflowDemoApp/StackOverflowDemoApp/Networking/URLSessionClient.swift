//
//  URLSessionClient.swift
//  StackOverflowDemoApp
//
//  Created by Aleksandar Geyman on 24.10.25.
//

import Foundation

final class URLSessionClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension URLSessionClient: HTTPClient {
    
    func perform(request: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data, let response = response as? HTTPURLResponse else {
                completion(.failure(UnexpectedError()))
                return
            }
            
            completion(.success(data, response))
        }
        
        task.resume()
    }
}
