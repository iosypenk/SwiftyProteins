//
//  ProteinVC.swift
//  SwiftyProteins
//
//  Created by Ivan OSYPENKO on 9/3/18.
//  Copyright © 2018 iosypenk & mrybak team. All rights reserved.
//

import UIKit
import SceneKit

class ProteinVC: UIViewController {

    var pdbfile : String?
    @IBOutlet weak var proteinScene: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        proteinScene.backgroundColor = UIColor.white
        proteinScene.allowsCameraControl = true
        proteinScene.autoenablesDefaultLighting = true
        
        proteinScene.scene = ProteinScene(pdbFile: pdbfile!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: proteinScene)
        let hitList = proteinScene.hitTest(location, options: nil)
        
        if let hitObject = hitList.first {
            if hitObject.node.name != "CONECT" {
                print(hitObject.node.name ?? "")
            }
        }
    }
}
