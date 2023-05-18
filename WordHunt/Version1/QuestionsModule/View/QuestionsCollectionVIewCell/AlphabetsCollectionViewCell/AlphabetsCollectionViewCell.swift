//
//  AlphabetsCollectionViewCell.swift
//  WordHunt
//
//  Created by APPLE on 17/05/23.
//

import UIKit

class AlphabetsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var internalView: UIView!
    
    @IBOutlet weak var alphabetLbl: UILabel!
    
    
    var isThisSelected:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

}
