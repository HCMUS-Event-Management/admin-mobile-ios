//
//  DescriptionTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 16/05/2023.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var txtDescription: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
