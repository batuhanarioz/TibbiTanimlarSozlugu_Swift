//
//  HakkindaVC.swift
//  OrnekSozluk
//
//  Created by reel on 6.03.2024.
//

import UIKit

class HakkindaVC: UIViewController {

    @IBOutlet weak var hakkindaTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .white
        customizeNavigationBar()
        
        hakkindaTV.delegate = self
        hakkindaTV.dataSource = self
        
        hakkindaTV.rowHeight = UITableView.automaticDimension
        hakkindaTV.estimatedRowHeight = 100
        
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
}

extension HakkindaVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hakkindaCell", for: indexPath) as! HakkindaTableViewCell
        
        if let linkedinURL = URL(string: "https://www.linkedin.com/in/batuhanarioz") {
            cell.linkedinURL = linkedinURL
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
        
       }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
}
