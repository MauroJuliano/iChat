//
//  SettingsTableViewCell.swift
//  iChat
//
//  Created by Lestad on 2020-11-08.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet var detailView: UIView!
    @IBOutlet var settingsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setup(){
        detailView.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
    }

}
