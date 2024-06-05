//
//  NotDetayVC.swift
//  OrnekSozluk
//
//  Created by reel on 4.03.2024.
//

import UIKit

class NotDetayVC: UIViewController {
    
//    @IBOutlet weak var penButton: UIBarButtonItem!
//    @IBOutlet weak var camButton: UIBarButtonItem!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    
    @IBOutlet weak var baslikTextView: UITextView!
    @IBOutlet weak var aciklamaTextView: UITextView!
    
    let darkModeBackgroundColor = UIColor(hex: "#171717")
    let lightModeBackgroundColor = UIColor(hex: "#F0F0F0")
    
    var viewModel = DetayViewModel()
    
    var not: NotlarModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white // geri butonu rengini değiştirme
        
        if let n = not {
            baslikTextView.text = n.not_baslik
            aciklamaTextView.text = n.not_aciklama
        }
        
        updateTextViewBackground()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextViewBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    deinit {
            // NotificationCenter'a eklediğimiz observer'ı kaldır
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        }

        @objc func updateTextViewBackground() {
            let backgroundColor: UIColor

            if self.traitCollection.userInterfaceStyle == .dark {
                // Dark mode için arka plan rengi
                backgroundColor = darkModeBackgroundColor
            } else {
                // Light mode için arka plan rengi
                backgroundColor = lightModeBackgroundColor
            }

            // TextView'ların arka plan rengini güncelle
            baslikTextView.backgroundColor = backgroundColor
            aciklamaTextView.backgroundColor = backgroundColor
        }
    
    @IBAction func updateButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let _ = baslikTextView.text, let _ = aciklamaTextView.text, let not = not else {
                // Not bilgileri eksikse veya nil ise, kullanıcıya uyarı verebilirsiniz.
                return
            }

            var yeniBaslik: String
            if let kullaniciGirdisi = baslikTextView.text, !kullaniciGirdisi.isEmpty {
                // Kullanıcı bir başlık girmişse bu başlığı kullan
                yeniBaslik = kullaniciGirdisi
            } else {
                // Başlık yoksa veya boşsa otomatik bir başlık ata
                yeniBaslik = "Başlıksız Not"
            }

            // Yeni aciklama alanı ve tarih bilgisi
            let yeniAciklama = aciklamaTextView.text ?? ""


            // ViewModel üzerinden notu güncelle
            viewModel.guncelle(not: not, not_baslik: yeniBaslik, not_aciklama: yeniAciklama)
            viewModel.guncelleTarih(not: not)

            // NotlarVC'ye geri dönme işlemi
            navigationController?.popViewController(animated: true)
        
//        if let nb = baslikTextView.text, let na = aciklamaTextView.text, let n = not {
//            viewModel.guncelle(not: n, not_baslik: nb, not_aciklama: na)
//            viewModel.guncelleTarih(not: n)
//            
//            // NotlarVC'ye geçiş yapma işlemi
//            if let notlarVC = self.storyboard?.instantiateViewController(withIdentifier: "NotlarVC") as? NotlarVC {
//                self.navigationController?.pushViewController(notlarVC, animated: true)
//            }
//        }
    }
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            return (action == #selector(UIResponderStandardEditActions.copy(_:))
                || action == #selector(UIResponderStandardEditActions.paste(_:))
                || action == #selector(UIResponderStandardEditActions.cut(_:))) ?
                false : super.canPerformAction(action, withSender: sender)
        }

}

