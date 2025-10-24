//
//  UserCellModel.swift
//  StackOverflowDemoApp
//
//  Created by Aleksandar Geyman on 24.10.25.
//

import Foundation

class UserCellModel {
    let id: Int
    let name: String
    let reputation: Int
    let imageURL: String
    var isFollowed: Bool
    
    init(id: Int, name: String, reputation: Int, imageURL: String, isFollowed: Bool) {
        self.id = id
        self.name = name
        self.reputation = reputation
        self.imageURL = imageURL
        self.isFollowed = isFollowed
    }
}
