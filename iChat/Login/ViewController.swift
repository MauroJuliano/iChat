//
//  ViewController.swift
//  iChat
//
//  Created by Lestad on 2020-11-08.
//

import UIKit
import AVFoundation
import Firebase
class ViewController: UIViewController {
    
    @IBOutlet var textFieldView: UIView!
    @IBOutlet var textFieldView2: UIView!
    @IBOutlet var cornerView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var backView: UIView!
    @IBOutlet var loginButton: RoundedButton!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        topView.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
        loginButton.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
        backView.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens4")!)
        textFieldView.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
        textFieldView2.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
        
        topView.roundCorners(.bottomLeft, radius: 60)
        cornerView.roundCorners(.topRight, radius: 60)
        //userIsLogged()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let userID = Auth.auth().currentUser?.uid {
                if let viewcontroller = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController() as? TabBarController {
               
                viewcontroller.modalPresentationStyle = .fullScreen
                present(viewcontroller, animated: true, completion: nil)
            }
        }
    }
    
    func userIsLogged(){
        if let userID = Auth.auth().currentUser?.uid {
            print(userID)
            
                if let viewcontroller = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController() as? TabBarController {
                viewcontroller.modalPresentationStyle = .fullScreen
                present(viewcontroller, animated: true, completion: nil)
            }
        }
    }
    func alert(){
        
        let alert = UIAlertController(title: "Error", message: "Something is not right. Please try again.", preferredStyle: .alert)
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
    @IBAction func loginButton(_ sender: Any) {
        if emailTextField.text != nil && passwordTextField.text != nil {
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
                
                if error != nil {
                    self!.alert()
                }else{
                if let viewcontroller = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController() as? TabBarController {
                viewcontroller.modalPresentationStyle = .fullScreen
                self!.present(viewcontroller, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    @IBAction func RegisterButton(_ sender: Any) {
        if let viewcontroller = UIStoryboard(name: "Register", bundle: nil).instantiateInitialViewController() as? RegisterViewController {
            present(viewcontroller, animated: true, completion: nil)
        }
    }
    
}
extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}

