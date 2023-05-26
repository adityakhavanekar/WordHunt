//
//  HelpViewController.swift
//  WordHunt
//
//  Created by APPLE on 20/05/23.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var btnViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var internalViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var internalView: UIView!
    
    @IBOutlet weak var highScoreLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    
    
    var completion : (()->Void)?
    var continueCompletion : (()->Void)?
    
    var scoreString:String = ""
    var highScoreString:String = ""
    var isTrue:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad{
            btnViewHeightConstraint.constant = btnViewHeightConstraint.constant*2
        }
        setupUI()
    }
    
    private func setupUI(){
        if isTrue == false{
            internalViewHeightConstraint.constant = internalViewHeightConstraint.constant - 50
        }
        if UIScreen.main.bounds.height <= 850{
            internalViewHeightConstraint.constant = internalViewHeightConstraint.constant + 70
        }
        scoreLbl.text = scoreString
        highScoreLbl.text = highScoreString
        btnView.layer.cornerRadius = 15
        internalView.layer.cornerRadius = 20
        makeViewClickable(btnView, target: self, action: #selector(handleTap))
    }
    
    @IBAction func noThanksClicked(_ sender: UIButton) {
        self.dismiss(animated: true,completion: completion)
    }
    
    @objc func handleTap() {
        performInOutAnimation(for: btnView){
            self.dismiss(animated: true,completion: self.continueCompletion)
        }
    }

}

//Animation and UI
extension HelpViewController{
    func makeViewClickable(_ view: UIView, target: Any, action: Selector) {
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(tapGesture)
    }
    
    func performInOutAnimation(for view: UIView,completion:@escaping ()->()) {
        let animationDuration = 0.05
        
        UIView.animate(withDuration: animationDuration, animations: {
            view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            view.alpha = 0.8
        }) { (_) in
            UIView.animate(withDuration: animationDuration, animations: {
                view.transform = .identity
                view.alpha = 1.0
                completion()

            })
        }
    }
//    private func addLiftedShadow(to view: UIView) {
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 2)
//        view.layer.shadowOpacity = 0.1
//        view.layer.shadowRadius = 2
//        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
//        view.layer.shouldRasterize = true
//        view.clipsToBounds = true
//        view.layer.rasterizationScale = UIScreen.main.scale
//    }
}
