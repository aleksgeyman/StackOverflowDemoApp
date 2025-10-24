//
//  UserService.swift
//  StackOverflowDemoApp
//
//  Created by Aleksandar Geyman on 24.10.25.
//

import Foundation

typealias GetAllUsersServiceResult = ServiceResult<[UserModel], Error>

protocol UserServiceRetriever {
    func getAll(completion: @escaping (GetAllUsersServiceResult) -> Void)
}

final class UserService: UserServiceRetriever {
    static let URL_STRING: String = "http://api.stackexchange.com/2.2/users?page=1&pagesize=20&order=desc&sort=reputation&site=stackoverflow"
    private let client: HTTPClient
    
    init(client: HTTPClient = URLSessionClient()) {
        self.client = client
    }
    
    func getAll(completion: @escaping (GetAllUsersServiceResult) -> Void) {
        guard let urlRequest = URL(string: UserService.URL_STRING) else {
            completion(.failure(UnexpectedError()))
            return
        }
        
        client.perform(request: URLRequest(url: urlRequest)) { result in
            switch result {
            case .success(let data, _):
                guard let items = data.decode(to: UserServiceResponse.self) else {
                    completion(.failure(UnexpectedError()))
                    return
                }
                
                completion(.success(items.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension Decodable {
    
    func decode<T>(to: T.Type) -> T? where T: Decodable {
        guard let selfAsData = self as? Data else {
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: selfAsData)
    }
}
