//
//  HelpViewController.swift
//  WordHunt
//
//  Created by APPLE on 20/05/23.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var internalView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        internalView.layer.cornerRadius = 20
    }

}
