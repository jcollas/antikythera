//
//  GearView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import OpenGLES

class GearView: NSObject, ComponentView, AMViewStateHandler {
    var myGear: Gear!
    
    var position = Vector3D.zero
    var opacity: Float = 1.0
    
    var isPinAndSlotGear = false
    var isPointerActive = false
    
    var gearModel: GearModel!
    var gearShaderModel: GearShaderModel!
    var pointerModel: BoxModel!

    // Initialize with gear. This is the gear to be drawn by this view.
    init(gear: Gear) {
        myGear = gear
        
        gearModel = GearModel(gear: myGear)
        gearShaderModel = GearShaderModel(gear: myGear)
        pointerModel = BoxModel(width: 1.0, height: 100.0, length: 1.0)
    }

// Set position in 3D space
    func setPosition(_ pos: Vector3D) {
        position = pos
    }

    func setPositionRelativeTo(_ component: ComponentView, atAngle angle: Float) {
        let distance = self.radius + component.radius
        let v = component.position
        
        position.x = v.x + distance*cos(angle)
        position.y = v.y + distance*sin(angle)
        position.z = v.z
    }
    
    func setPositionRelativeTo(_ component: ComponentView, verticalOffset vOffset: Float) {
        let v = component.position
        
        position.x = v.x
        position.y = v.y
        position.z = v.z + vOffset
    }

    func setAsPinAndSlotGear(_ flag: Bool) {
        isPinAndSlotGear = flag
    }

// Protocol Methods:

    var rotation: Float {
        return myGear.rotation
    }

    var radius: Float {
        return myGear.radius
    }

    func draw() {
        if self.opacity > 0.0 {
            glPushMatrix()
            
            glTranslatef(position.x, position.y, position.z)
            glRotatef(rotation, 0.0, 0.0, 1.0)
            
            glPushMatrix()
            glScalef(1.0, 1.0, 0.5)
            glColor4f(1.0, 1.0, 1.0, 0.2*self.opacity)
            gearModel.draw()
            glPopMatrix()
            
            glPushMatrix()
            glScalef(1.0, 1.0, 0.6)
            glColor4f(1.0, 0.0, 0.0, 0.3*self.opacity)
            gearShaderModel.draw()
            glPopMatrix()
            
            if (isPointerActive) {
                glPushMatrix()
                glTranslatef(50.0, 0.0, 0.0)
                glScalef(1.0, 1.0, 0.6)
                glColor4f(1.0, 1.0, 1.0, 1.0)
                pointerModel.draw()
                glPopMatrix()
            }
            
            glPopMatrix()
        }
    }

    func updateWithState(_ state: AMState, phase: AMStatePhase) {
        switch (state) {

            case .pointers:
                opacity = 0.2
                isPointerActive = false

            case .gears:
                opacity = 1.0
                isPointerActive = false

            case .box:
                opacity = 0.0
                isPointerActive = false

            case .pinAndSlot:
                if (isPinAndSlotGear) {
                    opacity = 1.0
                    isPointerActive = true
                } else {
                    opacity = 0.0
                    isPointerActive = false
                }

            default: //STATE_DEFAULT
                opacity = 1.0
                isPointerActive = false
        }
    }

}
