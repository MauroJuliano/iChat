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
    var userArray = [String: Any]()
    var user: UserData?

    var chatMessages = [ChatMessage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonShow()
        if let nameUser = user?.name {
            self.title = nameUser
        }
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
               
                let timestamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
                let reference = self.ref.child("messages")
                let childRef = reference.childByAutoId()
                let values = ["Text": messageTextField.text!,"Hour": hourMessage!, "Date": dateMessage!, "fromID": uid, "receiverID": userID]
                childRef.updateChildValues(values)
            }
            loadData()
        }
    }
    func loadData(){
        //self.chatMessages.removeAll()
        self.userArray.removeAll()
        self.ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
                let reference = self.ref.child("messages")
                reference.observe(.childAdded) { (snapshot) in
                    
                    if let users = snapshot.value as? [String: Any] {
                        for(_, value) in users {
                    
                            var userToshow = userMessage()
                            self.userArray = users
                    }
                        
                        self.loadMessage()
                }
            }
        }
    }
    
    func loadMessage(){
        
        let text2 = self.userArray["Text"]as? String
        let idfrom = self.userArray["fromID"]as? String
        print(text2, idfrom)
        
        if let uid = Auth.auth().currentUser?.uid{
            if let userID = self.user?.uid{
                
                if idfrom == uid {
                    self.chatMessages.append(ChatMessage(text: text2!, isIncoming: false))
                }else{
                    self.chatMessages.append(ChatMessage(text: text2!, isIncoming: true))
                }
            }
            self.messageTableView.reloadData()
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
