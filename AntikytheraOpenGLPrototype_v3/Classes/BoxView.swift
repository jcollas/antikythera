//
//  BoxView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

import OpenGLES

class BoxView: NSObject, ComponentView, AMViewStateHandler {
    
    var position = Vector3D.Zero
    var rotation: Float = 0.0
    var opacity: Float = 1.0
    var depthTest = true

    var boxModel: BoxModel!

    // Initialize with gear. This is the gear to be drawn by this view.
    init(width: Float, height: Float, length: Float) {
		boxModel = BoxModel(width: width, height:height, length:length)
    }

    // Set position in 3D space
    func setPosition(pos: Vector3D) {
        position = pos
    }
    
//    func setRotation(rot: Float) {
//        rotation = rot
//    }

    // Protocol Methods:
    func getPosition() -> Vector3D {
        return position
    }

    func getRotation() -> Float {
        return rotation
    }

    func getRadius() -> Float {
        return 0.0
    }

    func getOpacity() -> Float {
        return opacity
    }

    func draw() {
        if getOpacity() > 0.0 {
            glPushMatrix();
            
            glTranslatef(position.x, position.y, position.z)
            glRotatef(rotation, 0.0, 0.0, 1.0)
            if (!depthTest) {
                glScalef(1.0, 1.0, (75.0/35.0))
            }
            
            if (depthTest) {
                glEnable(GLenum(GL_DEPTH_TEST))
            }
            
            glPushMatrix();
            glColor4f(0.855/2, 0.573/2, 0.149/2, getOpacity())
            boxModel.draw()
            glPopMatrix()
            
            if (depthTest) {
                glDisable(GLenum(GL_DEPTH_TEST))
            }
            
            glPopMatrix()
        }
    }

    func updateWithState(state: AMState, phase: AMStatePhase) {
        
        switch state {
            
        case .Pointers, .Gears:
            opacity = 0.1
            depthTest = false

        case .Box:
            opacity = 1.0
            depthTest = true

        case .PinAndSlot:
            opacity = 0.0

        default: //STATE_DEFAULT
            opacity = 0.15
            depthTest = false
        }
    }

}
