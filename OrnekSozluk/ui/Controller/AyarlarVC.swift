//
//  AyarlarVC.swift
//  OrnekSozluk
//
//  Created by reel on 3.03.2024.
//

import UIKit

class AyarlarVC: UIViewController {

    @IBOutlet weak var ayarlarTV: UITableView!
    
    struct Ayar {
            var id: String
            var title: String
        }
        
        // Ayarlar listesi
        var ayarlar: [Ayar] = [
            Ayar(id: "hakkindaAyar", title: "Hakkımızda"),
            Ayar(id: "reklamAyar", title: "İletişim")
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeNavigationBar()
        
        ayarlarTV.delegate = self
        ayarlarTV.dataSource = self
        
        ayarlarTV.isScrollEnabled = false
        
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

extension AyarlarVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ayarlar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ayarlarCell", for: indexPath)
        cell.textLabel?.text = ayarlar[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Seçilen hücreye göre işlemleri yap
        let selectedAyar = ayarlar[indexPath.row]
            
            switch selectedAyar.id {
            case "hakkindaAyar":
                if let hakkindaAyarVC = storyboard?.instantiateViewController(withIdentifier: "HakkindaAyarVC") {
                    navigationController?.pushViewController(hakkindaAyarVC, animated: true)
                }
            case "reklamAyar":
                if let reklamAyarVC = storyboard?.instantiateViewController(withIdentifier: "ReklamAyarVC") {
                    navigationController?.pushViewController(reklamAyarVC, animated: true)
                }
            default:
                break
            }
        
        // Hücre seçimini kaldır
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
