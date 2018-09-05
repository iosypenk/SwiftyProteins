//
//  ProteinVC.swift
//  SwiftyProteins
//
//  Created by Ivan OSYPENKO on 9/3/18.
//  Copyright © 2018 iosypenk & mrybak team. All rights reserved.
//

import UIKit

class ProteinVC: UIViewController {

    var pdbfile : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pdbfile = pdbfile {
            print(pdbfile)
        }
    }
    
    
}
