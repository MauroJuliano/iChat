//
//  HomeViewController.swift
//  iChat
//
//  Created by Lestad on 2020-11-08.
//

import UIKit
import Firebase
import FirebaseAuth
class HomeViewController: UIViewController {
    @IBOutlet var chatTableView: UITableView!
    var userArray = [ChatActivate]()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImage(systemName: "square.and.pencil")!.withTintColor(.systemIndigo)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageView, style: .plain, target: self, action: #selector(addTapped))

        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
        loadData()
        
    }
    func loadData(){
        self.userArray.removeAll()
        self.ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            let reference = self.ref.child("chatactivate").child(uid)
                reference.observe(.value) { (snapshot) in
                    
                    if let users = snapshot.value as? [String: AnyObject] {
                        for(_, value) in users {
                    
                        let userToshow = ChatActivate()
                            
                        let user = value["Name"] as? String
                        let image = value["image"] as? String
                        let text = value["Text"] as? String
                        let fromID = value["fromID"] as? String
                        let receiverID = value["receiverID"] as? String
                            
                            userToshow.name = user
                            userToshow.fromID = fromID
                            userToshow.receiverID = receiverID
                            userToshow.text = text
                            userToshow.image = image

                        
                        self.userArray.append(userToshow)
                        print(userToshow.name, userToshow.image)
                    }
                }
                    self.chatTableView.reloadData()
            }
            
           
        }
    }
    
    @objc func addTapped(){
        if let vc = UIStoryboard(name: "Friends", bundle: nil).instantiateInitialViewController() as? FriendsViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vc = UIStoryboard(name: "Messages", bundle: nil).instantiateInitialViewController() as? MessagesViewController {
//            vc.modalPresentationStyle = .fullScreen
//            navigationController?.pushViewController(vc, animated: true)
//        }
        print(userArray[indexPath.row].name, userArray[indexPath.row].image)
    }
}
extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableCell
        cell.setup(user: userArray[indexPath.row])
        return cell
    }
    
    
}
