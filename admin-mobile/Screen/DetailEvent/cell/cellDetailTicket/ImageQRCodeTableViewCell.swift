//
//  ImageQRCodeTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/03/2023.
//

import UIKit

class ImageQRCodeTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgQR: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 10
        mainView.layer.borderWidth = 0.2
        mainView.layer.borderColor = UIColor.gray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
