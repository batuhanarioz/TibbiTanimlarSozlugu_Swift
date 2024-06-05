//
//  GecmisVC.swift
//  OrnekSozluk
//
//  Created by reel on 3.03.2024.
//

import UIKit
import GoogleMobileAds

class GecmisVC: UIViewController {
    
    @IBOutlet weak var gecmisTV: UITableView!
    @IBOutlet weak var silButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var gecmisKelimeler: [Kelime] = [] // GecmisVC'nin verilerini tutmak için bir array
    
//    private let banner: GADBannerView = {
//        let banner = GADBannerView()
//        banner.adUnitID = "ca-app-pub-9864832018781672/2172025669"
//        banner.load(GADRequest())
//        banner.backgroundColor = .secondarySystemBackground
//        return banner
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        banner.rootViewController = self
//        view.addSubview(banner)
        
        customizeNavigationBar()
        
        gecmisTV.delegate = self
        gecmisTV.dataSource = self
        
        gecmisKelimeler = UserDefaultsHelper.shared.getGecmisKelimeler()
        
        NotificationCenter.default.addObserver(self, selector: #selector(gecmisKelimeEklendi), name: Notification.Name("GecmisKelimeEklendi"), object: nil)
        
        gecmisTV.reloadData()
        
        let bottomInset: CGFloat = 50.0
        gecmisTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)

    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        banner.frame = CGRect(x: 0, y: view.frame.size.height-130, width: view.frame.size.width, height: 50).integral
//    }
    
    func customizeNavigationBar() {
        
           if let navigationBar = navigationController?.navigationBar {
               // Navigation bar'ın rengini değiştir
               navigationBar.barTintColor = UIColor(hex: "#6DEA9E")
               
               // Statü çubuğunun rengini değiştir (iOS 15 ve sonrası)
               if #available(iOS 15.0, *) {
                   let appearance = UINavigationBarAppearance()
                   appearance.backgroundColor = UIColor(hex: "#6DEA9E")
                   navigationBar.standardAppearance = appearance
                   navigationBar.scrollEdgeAppearance = appearance
               }
           }
       }
    
    @objc func gecmisKelimeEklendi() {
        // Geçmiş kelimeleri yükleyip tableView'ı güncelle
        gecmisKelimeler = UserDefaultsHelper.shared.getGecmisKelimeler()
        gecmisKelimeler.reverse()
        gecmisTV.reloadData()
    }
    
    @IBAction func silButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Temizle", message: "Son aradığınız kelimeleri silmek istediğinize emin misiniz ?", preferredStyle: .alert)

            let evetAction = UIAlertAction(title: "Evet", style: .destructive) { _ in
                // Kullanıcının tüm favori kelimeleri silmeyi onaylaması durumunda yapılacak işlemler
                UserDefaultsHelper.shared.clearGecmisKelimeler()
                self.gecmisKelimeler.removeAll()
                self.gecmisTV.reloadData()
            }

            let iptalAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)

            alertController.addAction(evetAction)
            alertController.addAction(iptalAction)

            present(alertController, animated: true, completion: nil)
        
        
    }
    
    @objc func gecmisKelimelerDidUpdate() {
            // NotificationCenter ile favori kelimeler güncellendiğinde çağrılacak metod
            gecmisKelimeler = UserDefaultsHelper.shared.getGecmisKelimeler()
        gecmisKelimeler.reverse()
            gecmisTV.reloadData()
        }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        // Geçmiş kelimeleri bir metin dosyasına dönüştür
            let textData = convertToGecmisTextData()

            // Metin dosyasını geçici bir konumda kaydet
            guard let textFileURL = saveTextFile(textData: textData) else {
                print("Error saving text file.")
                return
            }

            // Metin dosyasını paylaş
            shareTextFile(fileURL: textFileURL, sender: sender)
    }
    
    // Favori kelimeleri metin dosyasına dönüştürme işlemi
    func convertToGecmisTextData() -> Data {
        var textContent = ""

        for kelime in gecmisKelimeler {
            // Favori kelimeleri metin içine ekleyin
            textContent += "\(kelime.kelime)\n"
        }

        // Dönüştürülen metin içeriğini Data olarak döndürün
        if let textData = textContent.data(using: .utf8) {
            return textData
        } else {
            print("Error converting text content to Data.")
            return Data()
        }
    }

    // Metin dosyasını geçici bir konumda kaydetme işlemi
    func saveTextFile(textData: Data) -> URL? {
        // Geçici bir konum oluşturun
        let tempDirectory = FileManager.default.temporaryDirectory
        let textFileURL = tempDirectory.appendingPathComponent("son_aranan_kelimeler.txt")

        // Metin dosyasını oluşturulan konumda kaydedin
        do {
            try textData.write(to: textFileURL)
            return textFileURL
        } catch {
            print("Error saving text file: \(error.localizedDescription)")
            return nil
        }
    }

    func shareTextFile(fileURL: URL, sender: UIBarButtonItem) {
        // Dosya URL'sinin geçerli olup olmadığını kontrol edin
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("File does not exist at path: \(fileURL.path)")
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if let error = error {
                print("Error during sharing: \(error.localizedDescription)")
            } else if success {
                print("Sharing completed successfully.")
            } else {
                print("Sharing canceled.")
            }
        }

        // iPad'de çökme problemini önlemek için popover ayarları
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }

        present(activityViewController, animated: true, completion: nil)
    }
    
}

extension GecmisVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}


extension GecmisVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gecmisKelimeler.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.row < gecmisKelimeler.count else {
            fatalError("Index out of range hatası: \(indexPath.row) - \(gecmisKelimeler.count)")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gecmisCell", for: indexPath)
        let gecmisKelime = gecmisKelimeler[indexPath.row]
        cell.textLabel?.text = gecmisKelime.kelime
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedKelime = gecmisKelimeler[indexPath.row]

                // AciklamaVC'nin storyboard ID'si ile instantiate ediliyor
                if let aciklamaVC = storyboard?.instantiateViewController(withIdentifier: "AciklamaVC") as? AciklamaVC {
                    // Seçilen kelimenin bilgilerini AciklamaVC'ye iletiyoruz
                    aciklamaVC.selectedKelime = selectedKelime
                    // AciklamaVC'yi gösteriyoruz
                    navigationController?.pushViewController(aciklamaVC, animated: true)
                }
        gecmisTV.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard indexPath.row < gecmisKelimeler.count else {
                print("Invalid index for trailing swipe action")
                return nil
            }

            let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [self] (_, _, completionHandler) in
                let deletedKelime = self.gecmisKelimeler[indexPath.row]

                // TableView'dan hücreyi kaldır
                gecmisTV.beginUpdates()
                gecmisKelimeler.remove(at: indexPath.row)
                gecmisTV.deleteRows(at: [indexPath], with: .fade)
                gecmisTV.endUpdates()

                // UserDefaultsHelper üzerinden favori kelimeyi sil
                UserDefaultsHelper.shared.deleteGecmisKelime(deletedKelime)

                completionHandler(true)
            }

            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            configuration.performsFirstActionWithFullSwipe = false

            return configuration
        
    }
}
