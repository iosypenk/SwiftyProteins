//
//  ProteinScene.swift
//  ProteinDisplayScene
//
//  Created by Maxym RYBAK on 02.09.2018.
//  Copyright © 2018 iosypenk & mrybak team. All rights reserved.
//

import UIKit
import SceneKit

class ProteinScene: SCNScene, SCNNodeRendererDelegate {
    
    var atoms : [SCNNode?] = []
    var cameraNode: SCNNode!
    
    init(pdbFile: String) {
        super.init()
        initCamera()
        self.background.contents = UIColor(red: 59/255, green: 73/255, blue: 91/255, alpha: 1)
        let protein = pdbFile.split(separator: "\n")
        
        for line in protein {
            let splitedLine = line.split(separator: " ")
            if splitedLine[0] == "ATOM" {
                let sphereGeometry = SCNSphere(radius: 0.3)
                sphereGeometry.firstMaterial?.diffuse.contents = spkColoring(atomName: String(splitedLine[11]))
                let sphereNode = SCNNode(geometry: sphereGeometry)
                sphereNode.position = SCNVector3(Double(splitedLine[6])!, Double(splitedLine[7])!, Double(splitedLine[8])!)
                sphereNode.name = String(splitedLine[11])
                atoms.append(sphereNode)
                self.rootNode.addChildNode(sphereNode)
            }
            else if splitedLine[0] == "CONECT" {
                var i: Int = 0
                let atomsRange = atoms.count
                let parentAtom: Int = Int(splitedLine[1])! - 1
                for elem in splitedLine {
                    let dauterAtom = (Int(elem) ?? 0) - 1
                    if i > 1 {
                        if (parentAtom < atomsRange && dauterAtom < atomsRange) {
                            let newConnection = AtomConnections(v1: (atoms[parentAtom]?.position)!, v2: (atoms[Int(elem)! - 1]?.position)!)
                            newConnection.name = "CONECT"
                            self.rootNode.addChildNode(newConnection)
                        }
                    }
                    i += 1
                }
            }
        }
    }
    
    func initCamera () {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 30)
        
        self.rootNode.addChildNode(cameraNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spkColoring (atomName: String) -> UIColor {
        switch atomName.lowercased() {
        case "h":
            return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        case "c":
            return UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        case "n":
            return UIColor(red: 37/255, green: 51/255, blue: 245/255, alpha: 1)
        case "o":
            return UIColor(red: 234/255, green: 62/255, blue: 37/255, alpha: 1)
        case "f", "cl" :
            return UIColor(red: 113/255, green: 236/255, blue: 78/255, alpha: 1)
        case "br":
            return UIColor(red: 141/255, green: 45/255, blue: 19/255, alpha: 1)
        case "i":
            return UIColor(red: 93/255, green: 14/255, blue: 180/255, alpha: 1)
        case "he", "ne", "ar", "xe", "kr":
            return UIColor(red: 117/255, green: 251/255, blue: 253/255, alpha: 1)
        case "p":
            return UIColor(red: 240/255, green: 158/255, blue: 57/255, alpha: 1)
        case "s":
            return UIColor(red: 251/255, green: 230/255, blue: 84/255, alpha: 1)
        case "b":
            return UIColor(red: 243/255, green: 174/255, blue: 128/255, alpha: 1)
        case "li", "na", "k", "rb", "cs", "fr":
            return UIColor(red: 108/255, green: 18/255, blue: 245/255, alpha: 1)
        case "be", "mg", "ca", "sr", "ba", "ra":
            return UIColor(red: 51/255, green: 117/255, blue: 31/255, alpha: 1)
        case "ti":
            return UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        case "fe":
            return UIColor(red: 207/255, green: 124/255, blue: 45/255, alpha: 1)
        default:
            return UIColor(red: 208/255, green: 124/255, blue: 248/255, alpha: 1)
        }
    }
    
}
