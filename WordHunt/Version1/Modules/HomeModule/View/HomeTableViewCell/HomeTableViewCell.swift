//
//  HomeTableViewCell.swift
//  WordHunt
//
//  Created by APPLE on 21/05/23.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var internalImgView: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categoryDescLbl: UILabel!
    @IBOutlet weak var internalView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI(){
        self.selectionStyle = .none
        setupInternalView()
    }
    
    private func setupInternalView(){
        addLiftedShadow(to: internalView)
        internalView.clipsToBounds = true
        internalView.layer.cornerRadius = 20
    }
    
}

extension HomeTableViewCell{
    private func addLiftedShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 4
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
}
