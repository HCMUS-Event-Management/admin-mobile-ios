//
//  EventCollectionViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 23/02/2023.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var btnSeeDetail: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        preUI()
        
    }
    func preUI() {
        btnSeeDetail.layer.cornerRadius = 10
        btnSeeDetail.layer.masksToBounds = true
    }
    

    
    

}
