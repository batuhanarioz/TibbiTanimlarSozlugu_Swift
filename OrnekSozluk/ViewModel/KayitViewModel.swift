//
//  KayitViewModel.swift
//  OrnekSozluk
//
//  Created by reel on 4.03.2024.
//

import Foundation

class KayitViewModel {
    
    var nrepo = NotlarDaoRepository()
    
    func kaydet(not_baslik: String, not_aciklama: String, not_tarih: Date) {
        nrepo.kaydet(not_baslik: not_baslik, not_aciklama: not_aciklama, not_tarih: not_tarih)
//        print("Not Kaydedildi: \(not_baslik) - \(not_aciklama)")
    }
    
}
