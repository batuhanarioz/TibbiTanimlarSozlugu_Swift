//
//  NotlarVC.swift
//  OrnekSozluk
//
//  Created by reel on 3.03.2024.
//

import UIKit
import CoreData
import GoogleMobileAds

class NotlarVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var notlarTV: UITableView!
    @IBOutlet weak var notEkle: UIBarButtonItem!
    @IBOutlet weak var notSil: UIBarButtonItem!
    
    var notlarListesi = [NotlarModel]()
    
    var viewModel = NotlarViewModel()
    
//    private let banner: GADBannerView = {
//        let banner = GADBannerView()
//        banner.adUnitID = "ca-app-pub-9864832018781672/7428329573"
//        banner.load(GADRequest())
//        banner.backgroundColor = .secondarySystemBackground
//        return banner
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        banner.rootViewController = self
//        view.addSubview(banner)
       
        customizeNavigationBar()
        setupTapGesture()

        _ = viewModel.notlarListesi.subscribe(onNext: { liste in
            self.notlarListesi = liste
            self.notlarTV.reloadData()
        })

        searchBar.delegate = self
        notlarTV.delegate = self
        notlarTV.dataSource = self
        
        let bottomInset: CGFloat = 50.0
        notlarTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)

    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        banner.frame = CGRect(x: 0, y: view.frame.size.height-130, width: view.frame.size.width, height: 50).integral
//    }
  
    override func viewWillAppear(_ animated: Bool) {
        viewModel.notlariYukle()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true) // Klavyeyi kapat
    }
    
    @IBAction func notSilPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Temizle", message: "Tüm notlarınızı silmek istediğinize emin misiniz ?", preferredStyle: .alert)

            let evetAction = UIAlertAction(title: "Evet", style: .destructive) { _ in
                // Kullanıcının tüm favori kelimeleri silmeyi onaylaması durumunda yapılacak işlemler
                NotlarDaoRepository().silTumNotlar()
                self.notlarListesi.removeAll()
                self.notlarTV.reloadData()
            }

            let iptalAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)

            alertController.addAction(evetAction)
            alertController.addAction(iptalAction)

            present(alertController, animated: true, completion: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            if let not = sender as? NotlarModel {
                let gidilecekVC = segue.destination as? NotDetayVC
                gidilecekVC?.not = not
            }
        }
    }


}

extension NotlarVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            viewModel.notlariYukle()
        } else {
            viewModel.ara(aramaKelimesi: searchText)
        }
        
        // searchBar boş iken ya da x butonuna bastığımızda klavye kapanır
//        if searchText.isEmpty{
//                DispatchQueue.main.async { [weak self] in
//                    guard let self = self else{ return }
//                    self.searchBar.resignFirstResponder()
//                }
//            }

    }
    

    
}

extension NotlarVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notlarListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let not = notlarListesi[indexPath.row]
        let hucre = tableView.dequeueReusableCell(withIdentifier: "notCell") as! NotTableViewCell
        
        hucre.baslikLabel.text = not.not_baslik
        hucre.aciklamaLabel.text = not.not_aciklama
        
        if let tarih = not.not_tarih {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
                hucre.tarihLabel.text = dateFormatter.string(from: tarih)
            } else {
                hucre.tarihLabel.text = "Tarih Bilgisi Yok"
            }
        
        return hucre
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let not = notlarListesi[indexPath.row]
        
        performSegue(withIdentifier: "toDetay", sender: not)
        
        // seçili kalma görüntüsünü iptal etme
        notlarTV.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let silAction = UIContextualAction(style: .destructive, title: "Sil") {_,_,_ in
            let not = self.notlarListesi[indexPath.row]
            
            let alert = UIAlertController(title: "Temizle", message: "Notu silmek istediğinize emin misiniz?", preferredStyle: .alert)
            
            let iptalAction = UIAlertAction(title: "İptal", style: .cancel)
            alert.addAction(iptalAction)
            
            let evetAction = UIAlertAction(title: "Evet", style: .destructive) { action in
                self.viewModel.sil(not: not)
            }
            alert.addAction(evetAction)
            
            self.present(alert, animated: true)
            
        }
            
            return UISwipeActionsConfiguration(actions: [silAction])
                
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let paylasAction = UIContextualAction(style: .normal, title: "Paylaş") { [weak self] _, _, completionHandler in
            guard let self = self else { return }

            let selectedNote = self.notlarListesi[indexPath.row]
            
            // DateFormatter kullanarak tarih bilgisini biçimlendir
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            dateFormatter.timeZone = TimeZone(identifier: "GMT + 3") // veya başka bir zaman dilimi

            // Notları metin dosyasına çevir
            let notMetni = """
            Başlık: \(selectedNote.not_baslik ?? "")
            Açıklama: \(selectedNote.not_aciklama ?? "")
            Tarih: \(dateFormatter.string(from: selectedNote.not_tarih ?? Date()))
            """

            // Geçici bir dosya oluştur ve notları bu dosyaya yaz
            if let tempURL = self.createTemporaryFile(content: notMetni, forNote: selectedNote) {
                // Paylaşım için controller oluştur
                let activityViewController = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)

                // iPad için uyumlu bir pop-over penceresi göster
                if let popoverController = activityViewController.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }

                // Paylaşım penceresini göster
                self.present(activityViewController, animated: true, completion: nil)
            }

            completionHandler(true)
        }

        paylasAction.backgroundColor = UIColor(hex: "#6DEA9E")

        return UISwipeActionsConfiguration(actions: [paylasAction])
    }

    // Metni geçici bir dosyaya yazan ve dosyanın yolunu dönen yardımcı fonksiyon
    func createTemporaryFile(content: String, forNote note: NotlarModel) -> URL? {
        do {
            // Geçici bir dosya yolu oluştur
            let tempDirectory = FileManager.default.temporaryDirectory
            let tempFilename = (note.not_baslik ?? "Untitled") + ".txt"
            let tempFileURL = tempDirectory.appendingPathComponent(tempFilename)

            // Metni dosyaya yaz
            try content.write(to: tempFileURL, atomically: true, encoding: .utf8)

            return tempFileURL
        } catch {
            print("Geçici dosya oluşturulurken hata oluştu: \(error.localizedDescription)")
            return nil
        }
    }

    
    
}

extension NotlarVC: UIGestureRecognizerDelegate {
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard(_ gesture: UITapGestureRecognizer) {
        view.endEditing(false)
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
