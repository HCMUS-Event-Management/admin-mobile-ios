//
//  TypeCollectionViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 23/02/2023.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var viewLbl: UIView!
    var callback : (() -> Void)?

    override var isSelected: Bool {
        didSet {
            viewLbl.backgroundColor = isSelected ? UIColor(red: 94/255, green: 135/255, blue: 240/255, alpha: 1) : UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.3)
            category.textColor = isSelected ? .white : .black
            if isSelected {
                callback?()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        preUI()
    }
    
    
    func preUI() {
        viewLbl.layer.cornerRadius = 18
    }

}
