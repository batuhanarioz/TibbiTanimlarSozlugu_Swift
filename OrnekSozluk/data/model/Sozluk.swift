//
//  Sozluk.swift
//  OrnekSozluk
//
//  Created by reel on 4.03.2024.
//

import Foundation

struct Kelime: Codable, Equatable, Comparable {
    var kelime: String
    var aciklama: String
    
    static func < (lhs: Kelime, rhs: Kelime) -> Bool {
            return lhs.kelime < rhs.kelime
        }
}

class Sozluk {
    static let shared = Sozluk()

    var kelimeler: [Kelime]

    private init() {
        // Uygulama başlatıldığında veriyi yükle
        kelimeler = Sozluk.loadKelimelerFromJSON()
    }

    private static func loadKelimelerFromJSON() -> [Kelime] {
        if let path = Bundle.main.path(forResource: "kelimeler", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                let kelimeler = try decoder.decode([Kelime].self, from: data)
                return kelimeler
            } catch {
                print("Error loading JSON file: \(error)")
            }
        }
        return []
    }
}
