//
//  CollectionViewCell.swift
//  mobile
//
//  Created by NguyenSon_MP on 09/06/2023.
//

import UIKit

class NoItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tilte: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        indicator.startAnimating()
    }

}
