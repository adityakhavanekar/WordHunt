//
//  QuestionsViewController.swift
//  WordHunt
//
//  Created by APPLE on 18/05/23.
//

import UIKit
import SRCountdownTimer

class QuestionsViewController: UIViewController {

    @IBOutlet weak var collectionViewQuestions: UICollectionView!
    @IBOutlet weak var timerView: SRCountdownTimer!
    @IBOutlet weak var featuredImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        self.navigationController?.navigationBar.isHidden = true
        configureTimer()
        setupCollectionView()
    }
    
    private func configureTimer(){
        timerView.layer.cornerRadius = 40
        timerView.layer.masksToBounds = true
        timerView.lineColor = .systemTeal
        timerView.backgroundColor = .white
        timerView.lineWidth = 10
        timerView.delegate = self
        timerView.start(beginingValue: 10)
    }
    
    private func setupCollectionView(){
        collectionViewQuestions.register(UINib(nibName: "QuestionsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "QuestionsCollectionViewCell")
        collectionViewQuestions.dataSource = self
        collectionViewQuestions.delegate = self
    }
}

extension QuestionsViewController: SRCountdownTimerDelegate{
    
}

extension QuestionsViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionViewQuestions.dequeueReusableCell(withReuseIdentifier: "QuestionsCollectionViewCell", for: indexPath) as? QuestionsCollectionViewCell else {return UICollectionViewCell()}
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
