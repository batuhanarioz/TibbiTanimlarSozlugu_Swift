//
//  NotTableViewCell.swift
//  OrnekSozluk
//
//  Created by reel on 4.03.2024.
//

import UIKit

class NotTableViewCell: UITableViewCell {

    @IBOutlet weak var baslikLabel: UILabel!
    @IBOutlet weak var aciklamaLabel: UILabel!
    @IBOutlet weak var tarihLabel: UILabel!
    
    var paylasButtonAction: (() -> Void)?
        
        // ... Diğer fonksiyonlar
        
        @objc private func paylasButtonPressed() {
            paylasButtonAction?()
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
