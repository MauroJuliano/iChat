//
//  MessagesViewController.swift
//  iChat
//
//  Created by Lestad on 2020-11-08.
//

import UIKit

class MessagesViewController: UIViewController {
    @IBOutlet var messageTableView: UITableView!
    var messageArray = ["All you have is now","get your car right now and come to me.", "Vivencia na prestação de atendimento personalizado ao cliente, envolvendo a transmissão de instruções gerais e lançamentos de ocorrências; ", "Heeeey"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        messageTableView.delegate = self
        messageTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

}
extension MessagesViewController: UITableViewDelegate{
    
}
extension MessagesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableCell
        cell.messageLabel.text = messageArray[indexPath.row]
        cell.setup()
        return cell
    }
    
    
}
