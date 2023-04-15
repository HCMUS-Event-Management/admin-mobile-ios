//
//  EditProfileTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 28/02/2023.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var btnEditImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        btnEditImage.layer.cornerRadius = 5
        btnEditImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
