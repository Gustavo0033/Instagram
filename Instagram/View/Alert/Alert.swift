//
//  Alert.swift
//  Instagram
//
//  Created by Gustavo Mendonca on 06/05/24.
//

import Foundation
import UIKit

class Alert{
    var tittle: String
    var message: String
    
    init(tittle: String, message: String) {
        self.tittle = tittle
        self.message = message
    }
    
    func getAlert()-> UIAlertController{
        
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        
        
        alert.addAction(ok)
        return alert
    }
}
