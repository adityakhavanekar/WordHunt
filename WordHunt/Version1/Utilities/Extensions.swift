//
//  Extensions.swift
//  WordHunt
//
//  Created by APPLE on 18/05/23.
//

import Foundation
import UIKit

extension UILabel {

    func animate(newText: String, characterDelay: TimeInterval) {

        DispatchQueue.main.async {

            self.text = ""

            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                }
            }
        }
    }
    
    func animateNew(newText: String, characterDelay: TimeInterval, liftHeight: CGFloat) {
            let originalTransform = transform
            
            DispatchQueue.main.async {
                self.text = ""
                
                for (index, character) in newText.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                        self.text?.append(character)
                        
                        if index == newText.count - 1 {
                            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
                                self.transform = CGAffineTransform(translationX: 0, y: -liftHeight)
                            }, completion: { _ in
                                UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
                                    self.transform = originalTransform
                                }, completion: nil)
                            })
                        }
                    }
                }
            }
        }
    
    func animateNew2(newText: String, characterDelay: TimeInterval, animationDuration: TimeInterval, scale: CGFloat) {
            let originalTransform = transform
            
            DispatchQueue.main.async {
                self.text = ""
                
                for (index, character) in newText.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                        self.text?.append(character)
                        
                        if index == newText.count - 1 {
                            UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
                                let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
                                self.transform = scaleTransform
                            }, completion: { _ in
                                UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
                                    self.transform = originalTransform
                                }, completion: nil)
                            })
                        }
                    }
                }
            }
        }

}
