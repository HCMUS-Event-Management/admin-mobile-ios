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
    
    var dataMenuAccount = ["Profile","Security","Language","Help Center","Logout"]
    var dataMenuEvent = ["Magane Events"]
    var dataMenuEventName = ["Quản lý sự kiện"]
    var dataMenuAccountName = ["Thông tin","Bảo mật","Ngôn ngữ","Trung tập trợ giúp","Đăng xuất"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setDataAccount(id: Int) {
        name.text = self.dataMenuAccountName[id]
        icon.image = UIImage(named: self.dataMenuAccount[id])
    }
    
    func setDataEvent(id: Int) {
        name.text = self.dataMenuEventName[id]
        icon.image = UIImage(named: self.dataMenuEvent[id])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
