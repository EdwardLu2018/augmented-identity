//
//  ARContentClass.swift
//  augmented-identity
//
//  Created by Edward on 3/31/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import UIKit
import ARKit
import SpriteKit
import Foundation

class ARPlane {
    var plane : SCNPlane
    var node : SCNNode
    init(scene: SKScene, width: CGFloat, height: CGFloat, x: Float, y: Float, z: Float) {
        plane = SCNPlane(width: width, height: height)
        
        plane.cornerRadius = plane.width / 25
        
        plane.firstMaterial?.diffuse.contents = scene
        plane.firstMaterial?.isDoubleSided = true
        plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
        
        node = SCNNode(geometry: plane)
        node.eulerAngles.x = -.pi / 2
        node.opacity = 0.10
        node.position.x = x
        node.position.y = y
        node.position.z = z
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
