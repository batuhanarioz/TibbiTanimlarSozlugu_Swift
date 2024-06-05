//
//  NotlarDaoRepository.swift
//  OrnekSozluk
//
//  Created by reel on 4.03.2024.
//

import Foundation
import RxSwift
import CoreData

class NotlarDaoRepository {
    
    // RxSwift kullanımı
    var notlarListesi = BehaviorSubject<[NotlarModel]>(value: [NotlarModel]())
    
    let context = appDelegate.persistentContainer.viewContext
    
    func kaydet(not_baslik: String, not_aciklama: String, not_tarih: Date) {
        let not = NotlarModel(context: context)
        not.not_baslik = not_baslik
        not.not_aciklama = not_aciklama
        not.not_tarih = Date()
        
        appDelegate.saveContext()
        print("Not Kaydedildi")
    }
    
    func guncelle(not: NotlarModel, not_baslik: String, not_aciklama: String) {
        not.not_baslik = not_baslik
        not.not_aciklama = not_aciklama
        
        appDelegate.saveContext()
//        print("Not Güncelle : \(not_id) - \(not_baslik) - \(not_aciklama)")
    }
    
    func sil(not: NotlarModel) {
        context.delete(not)
        appDelegate.saveContext()
        
//        print("Not Sil : \(not_id )")
        notlariYukle()
    }
    
    func silTumNotlar() {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NotlarModel.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(batchDeleteRequest)
                try context.save()
                
                notlarListesi.onNext([]) // Boş bir array ile tetikleme
            } catch {
                print("Tüm notlar silinirken hata oluştu: \(error.localizedDescription)")
            }
        }
    
    func ara(aramaKelimesi: String) {
        
        do {
            let fr = NotlarModel.fetchRequest()
            let formatString = "(not_baslik BEGINSWITH[cd] %@)"
            fr.predicate = NSPredicate(format: formatString, aramaKelimesi)
            
            let sortDescriptor = NSSortDescriptor(key: "not_baslik", ascending: true)
            fr.sortDescriptors = [sortDescriptor]
            
            let liste = try context.fetch(fr)
            notlarListesi.onNext(liste) // Tetikleme
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func notlariYukle() {
        
        do {
                let fr = NotlarModel.fetchRequest()
                let sortDescriptorTarih = NSSortDescriptor(key: "not_tarih", ascending: false) // Tarihe göre sıralama
                fr.sortDescriptors = [sortDescriptorTarih]

                let liste = try context.fetch(fr)
            
                notlarListesi.onNext(liste) // Tetikleme
            } catch {
                print(error.localizedDescription)
            }
        
    }
    
    
}

