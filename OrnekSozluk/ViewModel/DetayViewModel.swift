//
//  DetayViewModel.swift
//  OrnekSozluk
//
//  Created by reel on 4.03.2024.
//

import Foundation
import RxSwift

class DetayViewModel {
    
    var nrepo = NotlarDaoRepository()
    
    func guncelle(not: NotlarModel, not_baslik: String, not_aciklama: String) {
        nrepo.guncelle(not: not, not_baslik: not_baslik, not_aciklama: not_aciklama)
    }
    
    func guncelleTarih(not: NotlarModel) {
            not.not_tarih = Date() // Yeni tarih ekleyebilirsiniz
            appDelegate.saveContext()
        }
    
}
