//
//  ViewController.swift
//  OrnekSozluk
//
//  Created by reel on 3.03.2024.
//

import UIKit
import GoogleMobileAds

class Anasayfa: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = AnasayfaViewModel()
    var searchActive: Bool = false
    
    var kelimeler: [Sozluk] = []
    var filteredKelimeler: [Sozluk] = []
    
//    private let banner: GADBannerView = {
//        let banner = GADBannerView()
//        banner.adUnitID = "ca-app-pub-9864832018781672/5029289147"
//        banner.load(GADRequest())
//        banner.backgroundColor = .secondarySystemBackground
//        return banner
//    }()
//    
//    private let banner2: GADBannerView = {
//        let banner2 = GADBannerView()
//        banner2.adUnitID = "ca-app-pub-9864832018781672/2367574585"
//        banner2.load(GADRequest())
//        banner2.backgroundColor = .secondarySystemBackground
//        return banner2
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        banner.rootViewController = self
//        view.addSubview(banner)
//        
//        banner2.rootViewController = self
//        view.addSubview(banner2)
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        setupTapGesture()
        customizeNavigationBar()
        
        viewModel = AnasayfaViewModel()
        viewModel.loadKelimeler()
        
        let bottomInset: CGFloat = 50.0
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        banner.frame = CGRect(x: 0, y: view.frame.size.height-130, width: view.frame.size.width, height: 50).integral
//
//        banner2.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50).integral
//    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true) // Klavyeyi kapat
    }

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

}

extension Anasayfa: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.filteredKelimeler.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "hucreCell", for: indexPath)
            let kelime = viewModel.filteredKelimeler[indexPath.row]
            cell.textLabel?.text = kelime.kelime
            return cell
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.filteredKelimeler.count else {
                    return
                }

                let selectedKelime = viewModel.filteredKelimeler[indexPath.row]

                // AciklamaVC'nin storyboard ID'si ile instantiate ediliyor
                if let aciklamaVC = storyboard?.instantiateViewController(withIdentifier: "AciklamaVC") as? AciklamaVC {
                    // Seçilen kelimenin bilgilerini AciklamaVC'ye iletiyoruz
                    aciklamaVC.selectedKelime = selectedKelime
                    // AciklamaVC'yi gösteriyoruz
                    navigationController?.pushViewController(aciklamaVC, animated: true)
                    // Seçilen kelimeyi UserDefaultsHelper'a ekleyerek geçmişe kaydet
                    UserDefaultsHelper.shared.addGecmisKelime(selectedKelime)
                }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterKelimeler(searchText: searchText)
        tableView.reloadData()
//
//        // Eğer arama metni küçük harfle başlıyorsa, metni otomatik olarak büyük harfe dönüştür
//           if let firstChar = searchText.first, firstChar.isLowercase {
//               let convertedText = convertTurkishUppercase(text: searchText)
//               searchBar.text = convertedText
//           }
        
        // Eğer arama metni "i" harfiyle başlıyorsa ve metnin sadece bir karakterden oluşuyorsa, "i" harfini büyük harfe dönüştür
            if searchText.first == "i", searchText.count == 1 {
                searchBar.text = convertTurkishUppercase(text: searchText)
            }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // Türkçe karakterlerin büyük harf dönüşümü için özel fonksiyon
    func convertTurkishUppercase(text: String) -> String {
        let turkishCharacters = ["i": "İ",]
        
        var convertedText = ""
        for char in text {
            if let upperChar = turkishCharacters[String(char)] {
                convertedText.append(upperChar)
            } else {
                convertedText.append(char)
            }
        }
        
        return convertedText
    }
    
}
    
extension Anasayfa: UIGestureRecognizerDelegate {
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
            // Dokunulan view bir kontrol elemanı (UIButton, UITextField vb.) ise klavyeyi kapatma
            return true
        } else if (touch.view?.findSuperView(of: UITableViewCell.self)) != nil {
            // Dokunulan view bir UITableViewCell içindeyse gesture'a izin ver
            return false
        }
        return true
    }
}

// Bir extension ekleyerek bir view'in belirli bir tipin superclass'ını bulma fonksiyonu
extension UIView {
    func findSuperView<T>(of type: T.Type) -> T? {
        var currentView: UIView? = self
        while let view = currentView {
            if let typedView = view as? T {
                return typedView
            }
            currentView = view.superview
        }
        return nil
    }
}

