//
//  MessageTableCell.swift
//  iChat
//
//  Created by Lestad on 2020-11-08.
//

import UIKit

class MessageTableCell: UITableViewCell {
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var bubbleView: RoundedView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setup(){
        bubbleView.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
    }
}
