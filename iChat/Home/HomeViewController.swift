//
//  HomeViewController.swift
//  iChat
//
//  Created by Lestad on 2020-11-08.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var chatTableView: UITableView!
    var userArray = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        userArray.append(User(name: "John", lastMessage: "I'm calling you tomorrow. Good night", image: "john"))
        userArray.append(User(name: "Freiya", lastMessage: "Thanks. XOXO", image: "freiya"))
        userArray.append(User(name: "Katherine", lastMessage: "she can't go I however...", image: "katherine"))
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.reloadData()
        // Do any additional setup after loading the view.
    }

}
extension HomeViewController: UITableViewDelegate{
    
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