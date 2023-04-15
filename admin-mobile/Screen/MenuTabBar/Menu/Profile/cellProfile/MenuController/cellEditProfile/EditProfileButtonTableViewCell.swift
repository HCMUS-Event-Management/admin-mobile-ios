//
//  EditProfileButtonTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 28/02/2023.
//

import UIKit


protocol EditProfileButtonTableViewCellDelegate {
    func backScreen()
    func callApi()
}

class EditProfileButtonTableViewCell: UITableViewCell {
    var delegate: EditProfileButtonTableViewCellDelegate?

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSelect: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        preUI()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func preUI() {
        btnCancel.layer.cornerRadius = 10
        btnCancel.layer.masksToBounds = true
        btnCancel.layer.borderWidth = 0.5
        btnCancel.layer.borderColor = UIColor.gray.cgColor
        
        btnSelect.layer.cornerRadius = 10
        btnSelect.layer.masksToBounds = true
       
    }

    @IBAction func didTapSecondButton(_ sender: UIButton) {
        guard let delegate = delegate else {
            return
        }

        
        delegate.callApi()
    }
    @IBAction func didTapCancel(_ sender: UIButton) {
        guard let delegate = delegate else {
            return
        }

        
        delegate.backScreen()
    }
    
}
