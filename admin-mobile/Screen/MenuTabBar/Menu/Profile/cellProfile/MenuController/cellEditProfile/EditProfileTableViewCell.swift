//
//  EditProfileTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 28/02/2023.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var btnEditImage: UIImageView!
    var callback : (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        avatar.layer.cornerRadius = 50
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        btnEditImage.isUserInteractionEnabled = true
        btnEditImage.addGestureRecognizer(tapGestureRecognizer)
        btnEditImage.layer.cornerRadius = 5
        btnEditImage.layer.masksToBounds = true
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        // Your action
        callback?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
