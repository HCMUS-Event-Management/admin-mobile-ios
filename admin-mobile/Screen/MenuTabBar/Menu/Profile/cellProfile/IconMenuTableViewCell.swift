//
//  IconMenuTableViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 16/02/2023.
//

import UIKit

class IconMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    var dataMenuAccount = ["Profile","Payment Methods","Payment History","Security","Language","Help Center","Logout"]
    var dataMenuEvent = ["Magane Events","Favorite Events"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setDataAccount(id: Int) {
        name.text = self.dataMenuAccount[id]
        icon.image = UIImage(named: self.dataMenuAccount[id])
    }
    
    func setDataEvent(id: Int) {
        name.text = self.dataMenuEvent[id]
        icon.image = UIImage(named: self.dataMenuEvent[id])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
