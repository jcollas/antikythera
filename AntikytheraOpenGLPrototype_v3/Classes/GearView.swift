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
    
    var position = Vector3D.Zero
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
    func setPosition(pos: Vector3D) {
        position = pos
    }

    func setPositionRelativeTo(component: ComponentView, atAngle angle: Float) {
        let distance = self.getRadius() + component.getRadius()
        let v = component.getPosition()
        
        position.x = v.x + distance*cos(angle)
        position.y = v.y + distance*sin(angle)
        position.z = v.z
    }
    
    func setPositionRelativeTo(component: ComponentView, verticalOffset vOffset: Float) {
        let v = component.getPosition()
        
        position.x = v.x
        position.y = v.y
        position.z = v.z + vOffset
    }

    func setAsPinAndSlotGear(flag: Bool) {
        isPinAndSlotGear = flag
    }

// Protocol Methods:
    func getPosition() -> Vector3D {
        return position
    }

    func getRotation() -> Float {
        return myGear.getRotation()
    }

    func getRadius() -> Float {
        return myGear.getRadius()
    }
    
    func getOpacity() -> Float {
        return opacity
    }

    func draw() {
        if self.getOpacity() > 0.0 {
            glPushMatrix()
            
            glTranslatef(position.x, position.y, position.z)
            glRotatef(myGear.getRotation(), 0.0, 0.0, 1.0)
            
            glPushMatrix()
            glScalef(1.0, 1.0, 0.5)
            glColor4f(1.0, 1.0, 1.0, 0.2*self.getOpacity())
            gearModel.draw()
            glPopMatrix()
            
            glPushMatrix()
            glScalef(1.0, 1.0, 0.6)
            glColor4f(1.0, 0.0, 0.0, 0.3*self.getOpacity())
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

    func updateWithState(state: AMState, phase: AMStatePhase) {
        switch (state) {

            case .Pointers:
                opacity = 0.2
                isPointerActive = false

            case .Gears:
                opacity = 1.0
                isPointerActive = false

            case .Box:
                opacity = 0.0
                isPointerActive = false

            case .PinAndSlot:
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
