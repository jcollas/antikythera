//
//  PinAndSlotConnector.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import Foundation
import CoreGraphics

class PinAndSlotConnector: Connector {
    
    var arborOffset: Float = 0.0
    var pinOffset: Float = 0.0

    // Initialize with a certain radius, along with pin and slot info
    init(radius: Float, arborOffset: Float, pinOffset: Float) {
        
        self.arborOffset = arborOffset
        self.pinOffset = pinOffset
        
        super.init(radius: radius)
    }
    
    
    override init(dict: [String:AnyObject], allGears: [String:Gear]) throws {
        try! super.init(dict: dict, allGears: allGears)
        
        guard let topGearName = dict["topGear"] as? String else { return }
        guard let bottomGearName = dict["bottomGear"] as? String else { return }
        
        guard let topGear = allGears[topGearName] else { return }
        guard let bottomGear = allGears[bottomGearName] else { return }
        
        self.arborOffset = (bottomGear.radius*2) - (topGear.radius*2)
        self.pinOffset = topGear.radius*0.7
                    
    }

    var slotOffset: Float {
        return pinOffset
    }
    
    var pinRotation: Float {
        return rotation
    }

    var slotRotation: Float {
        return bottomComponent!.rotation
    }

    override func updateBottomComponentRotation(_ arcAngle: Float) {
        
        if hasBottomComponent {
            //		if (arcAngle == 0.0f) { [bottomComponent updateRotation:arcAngle FromSource:self] }
            
            let oldRot = Float(DegreesToRadians(Double(rotation-arcAngle)))
            let newRot = Float(DegreesToRadians(Double(rotation)))
            
            var oldPinPosition = Vector3D(x: pinOffset*cosf(oldRot), y: pinOffset*sinf(oldRot), z: 0.0)
            var newPinPosition = Vector3D(x: pinOffset*cosf(newRot), y: pinOffset*sinf(newRot), z: 0.0)
            
            let arbor = Vector3D(x: arborOffset, y: 0.0, z: 0.0)
            
            oldPinPosition = arbor.startAndEndPoints(oldPinPosition)
            newPinPosition = arbor.startAndEndPoints(newPinPosition)
            
            oldPinPosition.normalize()
            newPinPosition.normalize()
            
            let sign = (arcAngle/abs(arcAngle))
            
            let angle = sign*acosf(oldPinPosition.x*newPinPosition.x + oldPinPosition.y*newPinPosition.y)
            
            bottomComponent?.updateRotation(Float(RadiansToDegrees(Double(angle))), fromSource:self)
        }
    }

}
