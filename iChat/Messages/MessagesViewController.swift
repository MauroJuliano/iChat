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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.messageTableView.reloadData()
            self.moveToLastComment()
        }
    }
    
    func moveToLastComment() {
        if self.messageTableView.contentSize.height > self.messageTableView.frame.height {
            // First figure out how many sections there are
            let lastSectionIndex = self.messageTableView!.numberOfSections - 1

            // Then grab the number of rows in the last section
            let lastRowIndex = self.messageTableView!.numberOfRows(inSection: lastSectionIndex) - 1

            // Now just construct the index path
            let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)

            // Make the last row visible
            self.messageTableView?.scrollToRow(at: pathToLastRow as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        }
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
               
                let reference = self.ref.child("messages")
                let childRef = reference.childByAutoId()
                let values = ["Text": messageTextField.text!,"Hour": hourMessage!, "Date": dateMessage!, "fromID": uid, "receiverID": userID]
                childRef.updateChildValues(values)
                
                let lastMessage = messageTextField.text!
                messageTextField.text = ""
                messageTextField.resignFirstResponder()
                chatActive(lastmessage: lastMessage)
            }
            //loadData()
           
        }
    }
    func chatActive(lastmessage: String){
        self.ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            if let userID = self.user?.uid {
               
                let reference = self.ref.child("chatactivate")
                    .child(uid)
                    .child(userID)
                
                let values = ["Text": lastmessage, "fromID": uid, "receiverID": userID, "Name": user!.name, "image": user!.image]
                reference.updateChildValues(values)
            }
            loadData()
        }
    }
    func loadData(){
        self.chatMessages.removeAll()
        self.userArray.removeAll()
        self.ref = Database.database().reference()
        if (Auth.auth().currentUser?.uid) != nil {
                let reference = self.ref.child("messages")
                reference.observe(.childAdded) { (snapshot) in
                    
                    if let users = snapshot.value as? [String: Any] {
                        for(_, _) in users {
                    
                            self.userArray = users
                    }
                }
                    self.loadMessage()
            }
           
        }
    }
    
    func loadMessage(){
        
        let text2 = self.userArray["Text"]as? String
        let idfrom = self.userArray["fromID"]as? String
        
        if let uid = Auth.auth().currentUser?.uid{
            if let userID = self.user?.uid{
                
                if idfrom == uid {
                    self.chatMessages.append(ChatMessage(text: text2!, isIncoming: false))
                }else{
                    self.chatMessages.append(ChatMessage(text: text2!, isIncoming: true))
                }
            }
        }
        self.messageTableView.reloadData()
        moveToLastComment()
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
        
        let totalRow =
                  tableView.numberOfRows(inSection: indexPath.section)
              if(indexPath.row == totalRow - 1)
              {
                print("lastcell")
                print(cell.messageLabel.text!)
              }
        
        return cell
    }
    
    
}
