//
//  HelpViewController.swift
//  WordHunt
//
//  Created by APPLE on 20/05/23.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var internalViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var internalView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIScreen.main.bounds.height <= 850{
            internalViewHeightConstraint.constant = internalViewHeightConstraint.constant + 70
        }
        btnView.layer.cornerRadius = 15
        internalView.layer.cornerRadius = 20
    }

}
