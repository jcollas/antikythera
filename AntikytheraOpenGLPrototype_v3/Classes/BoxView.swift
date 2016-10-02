//
//  BoxView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

import OpenGLES

class BoxView: NSObject, ComponentView, AMViewStateHandler {
    
    var position = Vector3D.zero
    var rotation: Float = 0.0
    var opacity: Float = 1.0
    var radius: Float = 0.0
    var depthTest = true

    var boxModel: BoxModel!

    // Initialize with gear. This is the gear to be drawn by this view.
    init(width: Float, height: Float, length: Float) {
		boxModel = BoxModel(width: width, height:height, length:length)
    }

    // Set position in 3D space
    func setPosition(_ pos: Vector3D) {
        position = pos
    }
    
//    func setRotation(rot: Float) {
//        rotation = rot
//    }

    func draw() {
        if opacity > 0.0 {
            glPushMatrix()
            
            glTranslatef(position.x, position.y, position.z)
            glRotatef(rotation, 0.0, 0.0, 1.0)
            if (!depthTest) {
                glScalef(1.0, 1.0, (75.0/35.0))
            }
            
            if (depthTest) {
                glEnable(GLenum(GL_DEPTH_TEST))
            }
            
            glPushMatrix()
            glColor4f(0.855/2, 0.573/2, 0.149/2, opacity)
            boxModel.draw()
            glPopMatrix()
            
            if (depthTest) {
                glDisable(GLenum(GL_DEPTH_TEST))
            }
            
            glPopMatrix()
        }
    }

    func updateWithState(_ state: AMState, phase: AMStatePhase) {
        
        switch state {
            
        case .pointers, .gears:
            opacity = 0.1
            depthTest = false

        case .box:
            opacity = 1.0
            depthTest = true

        case .pinAndSlot:
            opacity = 0.0

        default: //STATE_DEFAULT
            opacity = 0.15
            depthTest = false
        }
    }

}
