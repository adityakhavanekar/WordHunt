//
//  QuestionsCollectionViewCellV2.swift
//  WordHunt
//
//  Created by Neosoft on 13/09/23.
//

import UIKit

class QuestionsCollectionViewCellV2: UICollectionViewCell {

    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var answerLabel: PaddingLabel!
    @IBOutlet weak var alphabetCollectionView: UICollectionView!
    
    var element: WordHuntElementV2?
    
    var answer = ""{
        didSet{
            self.answerLabel.text = answer
        }
    }
    var processedIndexPaths: Set<IndexPath> = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    override func prepareForReuse() {
        self.alphabetCollectionView.reloadData()
    }
    
    private func configureCollectionView(){
        alphabetCollectionView.register(UINib(nibName: "AlphabetCollectionViewCellV2", bundle: nil), forCellWithReuseIdentifier: "AlphabetCollectionViewCellV2")
        alphabetCollectionView.backgroundColor = .lightGray
        alphabetCollectionView.delegate = self
        alphabetCollectionView.dataSource = self
        alphabetCollectionView.collectionViewLayout = CircularCollectionViewLayout(cellSize: CGSize(width: 70, height: 70))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        alphabetCollectionView.addGestureRecognizer(panGesture)
    }
    
    @IBAction func shuffleButtonClicked(_ sender: UIButton) {
        self.element?.chars.shuffle()
        self.alphabetCollectionView.reloadData()
    }
    
    func setupCell(element:WordHuntElementV2){
        self.element = element
        self.hintLabel.text = element.answers[0].hint
    }
}

//MARK: - Handling Pan Gesture on collectionView
extension QuestionsCollectionViewCellV2{
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: alphabetCollectionView)
        
        switch gesture.state {
        case .began:
            processedIndexPaths.removeAll()
            if let indexPath = alphabetCollectionView.indexPathForItem(at: location) {
                alphabetCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                let cell = alphabetCollectionView.cellForItem(at: indexPath) as? AlphabetCollectionViewCellV2
                cell?.backgroundColor = .green
                if let alpha = cell?.alphabetLbl.text{
                    answer+=alpha
                }
                processedIndexPaths.insert(indexPath)
            }
        case .changed:
            if let indexPath = alphabetCollectionView.indexPathForItem(at: location) {
                if processedIndexPaths.contains(indexPath) {
                    return
                }
                alphabetCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                let cell = alphabetCollectionView.cellForItem(at: indexPath) as? AlphabetCollectionViewCellV2
                if let alpha = cell?.alphabetLbl.text{
                    answer+=alpha
                }
                cell?.backgroundColor = .green
                processedIndexPaths.insert(indexPath)
            }
        case .ended, .cancelled:
            for indexPath in processedIndexPaths {
                alphabetCollectionView.deselectItem(at: indexPath, animated: true)
                let cell = alphabetCollectionView.cellForItem(at: indexPath) as? AlphabetCollectionViewCellV2
                cell?.backgroundColor = .white // Revert the cell to its normal state
            }
            if answer == element?.answers[0].word.uppercased(){
                animateCorrectAnsLbl(label: answerLabel, newText: answer, characterDelay: 0.2, animationDuration: 0.5, scale: 1.2) { _ in
                    self.answer = ""
                    self.processedIndexPaths.removeAll()
                }
            }else{
                animateWrongAnsLbl(label: answerLabel, newText: answer, characterDelay: 0.1, animationDuration: 0.1, shakeDistance: 20) { _ in
                    self.answer = ""
                    self.processedIndexPaths.removeAll()
                }
            }
        default:
            break
        }
    }
}

// MARK: - Collection View Delegate Methods
extension QuestionsCollectionViewCellV2:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return element?.chars.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlphabetCollectionViewCellV2", for: indexPath) as! AlphabetCollectionViewCellV2
        cell.alphabetLbl.text = element?.chars[indexPath.row].uppercased()
        cell.layer.cornerRadius = 35
        cell.backgroundColor = .white
        return cell
    }
}

// MARK: -  Animations
extension QuestionsCollectionViewCellV2{
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
                let shakeTransform = CGAffineTransform(translationX: -shakeDistance, y: 0)
                label.transform = shakeTransform
                label.textColor = .white
                label.backgroundColor = .systemRed
            }, completion: { _ in
                UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
                    label.transform = originalTransform
                }, completion: completion)
            })
        }
    }
}
