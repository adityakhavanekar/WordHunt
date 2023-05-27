//
//  DoneViewController.swift
//  WordHunt
//
//  Created by APPLE on 27/05/23.
//

import UIKit

class DoneViewController: UIViewController {
    
    @IBOutlet weak var internalViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var animationContViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneBtnHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var internalView: UIView!
    @IBOutlet weak var animationContView: UIView!
    @IBOutlet weak var modeCompletionLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    
    
    var modeCompletionStr:String = ""
    var completion: (()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func configureForIpad(){
        doneBtnHeightConstraint.constant = doneBtnHeightConstraint.constant * 2
        animationContViewHeightConstraint.constant = animationContViewHeightConstraint.constant + 50
    }
    
    private func setupUI(){
        if UIDevice.current.userInterfaceIdiom == .pad{
            configureForIpad()
        }
        modeCompletionLbl.text = modeCompletionStr
        internalView.layer.cornerRadius = 20
    }

    @IBAction func doneBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true,completion: completion)
    }
    
    
}
