//
//  NotlarViewModel.swift
//  OrnekSozluk
//
//  Created by reel on 4.03.2024.
//

import Foundation
import RxSwift

class NotlarViewModel {
    
    var nrepo = NotlarDaoRepository()
    
    var notlarListesi = BehaviorSubject<[NotlarModel]>(value: [NotlarModel]())
    
    init() {
        notlarListesi = nrepo.notlarListesi
        notlariYukle()
    }
    
    func sil(not: NotlarModel) {
        nrepo.sil(not: not)
    }
    
    func ara(aramaKelimesi: String) {
        nrepo.ara(aramaKelimesi: aramaKelimesi)
    }
    
    func notlariYukle() {
        nrepo.notlariYukle()
    }
    
}
