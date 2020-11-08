//
//  ViewController.swift
//  iChat
//
//  Created by Lestad on 2020-11-08.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    
    @IBOutlet var cornerView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var backView: UIView!
    @IBOutlet var loginButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        topView.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
        loginButton.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
        backView.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens4")!)
        
        topView.roundCorners(.bottomLeft, radius: 60)
        cornerView.roundCorners(.topRight, radius: 60)
        
        // Do any additional setup after loading the view.
    }
    @IBAction func loginButton(_ sender: Any) {
        if let viewcontroller = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController() as? TabBarController {
            viewcontroller.modalPresentationStyle = .fullScreen
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

