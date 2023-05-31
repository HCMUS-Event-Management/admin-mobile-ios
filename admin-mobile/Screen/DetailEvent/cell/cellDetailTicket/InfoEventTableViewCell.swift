//
//  InfoEventTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/03/2023.
//

import UIKit

class InfoEventTableViewCell: UITableViewCell {

    @IBOutlet weak var organizer: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
