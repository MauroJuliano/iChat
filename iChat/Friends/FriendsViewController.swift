//
//  FriendsViewController.swift
//  iChat
//
//  Created by Lestad on 2020-11-09.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class FriendsViewController: UIViewController {
    @IBOutlet var friendsSearchBar: UISearchBar!
    @IBOutlet var friendsTableView: UITableView!
    var userArray = [UserData]()
    var idArray = [String]()
    var ids: String?
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        loadUser()
        // Do any additional setup after loading the view.
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func loadUser(){
        self.ref = Database.database().reference()
        // read users who your following.
        if let uid = Auth.auth().currentUser?.uid {
        let reference = ref.child("Friends").child(uid)
            reference.observeSingleEvent(of: .value, with: { snapshot in
                if let users = snapshot.value as? [String: AnyObject] {
                    for (_, value) in users {
                        if let user = value["user"] as? String {
                            let userToshow = UserID()
                            
                            let user = value["user"] as? String
                            userToshow.userID = user
                            self.idArray.append(userToshow.userID)
                            
                        }
                    }
                }
                
            })
            loadData()
        }
    }
    func loadData(){
        self.ref = Database.database().reference()
    
        let reference = ref.child("users")
        reference.observeSingleEvent(of: .value) { (snapshot) in
            if let users = snapshot.value as? [String: AnyObject] {
                for(_, value) in users {
                    if let user = value["uid"] as? String{
                        
                        if self.idArray.contains(user){
                            
                        }
                    }
                }
            }
            self.loadFollowing()
        }
    }
    func loadFollowing(){
        self.ref = Database.database().reference()
        
        let reference = ref.child("users")
        reference.observeSingleEvent(of: .value) { (snapshot) in
            
            if let users = snapshot.value as? [String: AnyObject] {
                
                for(_, value) in users {
                    if let user = value["uid"] as? String{
                        
                        if self.idArray.contains(user) {
                            
                            let userToshow = UserData()
                                let user = value["Name"] as? String
                                let image = value["image"] as? String
                                let userId = value["uid"] as? String
                            
                            userToshow.name = user
                            userToshow.image = image
                            userToshow.uid = userId
                            
                            self.userArray.append(userToshow)
                            print(value)
                        }
                    }
                }
            }
            self.friendsTableView.reloadData()
        }
    }
    
}
extension FriendsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Messages", bundle: nil).instantiateInitialViewController() as? MessagesViewController{
            vc.user = userArray[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension FriendsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsTableViewCell
        cell.setup(user: userArray[indexPath.row])
        return cell
    }
    
    
}
