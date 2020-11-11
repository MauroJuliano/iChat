//
//  MessagesViewController.swift
//  iChat
//
//  Created by Lestad on 2020-11-08.
//

import UIKit
import Kingfisher
import FirebaseDatabase
import FirebaseAuth
struct ChatMessage {
    let text: String
    let isIncoming: Bool
}
class MessagesViewController: UIViewController {
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendMessage: UIImageView!
    @IBOutlet var sendMessageButton: UIButton!
    var dateMessage: String?
    var hourMessage: String?
    var ref: DatabaseReference!
    var userArray = [userMessage]()
    var user: UserData?
    
//    let chatMessages = [
//        ChatMessage(text: "But if we're strong enough to let it in", isIncoming: true),
//        ChatMessage(text: "We're strong enough to let it go oh oh", isIncoming: false),
//        ChatMessage(text: "Let it all go, let it all go, let it all out now", isIncoming: true),
//        ChatMessage(text: "if I look back to the start, now I know. I see everything true, There's still a fire in my heart, my darling", isIncoming: false),
//    ]
    var chatMessages = [ChatMessage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonShow()
        
        tabBarController?.tabBar.isHidden = true
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.reloadData()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
        messageTableView.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        loadData()
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
        getHour()
    }
    @objc func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @IBAction func sendMessageButton(_ sender: Any) {
        handleSend()
    }
    func getHour(){
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        let dayFormmater = DateFormatter()
        dayFormmater.dateStyle = DateFormatter.Style.short
        dayFormmater.dateFormat = "dd"
        
        let weedayFormmater = DateFormatter()
        weedayFormmater.dateStyle = DateFormatter.Style.short
        weedayFormmater.dateFormat = "EEE"
        
        let monthsFormatter = DateFormatter()
        monthsFormatter.dateStyle = DateFormatter.Style.short
        monthsFormatter.dateFormat = "MMM"
        
        let today = dayFormmater.string(from: date)
        let months = monthsFormatter.string(from: date)
        let weekDay = weedayFormmater.string(from: date)
        
        dateMessage = "\(weekDay), \(today) \(months)"
        hourMessage = "\(hour):\(minute)"
        
    }
    func handleSend() {
        self.ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            if let userID = self.user?.uid {
                print(userID)
                let timestamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
                let reference = self.ref.child("messages").child(uid).child(userID)
                let childRef = reference.childByAutoId()
                let values = ["Text": messageTextField.text!,"Hour": hourMessage!, "Date": dateMessage!, "ID": uid] as [String : Any]
                childRef.updateChildValues(values)
                
                let newReference = self.ref.child("messages").child(userID).child(uid)
                let childNewRef = newReference.childByAutoId()
                let newValues = ["Text": messageTextField.text!,"Hour": hourMessage!, "Date": dateMessage!, "ID": uid] as [String : Any]
                childNewRef.updateChildValues(newValues)
            }
            loadData()
        }
        
    }
    func loadData(){
        self.ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            if let userID = self.user?.uid{
                let reference = self.ref.child("messages").child(uid).child(userID)
                reference.observeSingleEvent(of: .value) { (snapshot) in
                    if let users = snapshot.value as? [String: AnyObject] {
                        for(_, value) in users {

                            let userToshow = userMessage()
                            print(snapshot)
                            let messageText = value["Text"] as? String
                            let messageHour = value["Hour"] as? Int
                            let messageDate = value["Date"] as? String
                            let messageID = value["ID"] as? String

                            userToshow.messageText = messageText
                            userToshow.messageHour = messageHour
                            userToshow.messageDate = messageDate
                            userToshow.messageID = messageID
                            print(messageHour, messageText)
                            
                            self.userArray.append(userToshow)
                            self.loadMessage(user: userToshow)
                        }
                    }
                }
               
            }
        }
    }
    func loadMessage(user: userMessage){
        var arrayuser = [userMessage]()
        arrayuser.append(user)
        
        
        if let uid = Auth.auth().currentUser?.uid{
            if let userID = self.user?.uid{
                
                if user.messageID == uid {
                    self.chatMessages.append(ChatMessage(text: user.messageText!, isIncoming: false))
                    
                }
                
                if user.messageID == userID{
                    self.chatMessages.append(ChatMessage(text: user.messageText!, isIncoming: true))
                   
                }
            }
        }
        self.messageTableView.reloadData()
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
