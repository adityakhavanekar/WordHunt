//
//  QuestionsCollectionViewCell.swift
//  WordHunt
//
//  Created by APPLE on 17/05/23.
//

import UIKit

class QuestionsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var answerLbl: PaddingLabel!
    @IBOutlet weak var alphabetsCollectionView: UICollectionView!
    
    var answer:String = "" {
        didSet{
            self.answerLbl.text = answer
            self.animatePopEffect(for: answerLbl)
        }
    }
    
    var alphabets = ["E","C","N","H","K","O","T"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI(){
        setupCollectionView()
        setupLbl()
    }
    
    private func setupCollectionView(){
        alphabetsCollectionView.register(UINib(nibName: "AlphabetsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AlphabetsCollectionViewCell")
        alphabetsCollectionView.delegate = self
        alphabetsCollectionView.dataSource = self
    }
    
    private func setupLbl(){
        self.answerLbl.layer.borderColor = UIColor.white.cgColor
        self.answerLbl.layer.borderWidth = 5
        animateViewScaling(view: self.answerLbl)
    }

    @IBAction func submitBtnClicked(_ sender: UIButton) {
        answerLbl.animateNew2(newText: answer, characterDelay: 0.1, animationDuration: 0.2, scale: 1.1)
//        answerLbl.animateNew(newText: answer, characterDelay: 0.1, liftHeight: 10)
//        animateLabelWithSequentialLetters(label: answerLbl)
    }
}

//CollectionView Functions
extension QuestionsCollectionViewCell:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return alphabets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = alphabetsCollectionView.dequeueReusableCell(withReuseIdentifier: "AlphabetsCollectionViewCell", for: indexPath) as! AlphabetsCollectionViewCell
        cell.internalView.layer.cornerRadius = 5
        cell.alphabetLbl.text = alphabets[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let colWidht = alphabetsCollectionView.frame.width
        let colHeight = alphabetsCollectionView.frame.height
        return CGSize(width: colWidht/5 - 5, height: colHeight/2 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = alphabetsCollectionView.cellForItem(at: indexPath) as! AlphabetsCollectionViewCell
        if cell.isThisSelected == false{
            cell.isThisSelected = true
            cell.internalView.backgroundColor = .green
            answer += cell.alphabetLbl.text!
        }else{
            cell.isThisSelected = false
            cell.internalView.backgroundColor = .white
            answer = removeFirstOccurrenceOf(cell.alphabetLbl.text!, from: answer)
        }
        animateViewScaling(view: cell.internalView)
    }
    
}


//Extra Functions
extension QuestionsCollectionViewCell{
    func removeFirstOccurrenceOf(_ characterToRemove: String, from inputString: String) -> String {
        var modifiedString = inputString
        
        if let range = modifiedString.range(of: String(characterToRemove)) {
            modifiedString.replaceSubrange(range, with: "")
        }
        
        return modifiedString
    }
}

//Animation Functions
extension QuestionsCollectionViewCell{
    func animatePopEffect(for label: UILabel) {
        label.alpha = 0.0
        label.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
            label.alpha = 1.0
            label.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                label.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { _ in
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                    label.transform = CGAffineTransform.identity
                }, completion: nil)
            })
        })
    }
    
    func animateViewScaling(view: UIView) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [], animations: {
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                view.transform = CGAffineTransform.identity
            })
        })
    }
    
    func animateLabelWithSequentialLetters(label: UILabel) {
        let duration: TimeInterval = 0.5
        let delay: TimeInterval = 0.1
        let liftHeight: CGFloat = 10.0
        
        // Set the label's initial state for the animation
        label.alpha = 0
        label.transform = CGAffineTransform(translationX: 0, y: liftHeight)
        
        // Store the original text and clear the label's text
        let originalText = label.text
        label.text = ""
        
        // Create a dispatch group to keep track of the animation completion
        let animationGroup = DispatchGroup()
        
        // Iterate through each letter in the original text
        for (index, letter) in (originalText ?? "").enumerated() {
            // Create a new label for each letter
            let letterLabel = UILabel()
            letterLabel.text = String(letter)
            letterLabel.font = label.font
            letterLabel.textColor = label.textColor
            letterLabel.sizeToFit()
            
            // Set the initial state for each letter
            letterLabel.alpha = 0
            letterLabel.transform = CGAffineTransform(translationX: 0, y: liftHeight)
            
            // Add each letter label as a subview to the original label
            label.addSubview(letterLabel)
            
            // Enter the dispatch group
            animationGroup.enter()
            
            // Animate the appearance of each letter
            UIView.animate(withDuration: duration, delay: delay * Double(index), options: [], animations: {
                letterLabel.alpha = 1
                letterLabel.transform = .identity
            }, completion: { _ in
                // Leave the dispatch group when the animation completes
                animationGroup.leave()
            })
        }
        
        // Notify when all the letters have appeared
        animationGroup.notify(queue: .main) {
            // Animate the lifting animation for the entire label
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                label.transform = .identity
            }, completion: nil)
        }
    }

}
