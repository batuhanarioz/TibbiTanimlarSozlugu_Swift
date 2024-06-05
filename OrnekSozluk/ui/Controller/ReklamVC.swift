//
//  ReklamVC.swift
//  OrnekSozluk
//
//  Created by reel on 6.03.2024.
//

import UIKit
import MessageUI
import Firebase

let db = Firestore.firestore()

class ReklamVC: UIViewController, MFMailComposeViewControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
        
    @IBOutlet weak var iletisimLabel: UILabel!
    @IBOutlet weak var isimTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mesajTV: UITextView!
    @IBOutlet weak var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white
        customizeNavigationBar()
                
        // TextView'e sınır çizmek için kalınlık ve renk ayarları
        mesajTV.layer.borderWidth = 1.0
        mesajTV.layer.cornerRadius = 5.0
        mesajTV.layer.borderColor = UIColor(hex: "#6DEA9E").cgColor
        isimTF.layer.borderColor = UIColor(hex: "#6DEA9E").cgColor
        isimTF.layer.borderWidth = 1.0
        emailTF.layer.borderWidth = 1.0
        emailTF.layer.borderColor = UIColor(hex: "#6DEA9E").cgColor
        
        isimTF.returnKeyType = .next
        emailTF.returnKeyType = .next
        mesajTV.returnKeyType = .done
        
        isimTF.delegate = self
        emailTF.delegate = self
        mesajTV.delegate = self
        
        setupTapGesture()
        
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        
        guard let message = mesajTV.text, let email = emailTF.text, let name = isimTF.text else {
            return
            
        }
        
        db.collection("iletisim_mesajlari").addDocument(data: [
            "name": name,
            "email": email,
            "message": message
        ]) { err in
            if let err = err {
                print("Error adding document: \(err.localizedDescription)")
            } else {
                print("Document added successfully")
            }
        }
        
        print("gönder basıldı.")
        self.showSuccessAlert()
        
    }
    
    func showSuccessAlert() {
        let alertController = UIAlertController(title: "Başarılı", message: "Mesajınız gönderildi.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default) { _ in
            // Kullanıcı tamam butonuna bastığında anasayfaya yönlendir
            self.navigateBackToPreviousPage()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func navigateBackToPreviousPage() {
        navigationController?.popViewController(animated: true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Sonraki UITextField'e geç
            switch textField {
            case isimTF:
                emailTF.becomeFirstResponder()
            case emailTF:
                mesajTV.becomeFirstResponder()
            default:
                break
            }
            return true
        }
        
        // UITextViewDelegate metodu: Return tuşuna basıldığında çağrılır
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder() // klavyeyi kapat
                return false
            }
            return true
        }
    
    }
    

extension ReklamVC: UIGestureRecognizerDelegate {
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
