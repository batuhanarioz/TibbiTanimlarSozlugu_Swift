//
//  Notlar.swift
//  OrnekSozluk
//
//  Created by reel on 4.03.2024.
//

import Foundation

class Notlar {
    var not_id: Int?
    var not_baslik: String?
    var not_aciklama: String?
    var mediaList: [Media]?
    
    init(not_id: Int?, not_baslik: String?, not_aciklama: String?, mediaList: [Media]?) {
        self.not_id = not_id
        self.not_baslik = not_baslik
        self.not_aciklama = not_aciklama
        self.mediaList = mediaList
    }
}

//class Notlar {
//    var not_id: Int?
//    var not_baslik: String?
//    var not_aciklama: String?
//    
//    init() {
//        
//    }
//    
//    init(not_id: Int, not_baslik: String, not_aciklama: String) {
//        self.not_id = not_id
//        self.not_baslik = not_baslik
//        self.not_aciklama = not_aciklama
//    }
//}

class Media {
    var image: Data?
    var video: Data?
    
    
    init(image: Data, video: Data) {
        self.image = image
        self.video = video
    }
}

