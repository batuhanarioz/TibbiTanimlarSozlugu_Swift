//
//  FavoriVC.swift
//  OrnekSozluk
//
//  Created by reel on 4.03.2024.
//

import UIKit
import GoogleMobileAds

class FavoriVC: UIViewController {

    @IBOutlet weak var favoriTV: UITableView!
    @IBOutlet weak var favoriSil: UIBarButtonItem!
    @IBOutlet weak var favoriPaylas: UIBarButtonItem!
    
    var favoriKelimeler: [Kelime] = []
    
//    private let banner: GADBannerView = {
//        let banner = GADBannerView()
//        banner.adUnitID = "ca-app-pub-9864832018781672/2176002896"
//        banner.load(GADRequest())
//        banner.backgroundColor = .secondarySystemBackground
//        return banner
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        banner.rootViewController = self
//        view.addSubview(banner)

        customizeNavigationBar()
        
        favoriTV.delegate = self
        favoriTV.dataSource = self
        
        // Favori kelimeleri yükleyip tableView'ı güncelle
            favoriKelimeler = UserDefaultsHelper.shared.getFavoriKelimeler()
            favoriTV.reloadData()

            // NotificationCenter observer ekle
            NotificationCenter.default.addObserver(self, selector: #selector(favoriKelimelerDidUpdate), name: .favoriKelimelerDidUpdate, object: nil)
        
        let bottomInset: CGFloat = 50.0
        favoriTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
            
        
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
    
    @IBAction func favoriSilPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Temizle", message: "Tüm favori kelimelerinizi silmek istediğinize emin misiniz ?", preferredStyle: .alert)

            let evetAction = UIAlertAction(title: "Evet", style: .destructive) { _ in
                // Kullanıcının tüm favori kelimeleri silmeyi onaylaması durumunda yapılacak işlemler
                UserDefaultsHelper.shared.clearFavoriKelimeler()
                self.favoriKelimeler.removeAll()
                self.favoriTV.reloadData()
            }

            let iptalAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)

            alertController.addAction(evetAction)
            alertController.addAction(iptalAction)

            present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func favoriKelimelerDidUpdate() {
            // NotificationCenter ile favori kelimeler güncellendiğinde çağrılacak metod
            favoriKelimeler = UserDefaultsHelper.shared.getFavoriKelimeler()
        favoriKelimeler.reverse()
            favoriTV.reloadData()
        }
    
    @IBAction func sharePressed(_ sender: UIBarButtonItem) {
        // Favori kelimeleri bir metin dosyasına dönüştür
                let textData = convertToFavoriTextData()

                // Metin dosyasını geçici bir konumda kaydet
                guard let textFileURL = saveTextFile(textData: textData) else {
                    print("Error saving text file.")
                    return
                }

                // Metin dosyasını paylaş
                shareTextFile(fileURL: textFileURL)
    }
    
    // Favori kelimeleri metin dosyasına dönüştürme işlemi
    func convertToFavoriTextData() -> Data {
        var textContent = ""

        for kelime in favoriKelimeler {
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
        let textFileURL = tempDirectory.appendingPathComponent("favori_kelimeler.txt")

        // Metin dosyasını oluşturulan konumda kaydedin
        do {
            try textData.write(to: textFileURL)
            return textFileURL
        } catch {
            print("Error saving text file: \(error.localizedDescription)")
            return nil
        }
    }

    // Metin dosyasını paylaşma işlemi
    func shareTextFile(fileURL: URL) {
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
}

extension FavoriVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
    

extension FavoriVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriKelimeler.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < favoriKelimeler.count else {
            fatalError("Index out of range hatası: \(indexPath.row) - \(favoriKelimeler.count)")
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriCell", for: indexPath)
        let favoriKelime = favoriKelimeler[indexPath.row]
        cell.textLabel?.text = favoriKelime.kelime

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedKelime = favoriKelimeler[indexPath.row]

                // AciklamaVC'nin storyboard ID'si ile instantiate ediliyor
                if let aciklamaVC = storyboard?.instantiateViewController(withIdentifier: "AciklamaVC") as? AciklamaVC {
                    // Seçilen kelimenin bilgilerini AciklamaVC'ye iletiyoruz
                    aciklamaVC.selectedKelime = selectedKelime
                    // AciklamaVC'yi gösteriyoruz
                    navigationController?.pushViewController(aciklamaVC, animated: true)
                }
        favoriTV.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard indexPath.row < favoriKelimeler.count else {
                print("Invalid index for trailing swipe action")
                return nil
            }

            let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [self] (_, _, completionHandler) in
                let deletedKelime = self.favoriKelimeler[indexPath.row]

                // TableView'dan hücreyi kaldır
                favoriTV.beginUpdates()
                favoriKelimeler.remove(at: indexPath.row)
                favoriTV.deleteRows(at: [indexPath], with: .fade)
                favoriTV.endUpdates()

                // UserDefaultsHelper üzerinden favori kelimeyi sil
                UserDefaultsHelper.shared.deleteFavoriKelime(deletedKelime)

                completionHandler(true)
            }

            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            configuration.performsFirstActionWithFullSwipe = false

            return configuration
        
    }

}
