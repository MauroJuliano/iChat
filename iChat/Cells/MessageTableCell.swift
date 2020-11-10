//
//  MessageTableCell.swift
//  iChat
//
//  Created by Lestad on 2020-11-08.
//

import UIKit

class MessageTableCell: UITableViewCell {
//    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var bubbleView: RoundedView!
    let messageLabel = UILabel()
    var leadingConstraints: NSLayoutConstraint!
    var trailingConstraints: NSLayoutConstraint!
    
    var chatMessage: ChatMessage! {
        didSet {
            let bubble1 = UIColor(patternImage: UIImage(named: "bubble1")!)
            let bubble2 = UIColor(patternImage: UIImage(named: "bubble2")!)
            bubbleView.backgroundColor = chatMessage.isIncoming ? bubble2 : bubble1
            messageLabel.textColor = chatMessage.isIncoming ? .white : .white
            
            messageLabel.text = chatMessage.text
            
            if chatMessage.isIncoming {
                leadingConstraints.isActive = true
                trailingConstraints.isActive = false
            }else {
                leadingConstraints.isActive = false
                trailingConstraints.isActive = true
            }
        }
    }
    
        override func awakeFromNib() {
        super.awakeFromNib()
            backgroundColor = .clear
            bubbleView.backgroundColor = .yellow
            bubbleView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(bubbleView)
            messageLabel.numberOfLines = 0
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(messageLabel)
//
            let constraints = [
                
                messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
                messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
                messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
                
                bubbleView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
                bubbleView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
                bubbleView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
                bubbleView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            ]
            NSLayoutConstraint.activate(constraints)
            
            
            leadingConstraints = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
            leadingConstraints.isActive = false
            
            trailingConstraints = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
            trailingConstraints.isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setup(){
        bubbleView.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
    }
}
