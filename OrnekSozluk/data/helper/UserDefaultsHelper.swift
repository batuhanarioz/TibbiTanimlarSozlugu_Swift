//
//  UserDefaultsHelper.swift
//  OrnekSozluk
//
//  Created by reel on 4.03.2024.
//

import Foundation



class UserDefaultsHelper {
    
    static let shared = UserDefaultsHelper()
    
    private let favoriKelimeKey = "favoriKelimeKey"
    private let gecmisKelimeKey = "gecmisKelimeKey"
    
    private init() {}
    
    func addFavoriKelime(_ kelime: Kelime) {
        // Daha önce favori eklenmiş kelimeleri al
        var favoriKelimeler = getFavoriKelimeler()
        
        // Eğer kelime favori listesinde değilse ekle
        if !favoriKelimeler.contains(where: { $0.kelime == kelime.kelime }) {
            favoriKelimeler.append(kelime)
            // UserDefaults üzerine güncellenmiş favori listesini kaydet
            saveFavoriKelimeler(favoriKelimeler)
            
            // Favori eklendikten sonra NotificationCenter ile bildirim gönder
            NotificationCenter.default.post(name: .favoriKelimelerDidUpdate, object: nil)
        }
    }

    
    func getFavoriKelimeler() -> [Kelime] {
        guard let data = UserDefaults.standard.data(forKey: favoriKelimeKey) else {
//            print("Favori kelimeler bulunamadı.")
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let favoriKelimeler = try decoder.decode([Kelime].self, from: data)
            return favoriKelimeler
        } catch {
            print("Error decoding favoriKelimeler: \(error)")
            return []
        }
    }
    
    func saveFavoriKelimeler(_ favoriKelimeler: [Kelime]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favoriKelimeler)
            UserDefaults.standard.set(data, forKey: favoriKelimeKey)
        } catch {
            print("Error encoding favoriKelimeler: \(error)")
        }
    }
    
    func removeFavoriKelime(at index: Int) {
        var favoriKelimeler = getFavoriKelimeler()
        
        guard index >= 0, index < favoriKelimeler.count else {
            print("Invalid index for removing favori kelime")
            return
        }
        
        favoriKelimeler.remove(at: index)
        saveFavoriKelimeler(favoriKelimeler)
    }
    
    func deleteFavoriKelime(_ kelime: Kelime) {
        var favoriKelimeler = getFavoriKelimeler()

        // Eğer kelime favori listesindeyse sil
        if let index = favoriKelimeler.firstIndex(where: { $0.kelime == kelime.kelime }) {
            favoriKelimeler.remove(at: index)
            // UserDefaults üzerine güncellenmiş favori listesini kaydet
            saveFavoriKelimeler(favoriKelimeler)
            // NotificationCenter ile güncelleme bildirimi gönder
            NotificationCenter.default.post(name: .favoriKelimelerDidUpdate, object: nil)
        }
    }
    
    func clearFavoriKelimeler() {
        UserDefaults.standard.removeObject(forKey: favoriKelimeKey)
        
        // Favori listesi temizlendikten sonra NotificationCenter ile bildirim gönder
        NotificationCenter.default.post(name: .favoriKelimelerDidUpdate, object: nil)
    }
    
    func isKelimeFavori(_ kelime: Kelime) -> Bool {
        let favoriKelimeler = getFavoriKelimeler()
        return favoriKelimeler.contains(where: { $0.kelime == kelime.kelime })
    }
    
    func getGecmisKelimeler() -> [Kelime] {
            guard let data = UserDefaults.standard.data(forKey: gecmisKelimeKey) else {
                return []
            }

            do {
                let decoder = JSONDecoder()
                let gecmisKelimeler = try decoder.decode([Kelime].self, from: data)
                return gecmisKelimeler
            } catch {
                print("Error decoding gecmisKelimeler: \(error)")
                return []
            }
    }
    
    func clearGecmisKelimeler() {
        UserDefaults.standard.removeObject(forKey: gecmisKelimeKey)
        
        // Favori listesi temizlendikten sonra NotificationCenter ile bildirim gönder
        NotificationCenter.default.post(name: .gecmisKelimelerDidUpdate, object: nil)
    }

    func saveGecmisKelimeler(_ gecmisKelimeler: [Kelime]) {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(gecmisKelimeler)
                UserDefaults.standard.set(data, forKey: gecmisKelimeKey)
            } catch {
                print("Error encoding gecmisKelimeler: \(error)")
            }
    }
    
    func addGecmisKelime(_ kelime: Kelime) {
            // Daha önce geçmişe eklenmiş kelimeleri al
            var gecmisKelimeler = getGecmisKelimeler()

            // Eğer kelime geçmiş listesinde değilse ekle
            if !gecmisKelimeler.contains(where: { $0.kelime == kelime.kelime }) {
                gecmisKelimeler.append(kelime)
                // UserDefaults üzerine güncellenmiş geçmiş listesini kaydet
                saveGecmisKelimeler(gecmisKelimeler)
            }
        
        NotificationCenter.default.post(name: Notification.Name("GecmisKelimeEklendi"), object: nil)
    }
    
    func deleteGecmisKelime(_ kelime: Kelime) {
        var gecmisKelimeler = getGecmisKelimeler()

        // Eğer kelime favori listesindeyse sil
        if let index = gecmisKelimeler.firstIndex(where: { $0.kelime == kelime.kelime }) {
            gecmisKelimeler.remove(at: index)
            // UserDefaults üzerine güncellenmiş favori listesini kaydet
            saveGecmisKelimeler(gecmisKelimeler)
            // NotificationCenter ile güncelleme bildirimi gönder
            NotificationCenter.default.post(name: .gecmisKelimelerDidUpdate, object: nil)
        }
    }

}


extension Notification.Name {
    static let favoriKelimelerDidUpdate = Notification.Name("favoriKelimelerDidUpdate")
    static let gecmisKelimelerDidUpdate = Notification.Name("gecmisKelimelerDidUpdate")
}
