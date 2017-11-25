//
//  ARRing.swift
//  ARRace
//
//  Created by Răzvan-Gabriel Geangu on 25/11/2017.
//  Copyright © 2017 Răzvan-Gabriel Geangu. All rights reserved.
//

import SceneKit

class ARRing: SCNNode {
    
    override init() {
        super.init()
        
        let ring = SCNSphere(radius: 0.5)
        ring.segmentCount = 50
        self.geometry = ring
        
        let shape = SCNPhysicsShape(geometry: ring, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        self.opacity = 0.5
        ring.firstMaterial?.diffuse.contents = UIColor(rgb: 0x00e5ff)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

