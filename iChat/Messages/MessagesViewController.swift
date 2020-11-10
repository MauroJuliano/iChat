//
//  MessagesViewController.swift
//  iChat
//
//  Created by Lestad on 2020-11-08.
//

import UIKit
import Kingfisher

struct ChatMessage {
    let text: String
    let isIncoming: Bool
}
class MessagesViewController: UIViewController {
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendMessage: UIImageView!
    @IBOutlet var sendMessageButton: UIButton!
    
    var user: UserData?
    
    let chatMessages = [
        ChatMessage(text: "But if we're strong enough to let it in", isIncoming: true),
        ChatMessage(text: "We're strong enough to let it go oh oh", isIncoming: false),
        ChatMessage(text: "Let it all go, let it all go, let it all out now", isIncoming: true),
        ChatMessage(text: "if I look back to the start, now I know. I see everything true, There's still a fire in my heart, my darling", isIncoming: false),        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonShow()
        
        tabBarController?.tabBar.isHidden = true
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
        messageTableView.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func buttonShow(){
        if messageTextField.text!.isEmpty || messageTextField.text == "" {
            sendMessage.isHidden = true
            sendMessageButton.isHidden = true
        }else{
            sendMessage.isHidden = false
            sendMessageButton.isHidden = false
        }
    }
    @objc func keyboardWillChange(notification: NSNotification){
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= keyboardFrame.height
        }
        buttonShow()
    }
    @objc func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @IBAction func sendMessageButton(_ sender: Any) {
    }
    
    

    @IBAction func backButton(_ sender: Any) {
        if let vc = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController() as? TabBarController{
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
}
extension MessagesViewController: UITableViewDelegate{
    
}
extension MessagesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableCell

        let chatMessage = chatMessages[indexPath.row]
        cell.chatMessage = chatMessage
        return cell
    }
    
    
}
