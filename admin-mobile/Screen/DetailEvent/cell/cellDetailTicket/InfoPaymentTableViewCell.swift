//
//  InfoPaymentTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/03/2023.
//

import UIKit

class InfoPaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var method: UILabel!
    @IBOutlet weak var eventId: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var ticketPrice: UILabel!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
