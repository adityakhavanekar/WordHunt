//
//  QuestionsCollectionViewCell.swift
//  WordHunt
//
//  Created by APPLE on 18/05/23.
//

import UIKit

class QuestionsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var answerLbl: PaddingLabel!
    @IBOutlet weak var collectionViewAlphabet: UICollectionView!
    @IBOutlet weak var answerLblTopConstraint: NSLayoutConstraint!
    
    var answer:String = "" {
        didSet{
            if answer == ""{
                self.answerLbl.layer.borderWidth = 0
            }else{
                self.answerLbl.layer.borderWidth = 5
            }
            self.answerLbl.text = answer
            self.animatePopEffect(for: answerLbl)
        }
    }
    
    var data = ["A","B","C","D","E","F","G","H","I","J"]   //Will be replaced by api data
    let answersData = ["CFH","ACHE"]                       //Will be replaced by api data
    var myAnswers = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        setupUI()
    }
    
    private func setupUI(){
        if UIScreen.main.bounds.height <= 700{
            answerLblTopConstraint.constant = answerLblTopConstraint.constant - 30
        }
        helpView.layer.cornerRadius = 5
        setupCollectionView()
        setupButtons()
        setupLbl()
    }
    private func setupCollectionView(){
        collectionViewAlphabet.register(UINib(nibName: "AlphabetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AlphabetCollectionViewCell")
        collectionViewAlphabet.delegate = self
        collectionViewAlphabet.dataSource = self
        collectionViewAlphabet.reloadData()
    }
    
    private func setupButtons(){
        configure3DButton(button: submitBtn)
        configure3DButton(button: resetBtn)
    }
    
    private func setupLbl(){
        self.answerLbl.layer.borderColor = UIColor.white.cgColor
        self.answerLbl.layer.borderWidth = 5
        self.answerLbl.layer.cornerRadius = 20
        self.answerLbl.clipsToBounds = true
        self.answer = ""
    }
    
    private func showTemporaryLabel(text: String) {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .black
        label.frame = CGRect(x: 0, y: 0, width: self.bounds.width / 2, height: 50)
        label.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        self.addSubview(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            label.removeFromSuperview()
        }
    }
    
    private func isAnswerCorrect(isCorrect:Bool){
        isUserInteractionEnabled = false
        switch isCorrect{
        case true:
            animateCorrectAnsLbl(label: answerLbl, newText: answer, characterDelay: 0.2, animationDuration: 0.5, scale: 1.2) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                    self.answer = ""
                    self.answerLbl.backgroundColor = .clear
                    self.collectionViewAlphabet.reloadData()
                    self.isUserInteractionEnabled = true
                }
            }
        case false:
            self.answer = ""
            self.isUserInteractionEnabled = true
            self.collectionViewAlphabet.reloadData()
            print("False")
        }
    }
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        if myAnswers.contains(answer){
            answer = ""
            showTemporaryLabel(text: "Already Answered")
            self.collectionViewAlphabet.reloadData()
        }else if myAnswers.contains(answer) == false && answersData.contains(answer){
            isAnswerCorrect(isCorrect: true)
            myAnswers.append(answer)
        }else{
            isAnswerCorrect(isCorrect: false)
            showTemporaryLabel(text: "Wrong Answer")
        }
    }
    
    @IBAction func resetBtnClicked(_ sender: UIButton) {
        isUserInteractionEnabled = false
        answer = ""
        collectionViewAlphabet.reloadData()
        isUserInteractionEnabled = true
    }
}

// CollectionViewCells
extension QuestionsCollectionViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionViewAlphabet.dequeueReusableCell(withReuseIdentifier: "AlphabetCollectionViewCell", for: indexPath) as? AlphabetCollectionViewCell else {return UICollectionViewCell()}
        cell.alphabetLbl.text = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewAlphabet.frame.width/5, height: collectionViewAlphabet.frame.height/2 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionViewAlphabet.cellForItem(at: indexPath) as? AlphabetCollectionViewCell else {return}
        if cell.isThisSelected == true{
            selectedCellAction(cell: cell, isSelected: true)
        }else{
            selectedCellAction(cell: cell, isSelected: false)
        }
        animateViewScaling(view: cell.internalView)
    }
    
    private func selectedCellAction(cell:AlphabetCollectionViewCell,isSelected:Bool){
        switch isSelected{
        case true:
            cell.isThisSelected = false
            cell.alphabetLbl.textColor = .black
            cell.internalView.backgroundColor = .white
            answer = removeFirstOccurrenceOf(cell.alphabetLbl.text!, from: answer)
        case false:
            cell.isThisSelected = true
            cell.alphabetLbl.textColor = .white
            cell.internalView.backgroundColor = .systemGreen
            answer += cell.alphabetLbl.text!
        }
    }
}

//Animations and UI/UX
extension QuestionsCollectionViewCell{
    func removeFirstOccurrenceOf(_ characterToRemove: String, from inputString: String) -> String {
        var modifiedString = inputString
        if let range = modifiedString.range(of: String(characterToRemove)) {
            modifiedString.replaceSubrange(range, with: "")
        }
        return modifiedString
    }
    
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
    
    func configure3DButton(button: UIButton) {
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.shadowColor = UIColor.init(hexString: "#013220")?.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(translationX: 0, y: 5)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                sender.transform = .identity
            })
        }
    }
    
    func animateCorrectAnsLbl(label:UILabel,newText: String, characterDelay: TimeInterval, animationDuration: TimeInterval, scale: CGFloat,completion: ((Bool)->(Void))?) {
        let originalTransform = transform
        DispatchQueue.main.async {
            label.text = ""
            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    label.text?.append(character)
                    if index == newText.count - 1 {
                        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
                            let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
                            label.transform = scaleTransform
                            label.backgroundColor = .systemGreen
                        }, completion: { _ in
                            UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
                                label.transform = originalTransform
                            }, completion: completion)
                        })
                    }
                }
            }
        }
    }
}
