//
//  HomeViewController.swift
//  WordHunt
//
//  Created by APPLE on 21/05/23.
//

import UIKit
import GoogleMobileAds

class HomeViewController: UIViewController {
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var highscoreLbl: UILabel!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var homeTableView: UITableView!
    
    let defaults = UserDefaults.standard
    
    private let banner:GADBannerView = {
        let banner = GADBannerView()
        //        ca-app-pub-8260816350989246/6510909087
        //TESTAD: ca-app-pub-3940256099942544/2934735716
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.load(GADRequest())
        banner.backgroundColor = .clear
        return banner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }
    
    private func setupUI(){
        scoreView.layer.cornerRadius = 10
        highscoreLbl.text = "Highscore: \(defaults.object(forKey: "Highscore") ?? "")"
        setupTableView()
        configureAd()
    }
    
    private func configureAd(){
        banner.rootViewController = self
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
            self.banner.frame = self.adView.bounds
            self.adView.addSubview(self.banner)
        }
    }
    
    private func setupTableView(){
        homeTableView.dataSource = self
        homeTableView.delegate = self
        homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        homeTableView.separatorStyle = .none
    }
    
}

extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01){
            switch indexPath.row{
            case 0:
                cell.setupCell(internalImgString: "alphabet", gradient1: "#0094B2", gradient2: "#00BBD4", category: "Classic", desc: "Unlimited words")
            case 1:
                cell.setupCell(internalImgString: "animals", gradient1: "#629135", gradient2: "#CBDD6F", category: "Animals", desc: "")
            case 2:
                cell.setupCell(internalImgString: "brand", gradient1: "#F73758", gradient2: "#FB638B", category: "Brands", desc: "")
            default:
                cell.internalView.backgroundColor = .lightGray
            }
        }
        
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return homeTableView.frame.height/4.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let counterVc = CounterViewController()
        let questionsVc = QuestionsViewController()
        switch indexPath.row{
        case 0:
            questionsVc.isClassic = true
            questionsVc.viewModel = QuestionsViewModel(url: URL(string: "http://207.154.204.149:3051/wordHunt/classicWords")!)
        case 1:
            questionsVc.isClassic = false
            questionsVc.featuredImageStr = "animalsV"
            questionsVc.viewModel = QuestionsViewModel(url: URL(string: "http://207.154.204.149:3051/wordHunt/animalWords")!)
        case 2:
            questionsVc.isClassic = false
            questionsVc.featuredImageStr = "brandsV"
            questionsVc.viewModel = QuestionsViewModel(url: URL(string: "http://207.154.204.149:3051/wordHunt/brandWords")!)
        default:
            print("Error")
        }
        counterVc.completion = {
            self.navigationController?.pushViewController(questionsVc, animated: true)
        }
        counterVc.modalPresentationStyle = .overFullScreen
        self.present(counterVc, animated: true)
    }
}
