//
//  AlphabetCollectionViewCell.swift
//  WordHunt
//
//  Created by APPLE on 18/05/23.
//

import UIKit

class AlphabetCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var internalView: UIView!
    @IBOutlet weak var alphabetLbl: UILabel!
    
    var isThisSelected:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        setupUI()
    }
    
    private func setupUI(){
        isThisSelected = false
        alphabetLbl.textColor = .black
        setInternalView()
    }
    private func setInternalView(){
        internalView.backgroundColor = .white
        internalView.layer.cornerRadius =  5
        internalView.clipsToBounds = true
    }
    
    func setupCell(alphabet:String?){
        self.alphabetLbl.text = alphabet
    }
    func getSelectedActions(isSelected:Bool){
        switch isSelected{
        case true:
            self.isThisSelected = false
            self.alphabetLbl.textColor = .black
            self.internalView.backgroundColor = .white
        case false:
            self.isThisSelected = true
            self.alphabetLbl.textColor = .white
            self.internalView.backgroundColor = .systemGreen
        }
    }

}
