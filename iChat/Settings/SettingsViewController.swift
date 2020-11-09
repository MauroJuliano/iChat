//
//  SettingsViewController.swift
//  iChat
//
//  Created by Lestad on 2020-11-08.
//

import UIKit
import Firebase
import FirebaseAuth
class SettingsViewController: UIViewController {
    @IBOutlet var settingsTableView: UITableView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var logoutButton: RoundedButton!
    
    var settingsArray = ["Add friend","About us","Contact us","Chats", "Notifications"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.image = UIImage(named: "irina")
        usernameLabel.text = "Irina"
        emailLabel.text = "irina@email.com"
        
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        
        logoutButton.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
        // Do any additional setup after loading the view.
    }

    @IBAction func logoutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ViewController{
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}
extension SettingsViewController: UITableViewDelegate{
   
}
extension SettingsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
        cell.settingsLabel.text = settingsArray[indexPath.row]
        cell.setup()
        return cell
    }
    
    
}
