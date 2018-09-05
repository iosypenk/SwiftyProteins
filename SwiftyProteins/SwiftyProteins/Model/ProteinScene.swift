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
    
    var atoms : [SCNNode] = []
    
    init(pdbFile: String) {
        super.init()
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
                for elem in splitedLine {
                    if i > 1 {
                        let newConnection = AtomConnections(v1: atoms[Int(splitedLine[1])! - 1].position, v2: atoms[Int(elem)! - 1].position)
                        newConnection.name = "CONECT"
                        self.rootNode.addChildNode(newConnection)
                    }
                    i += 1
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spkColoring (atomName: String) -> UIColor {
        switch atomName {
        case "H":
            return UIColor.white
        case "C":
            return UIColor.black
        case "N":
            return UIColor(red: 37/255, green: 51/255, blue: 245/255, alpha: 1)
        case "O":
            return UIColor(red: 234/255, green: 62/255, blue: 37/255, alpha: 1)
        case "F", "Cl" :
            return UIColor(red: 113/255, green: 236/255, blue: 78/255, alpha: 1)
        case "Br":
            return UIColor(red: 141/255, green: 45/255, blue: 19/255, alpha: 1)
        case "I":
            return UIColor(red: 93/255, green: 14/255, blue: 180/255, alpha: 1)
        case "He", "Ne", "Ar", "Xe", "Kr":
            return UIColor(red: 117/255, green: 251/255, blue: 253/255, alpha: 1)
        case "P":
            return UIColor(red: 240/255, green: 158/255, blue: 57/255, alpha: 1)
        case "S":
            return UIColor(red: 251/255, green: 230/255, blue: 84/255, alpha: 1)
        case "B":
            return UIColor(red: 243/255, green: 174/255, blue: 128/255, alpha: 1)
        case "Li", "Na", "K", "Rb", "Cs", "Fr":
            return UIColor(red: 108/255, green: 18/255, blue: 245/255, alpha: 1)
        case "Be", "Mg", "Cs", "Rb", "Sr", "Ba", "Ra":
            return UIColor(red: 51/255, green: 117/255, blue: 31/255, alpha: 1)
        case "Ti":
            return UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        case "Fe":
            return UIColor(red: 207/255, green: 124/255, blue: 45/255, alpha: 1)
        default:
            return UIColor(red: 208/255, green: 124/255, blue: 248/255, alpha: 1)
        }
    }
}
