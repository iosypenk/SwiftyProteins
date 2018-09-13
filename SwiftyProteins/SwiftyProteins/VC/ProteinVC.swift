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

    @IBOutlet weak var proteinScene: SCNView!
    @IBOutlet weak var atomName: UILabel!
    @IBOutlet weak var atomMass: UILabel!
    @IBOutlet weak var atomBoil: UILabel!
    @IBOutlet weak var atomNumber: UILabel!
    @IBOutlet weak var atomPeriod: UILabel!
    @IBOutlet weak var atomDensity: UILabel!
    @IBOutlet weak var atomMelt: UILabel!
    @IBOutlet weak var atomMolarHeat: UILabel!
    @IBOutlet weak var atomSummary:UITextView!
    @IBOutlet weak var atomPhase: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    var oldNode: SCNNode?
    var oldColor: UIColor?
    var pdbfile : String?
    var name : String?
    var atoms: Elements?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        proteinScene.backgroundColor = UIColor.white
        proteinScene.allowsCameraControl = true
        proteinScene.autoenablesDefaultLighting = true
        atomSummary.isEditable = false
        proteinScene.scene = ProteinScene(pdbFile: pdbfile!)
        
        stackView.isHidden = true
        atomSummary.isHidden = true
        atomName.text = ""
        atoms = GetAtomInfo().getInfo()
        
        navigationItem.title = name ?? ""
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor(red: 220/255, green: 224/255, blue: 230/255, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let doneButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareAction))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.oldNode?.removeAllActions()
    }
    
    @objc func shareAction() {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0.0)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let img = img {
            let objectsToShare = [img] as [UIImage]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: proteinScene)
        let hitList = proteinScene.hitTest(location, options: nil)
    
        DispatchQueue.main.async {
            if let hitObject = hitList.first {
                if hitObject.node.name != "CONECT" && touches.count == 1 {
                    
                    self.oldNode?.removeAllActions()
                    self.oldNode?.geometry?.firstMaterial?.diffuse.contents = self.oldColor
                    
                    for element in (self.atoms?.elements)! {
                        if (element.symbol?.lowercased() == hitObject.node.name?.lowercased()) {
                            self.initAtomLabels(element: element)
                            self.manageSphereSelection(sphere: hitObject.node)
                        }
                    }
                }
            } else if (touches.count > 1) {
                self.stackView.isHidden = true
                self.atomSummary.isHidden = true
                self.atomName.text = ""
                
                self.oldNode?.removeAllActions()
                self.oldNode?.geometry?.firstMaterial?.diffuse.contents = self.oldColor
            }
        }
    }
    
    func manageSphereSelection(sphere: SCNNode) {
        let oldColor = sphere.geometry?.firstMaterial?.diffuse.contents as! UIColor
        let newColor = UIColor(displayP3Red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)
        let duration: TimeInterval = 0.5
        let act0 = SCNAction.customAction(duration: duration, action: { (node, elapsedTime) in
            let percentage = elapsedTime / CGFloat(duration)
            node.geometry?.firstMaterial?.diffuse.contents = self.aniColor(from: newColor, to: oldColor, percentage: percentage)
        })
        let act1 = SCNAction.customAction(duration: duration, action: { (node, elapsedTime) in
            let percentage = elapsedTime / CGFloat(duration)
            node.geometry?.firstMaterial?.diffuse.contents = self.aniColor(from: oldColor, to: newColor, percentage: percentage)
        })
        
        let act = SCNAction.repeatForever(SCNAction.sequence([act0, act1]))
        sphere.runAction(act)
        
        self.oldNode = sphere
        self.oldColor = oldColor
    }
    func aniColor(from: UIColor, to: UIColor, percentage: CGFloat) -> UIColor {
        let fromComponents = from.cgColor.components!
        let toComponents = to.cgColor.components!
        
        let color = UIColor(red: fromComponents[0] + (toComponents[0] - fromComponents[0]) * percentage,
                            green: fromComponents[1] + (toComponents[1] - fromComponents[1]) * percentage,
                            blue: fromComponents[2] + (toComponents[2] - fromComponents[2]) * percentage,
                            alpha: fromComponents[3] + (toComponents[3] - fromComponents[3]) * percentage)
        return color
    }
    
    func initAtomLabels (element: AtomInfo) {
        stackView.isHidden = false
        atomSummary.isHidden = false
        atomName.text = element.name! + " (" + element.symbol! + ")"
        atomMass.text = "Atomic mass: " + (element.atomic_mass == nil ? "no info" : String(format: "%.3f", element.atomic_mass!))
        atomBoil.text = "Boil temp: " + (element.boil == nil ? "no info" : String(describing: element.boil!))
        atomNumber.text = "Number: " + (element.number == nil ? "no info" : String(describing: element.number!))
        atomPeriod.text = "Period: " + (element.period == nil ? "no info" : String(describing: element.period!))
        atomDensity.text = "Density: " + (element.density == nil ? "no info" : String(describing: element.density!))
        atomPhase.text = "Phase: " + (element.phase == nil ? "no info" : String(describing: element.phase!))
        atomMelt.text = "Melt: " + (element.melt == nil ? "no info" : String(describing: element.melt!))
        atomMolarHeat.text = "Molar heat: " + (element.molar_heat == nil ? "no info" : String(describing: element.molar_heat!))
        atomSummary.text = element.summary
    }
}
