//
//  UIFunctions.swift
//  WordHunt
//
//  Created by Neosoft on 23/10/23.
//

import Foundation
import UIKit

class UIFunctions{
    func showTemporaryLabel(text: String,view:UIView) {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .black
        label.frame = CGRect(x: 0, y: 0, width: view.bounds.width / 2, height: 50)
        label.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        view.addSubview(label)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            label.removeFromSuperview()
        }
    }
    func showAlert(title:String,message:String,preferedStyle:UIAlertController.Style,action:UIAlertAction,controller:UIViewController){
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: preferedStyle)
        let action = action
        alertcontroller.addAction(action)
        controller.present(alertcontroller, animated: true)
    }
    
    func showActivityIndicator(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        view.isUserInteractionEnabled = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }
    
    func hideActivityIndicator(activityIndicator: UIActivityIndicatorView,in view: UIView) {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
}

class Animations{
    func animateViewScaling(view: UIView) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [], animations: {
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                view.transform = CGAffineTransform.identity
            })
        })
    }
    
    func configure3DButton(button: UIButton,target: Any, action: Selector) {
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.shadowColor = UIColor.init(hexString: "#013220")?.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        button.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func animateButton(button:UIButton){
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(translationX: 0, y: 5)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                button.transform = .identity
            })
        }
    }
    
    func animateCorrectAnsLbl(label:UILabel,newText: String, characterDelay: TimeInterval, animationDuration: TimeInterval, scale: CGFloat,completion: ((Bool)->(Void))?) {
        let originalTransform = label.transform
        DispatchQueue.main.async {
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
                let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
                label.transform = scaleTransform
                label.textColor = .white
                label.backgroundColor = .init(hexString: ColorEnums.correct.rawValue)
            }, completion: { _ in
                UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
                    label.transform = originalTransform
                }, completion: completion)
            })
        }
    }
    func animateWrongAnsLbl(label: UILabel, newText: String, characterDelay: TimeInterval, animationDuration: TimeInterval, shakeDistance: CGFloat, completion: ((Bool) -> Void)?) {
        let originalTransform = label.transform
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
                let shakeTransform = CGAffineTransform(translationX: -shakeDistance, y: 0)
                label.transform = shakeTransform
                label.textColor = .white
                label.backgroundColor = .init(hexString: ColorEnums.wrong.rawValue)
            }, completion: { _ in
                UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
                    label.transform = originalTransform
                }, completion: completion)
            })
        }
    }
    
    
}
