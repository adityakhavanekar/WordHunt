//
//  QuestionsViewController.swift
//  WordHunt
//
//  Created by APPLE on 18/05/23.
//

import UIKit
import SRCountdownTimer

class QuestionsViewController: UIViewController {
    
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var highScoreLbl: UILabel!
    @IBOutlet weak var collectionViewQuestions: UICollectionView!
    @IBOutlet weak var timerView: SRCountdownTimer!
    @IBOutlet weak var featuredImgView: UIImageView!
    
    var viewModel:QuestionsViewModel?
    var isClassic:Bool = true
    var highScore:Int = 0 {
        didSet{
            self.highScoreLbl.text = "High Score: \(highScore)"
        }
    }
    var score:Int = 0{
        didSet{
            self.scoreLbl.text = "Score: \(score)"
        }
    }
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        callViewModel()
    }
    
    private func setupUI(){
        self.navigationController?.navigationBar.isHidden = true
        score = 0
        if isClassic == false{
            self.highScoreLbl.isHidden = true
        }
        configureTimer()
        setupCollectionView()
        setupUserDefaults()
    }
    
    private func configureTimer(){
        timerView.layer.cornerRadius = 40
        timerView.layer.masksToBounds = true
        timerView.lineColor = .systemTeal
        timerView.backgroundColor = .white
        timerView.labelTextColor = .black
        timerView.lineWidth = 10
        timerView.delegate = self
    }
    
    private func setupCollectionView(){
        collectionViewQuestions.register(UINib(nibName: "QuestionsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "QuestionsCollectionViewCell")
        collectionViewQuestions.dataSource = self
        collectionViewQuestions.delegate = self
    }
    
    private func setupUserDefaults(){
        if isClassic == true{
            if defaults.object(forKey: "Highscore") != nil{
                highScore = defaults.object(forKey: "Highscore") as! Int
            }else{
                highScore = 0
            }
        }
    }
    
    private func callViewModel(){
        viewModel?.getWords(completion: {
            DispatchQueue.main.async {
                self.collectionViewQuestions.reloadData()
                if let count = self.viewModel?.getElement(index: 0)?.answers.count{
                    self.timerView.start(beginingValue:count*70)
                }
            }
        })
    }
    
    @IBAction func homeBtnClicked(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension QuestionsViewController: SRCountdownTimerDelegate{
    func timerDidEnd(sender: SRCountdownTimer, elapsedTime: TimeInterval) {
        let vc = HelpViewController()
        if isClassic == true{
            vc.scoreString = "Score: \(score)"
            vc.highScoreString = "High score: \(highScore)"
        }else{
            vc.isTrue = false
            vc.scoreString = ""
            vc.highScoreString = ""
        }
        vc.completion = {
            self.collectionViewQuestions.isUserInteractionEnabled = false
            self.navigationController?.popViewController(animated: true)
        }
        vc.continueCompletion = {
            self.timerView.start(beginingValue: 70)
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}

extension QuestionsViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionViewQuestions.dequeueReusableCell(withReuseIdentifier: "QuestionsCollectionViewCell", for: indexPath) as? QuestionsCollectionViewCell else {return UICollectionViewCell()}
        if let object = viewModel?.getElement(index: indexPath.row){
            var newObject = object
            newObject.chars = newObject.chars.shuffled()
            cell.delegate = self
            cell.element = newObject
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewQuestions.frame.width, height: collectionViewQuestions.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension QuestionsViewController:AnsweredAll{
    func answered(cell:QuestionsCollectionViewCell,points:Int) {
        if isClassic == true{
            if defaults.object(forKey: "Highscore") != nil{
                score += points
                if score > highScore{
                    highScore = score
                    defaults.set(highScore, forKey: "Highscore")
                }
            }else{
                score += points
                highScore = score
                defaults.set(highScore, forKey: "Highscore")
            }
        }else{
            score += points
        }
        guard let indexPath = collectionViewQuestions.indexPath(for: cell) else { return }
        if let count = viewModel?.getCount(){
            if indexPath.row < count - 1 {
                let nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                    self.collectionViewQuestions.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
                    if let count = cell.element?.answers.count{
                        self.timerView.start(beginingValue: count * 70)
                    }
                }
            }else{
                
            }
        }
    }
}
