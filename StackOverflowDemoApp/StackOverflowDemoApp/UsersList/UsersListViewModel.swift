//
//  UsersListViewModel.swift
//  StackOverflowDemoApp
//
//  Created by Aleksandar Geyman on 24.10.25.
//
import Foundation

final class UsersListViewModel {
    private let service: UserServiceRetriever
    private let persistence: FollowedPersistenceManaging
    private var users: [UserCellModel] = []
    
    var usersCount: Int {
        users.count
    }
    
    init(
        service: UserServiceRetriever = UserService(),
        persistence: FollowedPersistenceManaging = PersistenceManager()
    ) {
        self.service = service
        self.persistence = persistence
    }
    
    func fetch(completion: @escaping (Bool) -> Void) {
        service.getAll { [weak self] result in
            switch result {
            case .success(let usersResponse):
                self?.setUsers(usersResponse)
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func getUser(at index: Int) -> UserCellModel? {
        guard index >= 0 && index < usersCount else {
            return nil
        }
        
        return users[index]
    }
    
    private func setUsers(_ usersResponse: [UserModel]) {
        users = usersResponse.map {
            UserCellModel(
                id: $0.id,
                name: $0.name,
                reputation: $0.reputation,
                imageURL: $0.imageURL,
                isFollowed: persistence.isFollowed(id: $0.id)
            )
        }
    }
}

extension UsersListViewModel: UserCellDelegate {
    
    func onAction(id: Int, isFollowed: Bool) {
        persistence.setFollowed(id: id, isFollowed: isFollowed)
        // TODO: Call only on app willResignActive or VC viewWillDisapper.
        persistence.storeToPersistence()
    }
}
