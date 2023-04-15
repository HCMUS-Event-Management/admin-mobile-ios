//
//  ProfileDetailTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 20/02/2023.
//

import UIKit


class ProfileDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    var callback : (() -> Void)?

    @IBAction func pressed(_ sender: Any) {
        callback?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
