//
//  AtomConnections.swift
//  ProteinDisplayScene
//
//  Created by Maxym RYBAK on 03.09.2018.
//  Copyright © 2018 iosypenk & mrybak team. All rights reserved.
//

import SceneKit

class AtomConnections: SCNNode {
    
    init (v1: SCNVector3, v2: SCNVector3) {
        super.init()
        let parentNode = SCNNode()
        let height = distance(v1: v1, v2: v2)

        self.position = v1
        let nodeV2 = SCNNode()
        nodeV2.position = v2
        parentNode.addChildNode(nodeV2)
        
        let layDown = SCNNode()
        layDown.eulerAngles.x = Float(Double.pi / 2)
        
        let cylinder = SCNCylinder(radius: 0.1, height: CGFloat(height))
        cylinder.firstMaterial?.diffuse.contents = UIColor.white
        
        let nodeWithCylinder = SCNNode(geometry: cylinder)
        nodeWithCylinder.position.y = -height / 2
        layDown.addChildNode(nodeWithCylinder)
        
        self.addChildNode(layDown)
        self.constraints = [SCNLookAtConstraint(target: nodeV2)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func distance (v1: SCNVector3, v2: SCNVector3) -> Float {
        let xd = v2.x - v1.x
        let yd = v2.y - v1.y
        let zd = v2.z - v1.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        
        if (distance < 0){
            return (distance * -1)
        } else {
            return (distance)
        }
    }
    
}
