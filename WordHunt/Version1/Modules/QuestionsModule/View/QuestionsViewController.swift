//
//  QuestionsViewController.swift
//  WordHunt
//
//  Created by APPLE on 18/05/23.
//

import UIKit
import SRCountdownTimer
import GoogleMobileAds

class QuestionsViewController: UIViewController {
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var highScoreLbl: UILabel!
    @IBOutlet weak var collectionViewQuestions: UICollectionView!
    @IBOutlet weak var timerView: SRCountdownTimer!
    @IBOutlet weak var featuredImgView: UIImageView!
    
    private var rewardedAd: GADRewardedAd?
    private let banner:GADBannerView = {
        let banner = GADBannerView()
//        ca-app-pub-8260816350989246/6510909087
//TESTAD: ca-app-pub-3940256099942544/2934735716
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.load(GADRequest())
        banner.backgroundColor = .clear
        return banner
    }()
    
    var featuredImageStr:String?
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
        loadRewardedAd()
        self.navigationController?.navigationBar.isHidden = true
        score = 0
        if isClassic == false{
            self.highScoreLbl.isHidden = true
        }
        configureTimer()
        setupCollectionView()
        setupUserDefaults()
        if let img = featuredImageStr{
            featuredImgView.image = UIImage(named: img)
        }
        configureAd()
    }
    
    private func configureAd(){
        banner.rootViewController = self
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
            self.banner.frame = self.adView.bounds
            self.adView.addSubview(self.banner)
        }
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
            self.show()
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
            if isClassic == true{
                cell.letterCountLbl.isHidden = false
                cell.letterCountLbl.text = "*No of letters \(object.answers[0].word.count)"
            }else{
                cell.letterCountLbl.isHidden = true
            }
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

extension QuestionsViewController:Answered{
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

extension QuestionsViewController:GADFullScreenContentDelegate{
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        loadRewardedAd(completion: {
            self.show()
        })
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.timerView.start(beginingValue: 5)
        print("Ad did dismiss full screen content.")
    }
    
    func show() {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: self) {
                let reward = ad.adReward
                print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                // TODO: Reward the user.
            }
        } else {
            
            print("Ad wasn't ready")
        }
    }
    
    
    //    Test: ca-app-pub-3940256099942544/1712485313
    //    ca-app-pub-8260816350989246/3635094615
    func loadRewardedAd(completion:(()->())?=nil) {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID:"ca-app-pub-3940256099942544/1712485313",
                           request: request,
                           completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            rewardedAd = ad
            print("Rewarded ad loaded.")
            rewardedAd?.fullScreenContentDelegate = self
            completion?()
        }
        )
    }
}
