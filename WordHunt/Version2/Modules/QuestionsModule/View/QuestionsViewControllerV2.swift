//
//  QuestionsViewControllerV2.swift
//  WordHunt
//
//  Created by Neosoft on 12/09/23.
//

import UIKit
import SRCountdownTimer


class QuestionsViewControllerV2: UIViewController {

    @IBOutlet weak var timerView: SRCountdownTimer!
    @IBOutlet weak var questionsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTimer()
        configureCollectionView()
    }
    
    private func configureCollectionView(){
        questionsCollectionView.dataSource = self
        questionsCollectionView.delegate = self
        questionsCollectionView.register(UINib(nibName: "QuestionsCollectionViewCellV2", bundle: nil), forCellWithReuseIdentifier: "QuestionsCollectionViewCellV2")
        
    }
    
    private func configureTimer(){
        timerView.layer.cornerRadius = 50
        timerView.layer.masksToBounds = true
        timerView.lineColor = .systemTeal
        timerView.backgroundColor = .white
        timerView.labelTextColor = .black
        timerView.lineWidth = 10
        timerView.delegate = self
        timerView.start(beginingValue: 20)
    }
}


extension QuestionsViewControllerV2:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionsCollectionViewCellV2", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: questionsCollectionView.frame.width, height: questionsCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension QuestionsViewControllerV2:SRCountdownTimerDelegate{
    func timerDidStart(sender: SRCountdownTimer) {
        print("Started")
    }
    func timerDidEnd(sender: SRCountdownTimer, elapsedTime: TimeInterval) {
        self.questionsCollectionView.scrollToNextIndex(animated: true)
    }
}

extension QuestionsViewControllerV2{
    
}
