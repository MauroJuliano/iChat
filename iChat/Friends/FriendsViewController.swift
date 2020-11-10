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
    var userArray = [User]()
    var idArray = [String]()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        loadData()
        // Do any additional setup after loading the view.
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func loadData(){
        self.ref = Database.database().reference()
        // read users who your following.
        if let uid = Auth.auth().currentUser?.uid {
        let reference = ref.child("Friends").child(uid)
            reference.observeSingleEvent(of: .value, with: { snapshot in
                if let users = snapshot.value as? [String: AnyObject] {
                    for (_, value) in users {
                        if let user = value["user"] as? String {
                            self.idArray = [user]
                            print(self.idArray)
                        }
                    }
                }
                
            })
        }
    }
    
}
extension FriendsViewController: UITableViewDelegate{
    
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
