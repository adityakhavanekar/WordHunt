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
                cell.internalImgView.image = UIImage(named: "alphabet")
                cell.internalView.applyGradientBackground(color1: "#0094B2", color2: "#00BBD4")
                cell.categoryLbl.text = "Classic"
                cell.categoryDescLbl.text = "Unlimited words\nUnlimited Hints"
            case 1:
                cell.internalImgView.image = UIImage(named:"animals")
                cell.internalView.applyGradientBackground(color1: "#629135", color2: "#CBDD6F")
                cell.categoryLbl.text = "Animals"
                cell.categoryDescLbl.text = ""
            case 2:
                cell.internalImgView.image = UIImage(named: "brand")
                cell.internalView.applyGradientBackground(color1: "#F73758", color2: "#FB638B")
                cell.categoryLbl.text = "Brands"
                cell.categoryDescLbl.text = ""
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
        let vc2 = CounterViewController()
        let vc = QuestionsViewController()
        switch indexPath.row{
        case 0:
            vc.isClassic = true
            vc.viewModel = QuestionsViewModel(url: URL(string: "http://207.154.204.149:3051/wordHunt/classicWords")!)
        case 1:
            vc.isClassic = false
            vc.featuredImageStr = "animalsV"
            vc.viewModel = QuestionsViewModel(url: URL(string: "http://207.154.204.149:3051/wordHunt/animalWords")!)
        case 2:
            vc.isClassic = false
            vc.featuredImageStr = "brandsV"
            vc.viewModel = QuestionsViewModel(url: URL(string: "http://207.154.204.149:3051/wordHunt/brandWords")!)
        default:
            print("Error")
        }
        vc2.completion = {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        vc2.modalPresentationStyle = .overFullScreen
        self.present(vc2, animated: true)
    }
}
