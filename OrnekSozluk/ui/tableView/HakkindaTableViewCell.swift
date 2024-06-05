//
//  HakkindaTableViewCell.swift
//  OrnekSozluk
//
//  Created by reel on 19.04.2024.
//

import UIKit

class HakkindaTableViewCell: UITableViewCell {

    @IBOutlet weak var hakkindaLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var linkedinURL: URL?
    
    override func awakeFromNib() {
            super.awakeFromNib()
            
            hakkindaLabel.numberOfLines = 0
            hakkindaLabel.sizeToFit()
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        // Resmi boyutlandırarak bir UIImage oluşturun
           guard let image = UIImage(named: "linkedin_icon") else {
               return
           }
           let imageSize = CGSize(width: 20, height: 20)
           UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
           image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
           let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           
           // Butonun imageView özelliğine boyutlandırılmış resmi atayın
           button.setImage(resizedImage, for: .normal)
        
        }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if let url = linkedinURL {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
    }
    
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
}
