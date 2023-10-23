//
//  LaunchScreenViewController.swift
//  WordHunt
//
//  Created by APPLE on 20/07/23.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    @IBOutlet weak var splashIconImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.transitionToMainScreen()
        }
    }
    
    private func prepareUI(){
        splashIconImgView.layer.cornerRadius = 20
        splashIconImgView.layer.masksToBounds = true
    }
    
    private func transitionToMainScreen(){
        let mainViewController = HomeViewController()
        pushWithFadeOut(mainViewController)
    }
    
    private func pushWithFadeOut(_ viewController: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5 // Adjust the duration as per your preference
        transition.type = .fade
        transition.subtype = .fromRight // You can change the transition direction if needed
        view.window?.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(viewController, animated: false)
    }
}
