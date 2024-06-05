//
//  AciklamaVC.swift
//  OrnekSozluk
//
//  Created by reel on 4.03.2024.
//

import UIKit
import Firebase
import GoogleMobileAds

class AciklamaVC: UIViewController {
    
    @IBOutlet weak var kelimeLabel: UILabel!
    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var aciklamaTV: UITableView!
    @IBOutlet weak var reportButton: UIBarButtonItem!
    
    var selectedKelime: Kelime?
    
//    private let banner: GADBannerView = {
//        let banner = GADBannerView()
//        banner.adUnitID = "ca-app-pub-9864832018781672/8545862322"
//        banner.load(GADRequest())
//        banner.backgroundColor = .secondarySystemBackground
//        return banner
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        banner.rootViewController = self
//        view.addSubview(banner)

        navigationController?.navigationBar.tintColor = .white

        if let kelime = selectedKelime {
            kelimeLabel.text = kelime.kelime
            kelimeLabel.numberOfLines = 0
            kelimeLabel.adjustsFontSizeToFitWidth = true
            kelimeLabel.minimumScaleFactor = 0.5
        }
        
        updateFavButtonImage()
        aciklamaTV.delegate = self
        aciklamaTV.dataSource = self
        
        aciklamaTV.rowHeight = UITableView.automaticDimension
        aciklamaTV.estimatedRowHeight = 50
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.kelimeLabel.sizeToFit()
                self.kelimeLabel.adjustsFontForContentSizeCategory = true
                self.view.layoutIfNeeded()
            }

    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        banner.frame = CGRect(x: 0, y: view.frame.size.height-130, width: view.frame.size.width, height: 50).integral
//    }
    
    
    func updateFavButtonImage() {
        if let selectedKelime = selectedKelime {
            if UserDefaultsHelper.shared.isKelimeFavori(selectedKelime) {
                // Görüntüyü değiştir
                favButton.image = UIImage(systemName: "star.fill")
            } else {
                // Görüntüyü değiştir
                favButton.image = UIImage(systemName: "star")
            }
        }
    }
    
    @IBAction func favButtonPressed(_ sender: UIBarButtonItem) {
        
        if let selectedKelime = selectedKelime {
                // Eğer kelime favorilerde varsa, kaldır; değilse ekle
                if UserDefaultsHelper.shared.isKelimeFavori(selectedKelime) {
                    UserDefaultsHelper.shared.deleteFavoriKelime(selectedKelime)
                    
                } else {
                    UserDefaultsHelper.shared.addFavoriKelime(selectedKelime)
                }
            }
        
        // UserDefaultsHelper işlemlerini yaptıktan sonra image'ı güncelle
               updateFavButtonImage()
    }
    
    
    @IBAction func reportButtonTapped(_ sender: UIBarButtonItem) {
        // Bildirim penceresini göster
                let alertController = UIAlertController(title: "Hatalı Tanım", message: "Bu tanımın ya da terimin geliştirilmesi gerektiğini mi düşünüyorsunuz? \n Bize bildirin!", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "Evet", style: .default) { _ in
                    self.sendReport()
                }
                let cancelAction = UIAlertAction(title: "Hayır", style: .cancel, handler: nil)

                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)

                present(alertController, animated: true, completion: nil)
    }
    
    func sendReport() {
        guard let kelime = selectedKelime?.kelime else { return }
            let db = Firestore.firestore()
            let reportData: [String: Any] = [
                "word": kelime,
                "timestamp": Timestamp(date: Date())
            ]

            db.collection("reports").addDocument(data: reportData) { error in
                if let error = error {
                    print("Hata: \(error.localizedDescription)")
                } else {
                    print("Bildiriminiz başarıyla gönderildi.")
                }
            }
    }
    
    
}

extension AciklamaVC: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1 // Sadece bir satır oluştur
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AciklamaCell", for: indexPath) as! AciklamaTableViewCell
            
            if let kelime = selectedKelime {
                cell.aciklamaLabel.text = kelime.aciklama
            }
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
       }
    
}
