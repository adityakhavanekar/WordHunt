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
    
    var viewModel:QuestionsViewModelV2?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTimer()
        configureCollectionView()
        callApi()
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
    
    private func callApi(){
        viewModel = QuestionsViewModelV2(url:URL(string: "https://ap-south-1.aws.data.mongodb-api.com/app/application-0-vwxvl/endpoint/wordHunt/wordHunts")!)
        viewModel?.getWords(){res in
            switch res{
            case true:
                DispatchQueue.main.async {
                    self.questionsCollectionView.reloadData()
                    print(self.viewModel?.getCount())
                }
            case false:
                print("False, Error")
            }
        }
    }
}


extension QuestionsViewControllerV2:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionsCollectionViewCellV2", for: indexPath)
                as? QuestionsCollectionViewCellV2 else{return UICollectionViewCell()}
        if let element = viewModel?.getElement(index: indexPath.row){
            cell.setupCell(element: element)
        }
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
