//
//  Extensions.swift
//  WordHunt
//
//  Created by APPLE on 18/05/23.
//

import Foundation
import UIKit

extension UILabel {
    func animate(newText: String, characterDelay: TimeInterval, animationDuration: TimeInterval, scale: CGFloat,completion: ((Bool)->(Void))?) {
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
                            }, completion: completion)
                        })
                    }
                }
            }
        }
    }
    
}

extension UIColor {
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        hexFormatted = hexFormatted.replacingOccurrences(of: "#", with: "")
        
        let scanner = Scanner(string: hexFormatted)
        var hexValue: UInt64 = 0
        
        if scanner.scanHexInt64(&hexValue) {
            var red, green, blue: CGFloat
            
            if hexFormatted.count == 6 {
                red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                blue = CGFloat(hexValue & 0x0000FF) / 255.0
            } else {
                red = CGFloat((hexValue & 0xFF00) >> 8) / 255.0
                green = CGFloat(hexValue & 0x00FF) / 255.0
                blue = CGFloat(0x0000) / 255.0
            }
            
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return nil
        }
    }
}

extension UIView{
    func applyGradientBackground(color1: String, color2: String) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        guard let color1 = UIColor(hexString: color1)?.cgColor else {return}
        guard let color2 = UIColor(hexString: color2)?.cgColor else {return}
        
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIImageView {
    func addBlackGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.9, 1.0] // Adjust the values to control the gradient's position
        gradientLayer.frame = bounds
        
        // Add the gradient layer as a sublayer to the UIImageView
        layer.addSublayer(gradientLayer)
    }
}


extension UICollectionView {
    func scrollToNextIndex(animated: Bool = true) {
        guard let collectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        if let indexPath = indexPathForItem(at: visiblePoint) {
            var nextItem = indexPath.item + 1

            if nextItem >= numberOfItems(inSection: indexPath.section) {
                // If the next index is out of bounds, wrap around to the first index.
                nextItem = 0
            }

            let nextIndexPath = IndexPath(item: nextItem, section: indexPath.section)
            scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: animated)
        }
    }
}
