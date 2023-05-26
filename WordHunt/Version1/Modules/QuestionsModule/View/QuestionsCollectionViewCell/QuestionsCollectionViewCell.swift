//
//  QuestionsCollectionViewCell.swift
//  WordHunt
//
//  Created by APPLE on 18/05/23.
//

import UIKit

enum Help{
    case word
}

protocol HelpPressed{
    func helpNeeded(element:WordHuntElement,type:Help,cell:QuestionsCollectionViewCell)
}

protocol Answered{
    func answered(cell:QuestionsCollectionViewCell,points:Int)
}

class QuestionsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var helpViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var helpViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerLblTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var seeWordBtn: UIButton!
    @IBOutlet weak var hintLbl: PaddingLabel!
    @IBOutlet weak var letterCountLbl: UILabel!
    @IBOutlet weak var hintBtn: UIButton!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var answerLbl: PaddingLabel!
    @IBOutlet weak var collectionViewAlphabet: UICollectionView!
    
    var delegate:Answered?
    var helpDelegate:HelpPressed?
    var element:WordHuntElement?
    var myAnswers = [String]()
    
    var answer:String = "" {
        didSet{
            self.answerLbl.text = answer
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIScreen.main.bounds.height <= 700{
            answerLblTopConstraint.constant = answerLblTopConstraint.constant - 30
        }
        setupUI()
    }
    
    override func prepareForReuse() {
        setupUI()
    }
    
    private func setupUI(){
        setupHintLbl()
        helpView.layer.cornerRadius = 5
        setupCollectionView()
        setupButtons()
        setupLbl()
        myAnswers.removeAll()
        if UIDevice.current.userInterfaceIdiom == .pad{
            configureForIpad()
        }
    }
    
    private func setupHintLbl(){
        hintLbl.isHidden = true
        hintLbl.layer.cornerRadius = 5
        hintLbl.layer.borderColor = UIColor.white.cgColor
        hintLbl.layer.borderWidth = 2
        hintLbl.clipsToBounds = true
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
        configure3DButtonNew(button: hintBtn)
        configure3DButton(button: seeWordBtn)
    }
    
    private func setupLbl(){
        answerLbl.layer.cornerRadius = 20
        answerLbl.clipsToBounds = true
        answer = ""
    }
    
    private func configureForIpad(){
        btnStackViewHeightConstraint.constant = btnStackViewHeightConstraint.constant + 50
        collectionViewHeightConstraint.constant = collectionViewHeightConstraint.constant + 50
        helpViewHeightConstraint.constant = helpViewHeightConstraint.constant + 30
        helpViewWidthConstraint.constant = helpViewWidthConstraint.constant + 50
        answerLblHeightConstraint.constant = answerLblHeightConstraint.constant * 2
        answerLblTopConstraint.constant = answerLblTopConstraint.constant + 30
    }
    
    private func isAnswerCorrect(isCorrect:Bool){
        isUserInteractionEnabled = false
        switch isCorrect{
        case true:
            animateCorrectAnsLbl(label: answerLbl, newText: answer, characterDelay: 0.2, animationDuration: 0.5, scale: 1.2) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                    self.answer = ""
                    self.answerLbl.textColor = .black
                    self.answerLbl.backgroundColor = .white
                    self.collectionViewAlphabet.reloadData()
                    if self.myAnswers.count == self.element?.answers.count{
//                        self.showTemporaryLabel(text: "Done")
                        print("Done")
                        self.isUserInteractionEnabled = false
                        self.delegate?.answered(cell: self, points: 1)
                    }
                    self.isUserInteractionEnabled = true
                }
            }
        case false:
            animateWrongAnsLbl(label: answerLbl, newText: answer, characterDelay: 0.1, animationDuration: 0.1, shakeDistance: 20) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                    self.answer = ""
                    self.answerLbl.textColor = .black
                    self.answerLbl.backgroundColor = .white
                    self.collectionViewAlphabet.reloadData()
                    if self.myAnswers.count == self.element?.answers.count{
//                        self.showTemporaryLabel(text: "Done")
                        print("Done")
                    }
                    self.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    private func checkIfStringExists(word: String) -> Bool {
        if (element?.answers.map { $0.word.uppercased() }.contains(word)) == true{
            return true
        }else{
            return false
        }
    }
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        if answer == ""{
            showTemporaryLabel(text: "Please start typing")
        }else{
            if myAnswers.contains(answer){
                answer = ""
                showTemporaryLabel(text: "Already Answered")
                collectionViewAlphabet.reloadData()
            }else if myAnswers.contains(answer) == false && checkIfStringExists(word: answer) == true{
                myAnswers.append(answer)
                isAnswerCorrect(isCorrect: true)
            }else{
                isAnswerCorrect(isCorrect: false)
//                showTemporaryLabel(text: "Wrong Answer")
            }
        }
    }
    
    @IBAction func resetBtnClicked(_ sender: UIButton) {
        isUserInteractionEnabled = false
        answer = ""
        collectionViewAlphabet.reloadData()
        isUserInteractionEnabled = true
    }
    @IBAction func hintTapped(_ sender: UIButton) {
        hintLbl.text = "*Hint: \(element?.answers[0].hint ?? "")"
        hintLbl.isHidden = false
        simpleAnimateLabel(hintLbl)
        print(element?.answers[0].hint ?? "")
    }
    
    @IBAction func seeWordBtnClicked(_ sender: UIButton) {
        if let element = element{
            helpDelegate?.helpNeeded(element: element, type: .word, cell: self)
        }
    }
}

// CollectionViewCells
extension QuestionsCollectionViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return element?.chars.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionViewAlphabet.dequeueReusableCell(withReuseIdentifier: "AlphabetCollectionViewCell", for: indexPath) as? AlphabetCollectionViewCell else {return UICollectionViewCell()}
        cell.alphabetLbl.text = element?.chars[indexPath.row].uppercased()
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

//Animations and UI
extension QuestionsCollectionViewCell{
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
    
    private func removeFirstOccurrenceOf(_ characterToRemove: String, from inputString: String) -> String {
        var modifiedString = inputString
        if let range = modifiedString.range(of: String(characterToRemove)) {
            modifiedString.replaceSubrange(range, with: "")
        }
        return modifiedString
    }
    
    private func animatePopEffect(for label: UILabel) {
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
    
    private func animateViewScaling(view: UIView) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [], animations: {
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                view.transform = CGAffineTransform.identity
            })
        })
    }
    
    private func configure3DButton(button: UIButton) {
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.shadowColor = UIColor.init(hexString: "#013220")?.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    private func configure3DButtonNew(button: UIButton) {
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
//        button.layer.shadowColor = UIColor.init(hexString: "#013220")?.cgColor
//        button.layer.shadowOffset = CGSize(width: 0, height: 2)
//        button.layer.shadowRadius = 2
//        button.layer.shadowOpacity = 0.5
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
    
    private func animateCorrectAnsLbl(label:UILabel,newText: String, characterDelay: TimeInterval, animationDuration: TimeInterval, scale: CGFloat,completion: ((Bool)->(Void))?) {
        let originalTransform = transform
        DispatchQueue.main.async {
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
                let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
                label.transform = scaleTransform
                label.textColor = .white
                label.backgroundColor = .systemGreen
            }, completion: { _ in
                UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
                    label.transform = originalTransform
                }, completion: completion)
            })
        }
    }
    
    private func animateWrongAnsLbl(label: UILabel, newText: String, characterDelay: TimeInterval, animationDuration: TimeInterval, shakeDistance: CGFloat, completion: ((Bool) -> Void)?) {
        let originalTransform = label.transform
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
                // Shake animation
                let shakeTransform = CGAffineTransform(translationX: -shakeDistance, y: 0)
                label.transform = shakeTransform
                label.textColor = .white
                label.backgroundColor = .systemRed
            }, completion: { _ in
                UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
                    // Restore original position
                    label.transform = originalTransform
                }, completion: completion)
            })
        }
    }
    
    func simpleAnimateLabel(_ label: UILabel) {
        let originalTransform = label.transform
        
        // Create a scale transform to make the label bigger
        let scaleTransform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        // Animate the label to the bigger size
        UIView.animate(withDuration: 0.2, animations: {
            label.transform = scaleTransform
        }) { _ in
            // After the animation completes, animate the label back to its original size
            UIView.animate(withDuration: 0.2, animations: {
                label.transform = originalTransform
            })
        }
    }
}
