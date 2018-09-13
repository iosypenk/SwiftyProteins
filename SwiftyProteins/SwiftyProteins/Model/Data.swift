//
//  Data.swift
//  SwiftyProteins
//
//  Created by Ivan OSYPENKO on 9/3/18.
//  Copyright © 2018 iosypenk & mrybak team. All rights reserved.
//

import UIKit

class MyData {
    
    var proteinsArr = [String]()
    var filteredArr = [String]()
    
    var pdbFile : String?
    
    func getProteinsArr() {
        let fileName = Bundle.main.path(forResource: "ligands", ofType: "txt")
        do {
            let data = try NSString(contentsOfFile: fileName!, encoding: String.Encoding.utf8.rawValue) as String
            let splitedData = data.split(separator: "\n")
            for key in splitedData {
                proteinsArr.append(String(key))
            }
        } catch let error as NSError {
            print("Can not read ligands.txt : \(error)")
        }
    }
    
    func downloadProtein(name: String, completionHandler: @escaping (String?) -> Void) {        
        let index = name.index(name.startIndex, offsetBy: 1)
        let dir = name[..<index] // directory
        guard let url = URL(string: "https://files.rcsb.org/ligands/\(dir)/\(name)/\(name)_ideal.pdb") else { return }

        let task = URLSession.shared.downloadTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    if let pdbfile : String = try? String(contentsOf: data) {
                        completionHandler(pdbfile)
                    }
                }
            }
        }
        task.resume()
    }
    
    func searchProtein(text: String) {
        
        let lowText = text.lowercased()
        
        if !filteredArr.isEmpty {
            filteredArr.removeAll()
        }
        
        for key in self.proteinsArr {
            let lowKey = key.lowercased()
            if lowKey.hasPrefix(lowText) {
                filteredArr.append(key)
            }
        }
        
        for key in self.proteinsArr {
            var alreadyexists = false
            let lowKey = key.lowercased()
            if lowKey.hasSuffix(lowText) {
                for str in filteredArr {
                    if str == key {
                        alreadyexists = true
                    }
                }
                if !alreadyexists {
                    filteredArr.append(key)
                }
            }
        }
    }

}
