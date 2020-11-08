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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        topView.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens2")!)
        backView.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens4")!)
        topView.roundCorners(.bottomLeft, radius: 60)
        cornerView.roundCorners(.topRight, radius: 60)
        
        // Do any additional setup after loading the view.
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

