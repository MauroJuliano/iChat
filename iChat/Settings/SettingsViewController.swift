//
//  SettingsViewController.swift
//  iChat
//
//  Created by Lestad on 2020-11-08.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseAuth
import FirebaseDatabase
class SettingsViewController: UIViewController {
    @IBOutlet var settingsTableView: UITableView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var logoutButton: RoundedButton!
    var ref: DatabaseReference!
    
    var settingsArray = ["Add friend","About us","Contact us","Chats", "Notifications"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.title = "Settings"
        navigationController?.navigationBar.isHidden = true
        
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        
        logoutButton.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
        setupUser()
        // Do any additional setup after loading the view.
    }
    func setupUser(){
        self.ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        let reference = ref.child("users")
        reference.observeSingleEvent(of: .value) { (snapshot) in
            
            if let users = snapshot.value as? [String: AnyObject] {
                
                for(_, value) in users {
                    if let user = value["uid"] as? String{
                        if user == uid {
                            
                            let userToshow = UserData()
                            
                                let user = value["Name"] as? String
                                let image = value["image"] as? String
                                let email = value["email"] as? String
                            
                            userToshow.name = user
                            userToshow.image = image
                            userToshow.email = email
                            
                            //pass data to outlets
                            let url = URL(string: userToshow.image)
                            self.userImage.kf.setImage(with: url)
                            
                            self.usernameLabel.text = userToshow.name
                            self.emailLabel.text = userToshow.email
                        }
                    }
                }
            }
        }
    }
    func addFriend(){
        let alert = UIAlertController(title: "Invite a friend",
                                      message: "Enter the email of your friend",
                                      preferredStyle: .alert)
        
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "placeholder"
            textField.tag = 10
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let addButton = UIAlertAction(title: "Send", style: .default) { _ in
            if let textField = alert.textFields?.first, let text = textField.text {
                self.inviteFriend(email: text)
            }
        }
        
        alert.addAction(cancelButton)
        alert.addAction(addButton)
        present(alert, animated: true, completion: nil)
    }
    
    func inviteFriend(email: String){
        self.ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        let friendsReference = self.ref.child("Friends").child(uid!).childByAutoId()
        let userReference = self.ref.child("users")
        
        self.ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if let users = snapshot.value as? [String: AnyObject]{
            //search email user in database
                
            for(_, value) in users{
                if let emailUser = value["email"] as? String {
                    if emailUser == email {
            //get and pass UID to follower friends.
                        
                        if let userID = value["uid"]{
                            if let uid = Auth.auth().currentUser?.uid {
                                friendsReference.setValue(["user": userID!])
                            }
                        }
                    }
                }
            }
            }
        })

    }
    @IBAction func newMessageButton(_ sender: Any) {
        if let vc = UIStoryboard(name: "Friends", bundle: nil).instantiateInitialViewController() as? FriendsViewController {
            print("friends")
            
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            
        }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SettingsTableViewCell
        let info = cell.settingsLabel.text!
        
        if info == "Add friend"{
            self.addFriend()
        }
    }
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
