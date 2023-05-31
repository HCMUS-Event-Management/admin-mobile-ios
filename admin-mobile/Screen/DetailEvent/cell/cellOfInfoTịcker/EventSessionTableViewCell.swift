//
//  EventSessionTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 16/05/2023.
//

import UIKit

class EventSessionTableViewCell: UITableViewCell {

    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
