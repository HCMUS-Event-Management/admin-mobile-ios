//
//  InfoTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 16/02/2023.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgAvatar.layer.cornerRadius = 50
        imgAvatar.borderColor = UIColor(red: 94/255, green: 135/255, blue: 240/255, alpha: 1)
        imgAvatar.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
