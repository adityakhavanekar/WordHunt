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
    
    @IBOutlet weak var homeBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var featuredImgViewHeigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var timerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var timerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var timerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var adViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var highScoreLbl: UILabel!
    @IBOutlet weak var collectionViewQuestions: UICollectionView!
    @IBOutlet weak var timerView: SRCountdownTimer!
    @IBOutlet weak var featuredImgView: UIImageView!
    var activityIndicator:UIActivityIndicatorView?
    
    private var rewardedAd: GADRewardedAd?
    private var banner:GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = AdKeys.bannerAd
        banner.load(GADRequest())
        banner.backgroundColor = .clear
        return banner
    }()
    
    var featuredImageStr:String?
    var isClassic:Bool = true
    let defaults = UserDefaults.standard
    var viewModel:QuestionsViewModel?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        callViewModel()
        if UIDevice.current.userInterfaceIdiom == .pad{
            configureForIpad()
        }
    }
    
    private func setupUI(){
        if let img = featuredImageStr{
            featuredImgView.image = UIImage(named: img)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                self.featuredImgView.addBlackGradientLayer()
            }
        }
        if isClassic == false{
            self.highScoreLbl.isHidden = true
        }
        if UIScreen.main.bounds.height <= 700{
            adViewHeightConstraint.constant = adViewHeightConstraint.constant - 20
            collectionViewBottomConstraint.constant = collectionViewBottomConstraint.constant - 10
            featuredImgViewHeigthConstraint.constant = featuredImgViewHeigthConstraint.constant - 30
        }
        self.navigationController?.navigationBar.isHidden = true
        score = 0
        configureTimer()
        setupCollectionView()
        setupUserDefaults()
        configureBannerAd()
    }
    
    private func configureForIpad(){
        timerViewHeightConstraint.constant = timerViewHeightConstraint.constant * 1.8
        timerViewWidthConstraint.constant = timerViewWidthConstraint.constant * 1.8
        timerViewTopConstraint.constant = timerViewHeightConstraint.constant * (-0.5)
        timerView.labelFont = UIFont.systemFont(ofSize: 40)
        timerView.layer.cornerRadius = timerViewHeightConstraint.constant/2
        timerView.lineWidth = 20
        homeBtnHeightConstraint.constant = homeBtnHeightConstraint.constant * 2
        homeBtnWidthConstraint.constant = homeBtnWidthConstraint.constant * 2
    }
    
    private func configureBannerAd(){
        banner = configureBanner()
        banner.rootViewController = self
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
            self.banner.frame = self.adView.bounds
            self.adView.addSubview(self.banner)
        }
    }
    
    private func configureBanner()->GADBannerView{
        let banner = GADBannerView()
        banner.adUnitID = AdKeys.bannerAd
        banner.load(GADRequest())
        banner.backgroundColor = .clear
        return banner
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
        collectionViewQuestions.register(UINib(nibName: Cells.questionsCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Cells.questionsCollectionViewCell)
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
        activityIndicator = UIFunctions().showActivityIndicator(in: self.view)
        viewModel?.getWordsNewApi(completion: { result in
            switch result{
            case true:
                DispatchQueue.main.async {
                    self.collectionViewQuestions.reloadData()
                    UIFunctions().hideActivityIndicator(activityIndicator: self.activityIndicator ?? UIActivityIndicatorView(), in: self.view)
                    if let count = self.viewModel?.getElement(index: 0)?.answers.count{
                        self.timerView.start(beginingValue:count*45)
                    }
                }
            case false:
                DispatchQueue.main.async {
                    UIFunctions().hideActivityIndicator(activityIndicator: self.activityIndicator ?? UIActivityIndicatorView(), in: self.view)
                    let action = UIAlertAction(title: "OK", style: .default){ _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    UIFunctions().showAlert(title: "Error Occured", message: "Please check network connection", preferedStyle: .alert, action: action, controller: self)
                }
            }
        })
    }
    
    @IBAction func homeBtnClicked(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func timerEnded(){
        let vc = HelpViewController()
        switch isClassic{
        case true:
            vc.scoreString = "Score: \(score)"
            vc.highScoreString = "High score: \(highScore)"
        case false:
            vc.isClassicTrue = false
            vc.scoreString = ""
            vc.highScoreString = ""
        }
        vc.endCompletion = {
            self.collectionViewQuestions.isUserInteractionEnabled = false
            self.navigationController?.popViewController(animated: true)
        }
        vc.continueCompletion = {
            self.loadRewardedAd(fromHelperScreen: true) {
                self.show{
                    self.timerView.lineColor = .systemTeal
                    self.timerView.start(beginingValue: 45)
                    self.timerView.pause()
                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
}

// MARK: - Countdown Timer Delegate
extension QuestionsViewController: SRCountdownTimerDelegate{
    func timerDidEnd(sender: SRCountdownTimer, elapsedTime: TimeInterval) {
        timerEnded()
    }
    
    func timerDidUpdateCounterValue(sender: SRCountdownTimer, newValue: Int) {
        if newValue <= 20{
            timerView.lineColor = .red
        }else{
            timerView.lineColor = .systemTeal
        }
    }
}

// MARK: - CollectionView Functions
extension QuestionsViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionViewQuestions.dequeueReusableCell(withReuseIdentifier: Cells.questionsCollectionViewCell, for: indexPath) as? QuestionsCollectionViewCell else {return UICollectionViewCell()}
        if let object = viewModel?.getElement(index: indexPath.row){
            var newObject = object
            newObject.chars = newObject.chars.shuffled()
            cell.setupCell(element: newObject)
            cell.delegate = self
            cell.helpDelegate = self
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

// MARK: - Cell Delegate Function
extension QuestionsViewController:Answered,HelpPressed{
    
    func helpNeeded(element: WordHuntElement, type: Help, cell: QuestionsCollectionViewCell) {
        switch type{
        case .word:
            loadRewardedAd(fromHelperScreen: false){
                self.show {
                    cell.answer = element.answers[0].word.uppercased()
                    cell.isAdRewarded = true
                }
            }
        case .shuffle:
            break
        }
    }
    
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
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                    self.collectionViewQuestions.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
                    if let count = cell.element?.answers.count{
                        self.timerView.start(beginingValue: count * 45)
                    }
                }
            }else{
                self.timerView.pause()
                let vc = DoneViewController()
                vc.completion = {
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
                vc.modeCompletionStr = "Completed"
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }
    }
}

//MARK: - Advertsitement
extension QuestionsViewController:GADFullScreenContentDelegate{
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("error occured")
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.timerView.resume()
        print("Ad did dismiss full screen content.")
    }
    
    func show(completion:(()->())?=nil) {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: self) {
                let reward = ad.adReward
                print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                completion?()
            }
        } else {
            UIFunctions().showTemporaryLabel(text: "Error occured", view: self.view)
            print("Ad wasn't ready")
        }
    }
    
    
    func loadRewardedAd(fromHelperScreen:Bool,completion:(()->())?=nil) {
        let request = GADRequest()
        let adIndi = UIFunctions().showActivityIndicator(in: self.view)
        self.timerView.pause()
        GADRewardedAd.load(withAdUnitID:AdKeys.rewardedAd,
                           request: request,
                           completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                UIFunctions().showTemporaryLabel(text: "Error occured", view: self.view)
                UIFunctions().hideActivityIndicator(activityIndicator: adIndi, in: self.view)
                self.timerView.resume()
                if fromHelperScreen == true{
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            rewardedAd = ad
            print("Rewarded ad loaded.")
            rewardedAd?.fullScreenContentDelegate = self
            UIFunctions().hideActivityIndicator(activityIndicator: adIndi, in: self.view)
            completion?()
        }
        )
    }
}
