//
//  QuestionsCollectionViewCell.swift
//  WordHunt
//
//  Created by APPLE on 18/05/23.
//

import UIKit

protocol HelpPressed{
    func helpNeeded(element:WordHuntElement, type:Help, cell:QuestionsCollectionViewCell)
}
protocol Answered{
    func answered(cell:QuestionsCollectionViewCell, points:Int)
}

class QuestionsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var helpViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var helpViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerLblBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var seeWordBtn: UIButton!
    @IBOutlet weak var hintLbl: UILabel!
    @IBOutlet weak var letterCountLbl: UILabel!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var answerLbl: PaddingLabel!
    @IBOutlet weak var collectionViewAlphabet: UICollectionView!
    
    @IBOutlet weak var shuffleBtn: UIButton!
    
    var delegate:Answered?
    var helpDelegate:HelpPressed?
    var element:WordHuntElement?
    var myAnswers = [String]()
    var isAdRewarded:Bool?
    var answer:String = "" {
        didSet{
            self.answerLbl.text = answer
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIScreen.main.bounds.height <= 700{
            answerLblBottomConstraint.constant = answerLblBottomConstraint.constant - 20
        }
        if UIDevice.current.userInterfaceIdiom == .pad{
            configureForIpad()
        }
        setupUI()
    }
    
    override func prepareForReuse() {
        setupUI()
    }
    
    func setupCell(element:WordHuntElement){
        hintLbl.text = element.answers[0].hint
        letterCountLbl.text = "*No of letters \(element.answers[0].word.count)"
        self.element = element
    }
    
    private func setupUI(){
        isAdRewarded = false
        helpView.layer.cornerRadius = 5
        setupCollectionView()
        setupButtons()
        setupLbl()
        myAnswers.removeAll()
    }
    
    private func setupCollectionView(){
        collectionViewAlphabet.register(UINib(nibName: Cells.alphabetCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Cells.alphabetCollectionViewCell)
        collectionViewAlphabet.delegate = self
        collectionViewAlphabet.dataSource = self
        collectionViewAlphabet.reloadData()
    }
    
    private func setupButtons(){
        Animations().configure3DButton(button: submitBtn)
        Animations().configure3DButton(button: resetBtn)
        Animations().configure3DButton(button: seeWordBtn)
        Animations().configure3DButton(button: shuffleBtn)
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
    }
    
    private func isAnswerCorrect(isCorrect:Bool){
        isUserInteractionEnabled = false
        switch isCorrect{
        case true:
            Animations().animateCorrectAnsLbl(label: answerLbl, newText: answer, characterDelay: 0.2, animationDuration: 0.5, scale: 1.2) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                    self.answer = ""
                    self.answerLbl.textColor = .black
                    self.answerLbl.backgroundColor = .white
                    self.collectionViewAlphabet.reloadData()
                    if self.myAnswers.count == self.element?.answers.count{
                        self.isUserInteractionEnabled = false
                        self.delegate?.answered(cell: self, points: 1)
                    }
                    self.isUserInteractionEnabled = true
                }
            }
        case false:
            Animations().animateWrongAnsLbl(label: answerLbl, newText: answer, characterDelay: 0.1, animationDuration: 0.1, shakeDistance: 20) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                    self.answer = ""
                    self.answerLbl.textColor = .black
                    self.answerLbl.backgroundColor = .white
                    self.collectionViewAlphabet.reloadData()
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
            UIFunctions().showTemporaryLabel(text: "Please start typing", view: self)
        }else{
            if myAnswers.contains(answer){
                answer = ""
                UIFunctions().showTemporaryLabel(text: "Already Answered", view: self)
                collectionViewAlphabet.reloadData()
            }else if myAnswers.contains(answer) == false && checkIfStringExists(word: answer) == true{
                myAnswers.append(answer)
                isAnswerCorrect(isCorrect: true)
            }else{
                isAnswerCorrect(isCorrect: false)
            }
        }
    }
    
    @IBAction func resetBtnClicked(_ sender: UIButton) {
        isUserInteractionEnabled = false
        answer = ""
        collectionViewAlphabet.reloadData()
        isUserInteractionEnabled = true
    }
    
    @IBAction func seeWordBtnClicked(_ sender: UIButton) {
        guard let element = element else {return}
        if isAdRewarded == nil || isAdRewarded == false{
            helpDelegate?.helpNeeded(element: element, type: .word, cell: self)
        }else if isAdRewarded == true{
            answer = element.answers[0].word.uppercased()
        }
        self.collectionViewAlphabet.reloadData()
    }
    
    @IBAction func shuffleBtnClicked(_ sender: UIButton) {
        if element != nil{
            element?.chars.shuffle()
            answer = ""
            collectionViewAlphabet.reloadData()
        }
    }
}

// MARK: -  CollectionViewCells
extension QuestionsCollectionViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return element?.chars.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionViewAlphabet.dequeueReusableCell(withReuseIdentifier: Cells.alphabetCollectionViewCell, for: indexPath) as? AlphabetCollectionViewCell else {return UICollectionViewCell()}
        cell.setupCell(alphabet: element?.chars[indexPath.row].uppercased())
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
            cell.getSelectedActions(isSelected: true)
            answer = removeLastOccurrenceOf(cell.alphabetLbl.text!, from: answer)
        }else{
            cell.getSelectedActions(isSelected: false)
            answer += cell.alphabetLbl.text!
        }
        Animations().animateViewScaling(view: cell.internalView)
    }
}

extension QuestionsCollectionViewCell{
    private func removeLastOccurrenceOf(_ characterToRemove: String, from inputString: String) -> String {
        var modifiedString = inputString
        if let range = modifiedString.range(of: String(characterToRemove), options: .backwards) {
            modifiedString.replaceSubrange(range, with: "")
        }
        return modifiedString
    }
}

enum Help{
    case word
    case shuffle
}
