//
//  FriendsTableViewCell.swift
//  iChat
//
//  Created by Lestad on 2020-11-09.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var viewbackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(user: UserData){
        userImage.image = UIImage(named: user.image)
        nameLabel.text = user.name
        viewbackground.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
    }

}
