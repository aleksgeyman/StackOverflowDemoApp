//
//  UserCell.swift
//  StackOverflowDemoApp
//
//  Created by Aleksandar Geyman on 24.10.25.
//

import UIKit

protocol UserCellDelegate {
    func onAction(id: Int, isFollowed: Bool)
}

class UserCell: UITableViewCell {
    static let IDENTIFIER = "UserCell"
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reputationLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var delegate: UserCellDelegate?
    var userData: UserCellModel?
    
    @IBAction func onTapAction(_ sender: Any) {
        guard let userData else {
            return
        }
        
        userData.isFollowed.toggle()
        delegate?.onAction(id: userData.id, isFollowed: userData.isFollowed)
        setButtonState(isFollowed: userData.isFollowed)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ userData: UserCellModel) {
        self.userData = userData
        nameLabel.text = String(userData.name)
        reputationLabel.text = String(userData.reputation)
        if let url = URL(string: userData.imageURL) {
            userImage.loadImage(from: url, placeholder: UIImage(systemName: "photo"))
        }
        
        setButtonState(isFollowed: userData.isFollowed)
    }
    
    private func setButtonState(isFollowed: Bool) {
        followButton.setTitle(isFollowed ? "Followed" : "Unfollow", for: .normal)
        followButton.tintColor = isFollowed ? .blue : .red
    }
}
