//
//  ChatTableCell.swift
//  iChat
//
//  Created by Lestad on 2020-11-08.
//

import UIKit
import Kingfisher
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
    func setup(user: ChatActivate){
        
        let url = URL(string: user.image)
        //userImageView.kf.indicatorType = .activity
        userImageView.kf.setImage(with: url)
        
        //userImageView.image = UIImage(named: "freiya")
        nameLabel.text = user.name
        lastMessageLabel.text = user.text
        
        roundedView.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
    }

}
