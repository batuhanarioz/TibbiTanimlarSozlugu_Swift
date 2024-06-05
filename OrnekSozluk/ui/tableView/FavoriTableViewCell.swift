//
//  FavoriTableViewCell.swift
//  OrnekSozluk
//
//  Created by reel on 4.03.2024.
//

import UIKit

class FavoriTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
