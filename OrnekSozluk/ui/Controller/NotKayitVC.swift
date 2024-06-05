//
//  NotKayitVC.swift
//  OrnekSozluk
//
//  Created by reel on 4.03.2024.
//

import UIKit

class NotKayitVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var baslikTextView: UITextView!
    @IBOutlet weak var aciklamaTextView: UITextView!
    
    let darkModeBackgroundColor = UIColor(hex: "#171717")
    let lightModeBackgroundColor = UIColor(hex: "#F0F0F0")
    
    var viewModel = KayitViewModel()
//    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white
        
        baslikTextView.delegate = self
        aciklamaTextView.delegate = self
        
        baslikTextView.becomeFirstResponder()
        
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
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let aciklama = aciklamaTextView.text else {
                // Aciklama alani bos ise veya nil ise, kullaniciya uyarı verebilirsiniz.
                return
            }

            var baslik: String
            if let notBaslik = baslikTextView.text, !notBaslik.isEmpty {
                // Kullanıcı bir başlık girmişse bu başlığı kullan
                baslik = notBaslik
            } else {
                // Başlık yoksa veya boşsa otomatik bir başlık ata
                baslik = "Başlıksız Not"
            }

            // Tarih bilgisini al
        let tarih = Date()

            // ViewModel üzerinden notu kaydet
            viewModel.kaydet(not_baslik: baslik, not_aciklama: aciklama, not_tarih: tarih)

            // NotlarVC'ye geçiş yapma işlemi
            if let notlarVC = self.storyboard?.instantiateViewController(withIdentifier: "NotlarVC") as? NotlarVC {
                self.navigationController?.pushViewController(notlarVC, animated: true)
            }
        
//        if let nb = baslikTextView.text, let na = aciklamaTextView.text {
//                    // Not kaydetme işlemi
//            let tarih = Date()
//                    viewModel.kaydet(not_baslik: nb, not_aciklama: na, not_tarih: tarih)
//
//                    // NotlarVC'ye geçiş yapma işlemi
//            if let notlarVC = self.storyboard?.instantiateViewController(withIdentifier: "NotlarVC") as? NotlarVC {
//                    self.navigationController?.pushViewController(notlarVC, animated: true)
//                }
//        }
        
    }
    

    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            return (action == #selector(UIResponderStandardEditActions.copy(_:))
                || action == #selector(UIResponderStandardEditActions.paste(_:))
                || action == #selector(UIResponderStandardEditActions.cut(_:))) ?
                false : super.canPerformAction(action, withSender: sender)
        }
    
}
