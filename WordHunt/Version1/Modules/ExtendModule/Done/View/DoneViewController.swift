//
//  DoneViewController.swift
//  WordHunt
//
//  Created by APPLE on 27/05/23.
//

import UIKit
import Lottie

class DoneViewController: UIViewController {
    
    @IBOutlet weak var internalViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var animationContViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneBtnHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var internalView: UIView!
    @IBOutlet weak var animationContView: UIView!
    @IBOutlet weak var modeCompletionLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    
    var animationView: LottieAnimationView?
    
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.doneBtn.layer.cornerRadius = self.doneBtn.layer.frame.height/2
            self.setAnimationView(animationName: "Celebration", speed: 1.5)
        }
        modeCompletionLbl.text = modeCompletionStr
        internalView.layer.cornerRadius = 20
    }
    
    private func setAnimationView(animationName:String, speed:Float){
        animationView = .init(name:animationName)
        animationView?.frame = animationContView.bounds
        animationView?.animationSpeed = CGFloat(speed)
        animationContView.addSubview(animationView!)
        animationView?.loopMode = .loop
        animationView?.play()
    }
    
    @IBAction func doneBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true,completion: completion)
    }
    
    
}
