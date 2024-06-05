//
//  AyarlarTableViewCell.swift
//  OrnekSozluk
//
//  Created by reel on 5.03.2024.
//

import UIKit

let darkModeBackgroundColor = UIColor(hex: "#171717")
let lightModeBackgroundColor = UIColor(hex: "#F0F0F0")

class AyarlarTableViewCell: UITableViewCell {

    @IBOutlet weak var ayarlarLabel: UILabel!
    
    private var observer: AnyObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
            registerForTraitChanges()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupUI()
            registerForTraitChanges()
        }
        
        private func setupUI() {
            updateBackgroundColors()
            // Diğer UI özelliklerini burada ayarlayabilirsiniz.
                    
        }
        
        private func registerForTraitChanges() {
            observer = self.observe(\.traitCollection, options: [.new]) { [weak self] _, _ in
                self?.updateBackgroundColors()
            }
        }
        
        private func updateBackgroundColors() {
            if traitCollection.userInterfaceStyle == .dark {
                // Koyu modda kullanılacak renkleri ayarla
                self.backgroundColor = darkModeBackgroundColor
                // Diğer renklerinizi burada ayarlayabilirsiniz.
            } else {
                // Açık modda kullanılacak renkleri ayarla
                self.backgroundColor = lightModeBackgroundColor
                // Diğer renklerinizi burada ayarlayabilirsiniz.
            }
        }
}


extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


