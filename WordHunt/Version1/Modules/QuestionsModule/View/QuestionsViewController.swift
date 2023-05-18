//
//  QuestionsViewController.swift
//  WordHunt
//
//  Created by APPLE on 18/05/23.
//

import UIKit

class QuestionsViewController: UIViewController {

    @IBOutlet weak var questionsCollectionVIew: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupCollectionView(){
        questionsCollectionVIew.dataSource = self
        questionsCollectionVIew.delegate = self
        questionsCollectionVIew.register(UINib(nibName: "QuestionsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "QuestionsCollectionViewCell")
    }
    
}

extension QuestionsViewController:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = questionsCollectionVIew.dequeueReusableCell(withReuseIdentifier: "QuestionsCollectionViewCell", for: indexPath) as! QuestionsCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: questionsCollectionVIew.frame.width, height: questionsCollectionVIew.frame.height)
    }
    
    
}
