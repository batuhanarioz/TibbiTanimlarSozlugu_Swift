//
//  AciklamaTableViewCell.swift
//  OrnekSozluk
//
//  Created by reel on 18.04.2024.
//

import UIKit

class AciklamaTableViewCell: UITableViewCell {

    @IBOutlet weak var aciklamaLabel: UILabel! {
        didSet {
                    aciklamaLabel.numberOfLines = 0
                    aciklamaLabel.lineBreakMode = .byWordWrapping
                    self.aciklamaLabel.sizeToFit()
                    self.aciklamaLabel.adjustsFontForContentSizeCategory = true
                }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
