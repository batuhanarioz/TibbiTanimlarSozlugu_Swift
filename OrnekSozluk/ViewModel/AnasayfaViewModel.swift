//
//  AnasayfaViewModel.swift
//  OrnekSozluk
//
//  Created by reel on 3.03.2024.
//

class AnasayfaViewModel {

    var kelimeler: [Kelime]
    var filteredKelimeler: [Kelime]

    init() {
        kelimeler = Sozluk.shared.kelimeler
        filteredKelimeler = kelimeler
    }

    func loadKelimeler() {
            // CoreData'den kelimeleri yükle
            kelimeler = Sozluk.shared.kelimeler
            // filteredKelimeler'i boşalt
            filteredKelimeler = []
        }
    
    func filterKelimeler(searchText: String) {
        
            let modifiedSearchText = searchText.prefix(1).uppercased() + searchText.dropFirst()
            
            if modifiedSearchText.count >= 2 {
                // Kullanıcı 3 veya daha fazla karakter girdiyse, normal filtreleme yap
                filteredKelimeler = kelimeler.filter { $0.kelime.lowercased().contains(modifiedSearchText.lowercased()) }
            } 
//        else if modifiedSearchText.count == 2 {
                // Kullanıcı 2 karakter girdiyse, iki harfli kelimeleri filtrele
//                filteredKelimeler = kelimeler.filter { $0.kelime.lowercased().hasPrefix(modifiedSearchText.lowercased()) && $0.kelime.count == 2 }
//            } 
        else if modifiedSearchText.count == 1 {
                // Kullanıcı 1 karakter girdiyse, bir harfli kelimeleri filtrele
                filteredKelimeler = kelimeler.filter { $0.kelime.lowercased().hasPrefix(modifiedSearchText.lowercased()) && $0.kelime.count == 1 }
            } else {
                // Kullanıcı 1 veya hiç karakter girmemişse, kelimeleri gösterme
                filteredKelimeler = []
            }

            if modifiedSearchText.count >= 2 {
                // Arama terimi 3 veya daha fazla karakter içeriyorsa, başlangıç harfiyle eşleşen kelimeleri öne al
                let filteredStartWithSearchText = filteredKelimeler.filter { $0.kelime.lowercased().hasPrefix(modifiedSearchText.lowercased()) }
                // Arama terimi içeren ancak başlangıç harfiyle eşleşmeyen kelimeleri ayır
                let filteredContainSearchText = filteredKelimeler.filter { $0.kelime.lowercased().contains(modifiedSearchText.lowercased()) && !$0.kelime.lowercased().hasPrefix(modifiedSearchText.lowercased()) }

                // Başlangıç harfiyle eşleşen kelimeleri öne alarak filtrelenmiş listeyi güncelle
                filteredKelimeler = filteredStartWithSearchText + filteredContainSearchText
            }
        }

}
