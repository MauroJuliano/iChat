//
//  RegisterViewController.swift
//  iChat
//
//  Created by Lestad on 2020-11-08.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterViewController: UIViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPassTextField: UITextField!
    
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
        
    }
    func alert(data: String){
        var error: String?
        var message: String?
        if data == "Error" {
            error = data
            message = "is not possible to clonclude your register. please try again"
        }else if data == "Attention" {
            error = data
            message = "Password do not match"
        }
        
        let alert = UIAlertController(title: "\(error!)", message: "\(message!)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              
            switch action.style{
              case .default:
                    print("default")

              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")
        }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        if passwordTextField.text != nil && confirmPassTextField.text == passwordTextField.text {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: confirmPassTextField.text!) { authResult, error in
                
                if error != nil {
                    self.alert(data: "Error")
                }
                self.uid()
                if let vc = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController() as? TabBarController{
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                }
            }
        }else{
            self.alert(data: "Attention")
        }
    }
    func uid(){
        self.ref = Database.database().reference()
        let userReference = self.ref.child("users")
        if let uid = Auth.auth().currentUser?.uid {
            let newReference = userReference.child(uid)
            newReference.setValue(["Name": self.nameTextField.text!, "email": self.emailTextField.text!])
        }
        
    }
    
}
