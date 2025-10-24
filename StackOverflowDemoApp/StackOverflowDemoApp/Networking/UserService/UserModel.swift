//
//  UserModel.swift
//  StackOverflowDemoApp
//
//  Created by Aleksandar Geyman on 24.10.25.
//

import Foundation

struct UserModel: Codable {
    let id: Int
    let name: String
    let reputation: Int
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name = "display_name"
        case reputation
        case imageURL = "profile_image"
    }
}

struct UserServiceResponse: Codable {
    let items: [UserModel]
}
