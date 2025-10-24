//
//  PersistenceManager.swift
//  StackOverflowDemoApp
//
//  Created by Aleksandar Geyman on 24.10.25.
//

import Foundation

protocol PersistenceManaging {
    func set(_ value: Any?, forKey defaultName: String)
    func object(forKey defaultName: String) -> Any?
}

protocol FollowedPersistenceManaging {
    func isFollowed(id: Int) -> Bool
    func setFollowed(id: Int, isFollowed: Bool)
    func storeToPersistence()
}

final class PersistenceManager {
    private static let KEY_CONST = "PersistenceManagerKey"
    private let persistence: PersistenceManaging
    private var dynamicStorage: [String: String] = [:]
    
    init(persistence: PersistenceManaging = UserDefaults.standard) {
        self.persistence = persistence
        self.retrieveFromPersistence()
    }
    
    private func retrieveFromPersistence() {
        guard let dict = persistence.object(forKey: PersistenceManager.KEY_CONST) as? [String: String] else {
            return
        }
        
        dynamicStorage = dict
    }
}

extension PersistenceManager: FollowedPersistenceManaging {
    
    func isFollowed(id: Int) -> Bool {
        let value = dynamicStorage[String(id)] ?? ""
        return NSString(string: value).boolValue
    }
    
    func setFollowed(id: Int, isFollowed: Bool) {
        dynamicStorage[String(id)] = String(isFollowed)
    }
    
    func storeToPersistence() {
        persistence.set(dynamicStorage, forKey: PersistenceManager.KEY_CONST)
    }
}

extension UserDefaults: PersistenceManaging {}
