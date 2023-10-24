//
//  HelpViewController.swift
//  WordHunt
//
//  Created by APPLE on 20/05/23.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var btnViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var internalView: UIView!
    @IBOutlet weak var highScoreLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    
    var endCompletion : (()->Void)?
    var continueCompletion : (()->Void)?
    
    var scoreString:String = ""
    var highScoreString:String = ""
    var isClassicTrue:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad{
            btnViewHeightConstraint.constant = btnViewHeightConstraint.constant*2
        }
        setupUI()
    }
    
    private func setupUI(){
        if isClassicTrue == false{
            highScoreLbl.isHidden = true
        }
        scoreLbl.text = scoreString
        highScoreLbl.text = highScoreString
        btnView.layer.cornerRadius = 15
        internalView.layer.cornerRadius = 20
        makeViewClickable(btnView, target: self, action: #selector(handleTap))
    }
    
    @IBAction func noThanksClicked(_ sender: UIButton) {
        self.dismiss(animated: true,completion: endCompletion)
    }
    
    @objc func handleTap() {
        self.dismiss(animated: true,completion: self.continueCompletion)
    }
    
}

extension HelpViewController{
    func makeViewClickable(_ view: UIView, target: Any, action: Selector) {
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(tapGesture)
    }
}
