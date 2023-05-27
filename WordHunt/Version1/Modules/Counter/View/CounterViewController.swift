//
//  CounterViewController.swift
//  WordHunt
//
//  Created by APPLE on 23/05/23.
//

import UIKit
import SRCountdownTimer

class CounterViewController: UIViewController {
    
    @IBOutlet weak var timerView: SRCountdownTimer!
    
    var completion : (()->(Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTimerView()
    }
    
    private func configureTimerView(){
        timerView.labelFont = UIFont.systemFont(ofSize: 100,weight: .heavy)
        timerView.lineColor = .white
        timerView.lineWidth = 100
        timerView.layer.cornerRadius = 100
        timerView.clipsToBounds = true
        timerView.delegate = self
        timerView.start(beginingValue: 3)
    }
}

extension CounterViewController: SRCountdownTimerDelegate{
    func timerDidEnd(sender: SRCountdownTimer, elapsedTime: TimeInterval) {
        self.dismiss(animated: true,completion: completion)
    }
    func timerDidUpdateCounterValue(sender: SRCountdownTimer, newValue: Int) {
    }
    
    func timerDidPause(sender: SRCountdownTimer) {
    }
}
