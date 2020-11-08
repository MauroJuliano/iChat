//
//  ChatTableCell.swift
//  iChat
//
//  Created by Lestad on 2020-11-08.
//

import UIKit

class ChatTableCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var lastMessageLabel: UILabel!
    @IBOutlet var roundedView: RoundedView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(user: User){
        userImageView.image = UIImage(named: user.image)
        nameLabel.text = user.name
        lastMessageLabel.text = user.lastMessage
        
        roundedView.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
    }

}
