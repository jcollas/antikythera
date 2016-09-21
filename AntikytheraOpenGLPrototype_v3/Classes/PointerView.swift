//
//  PointerView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import OpenGLES

class PointerView: NSObject, ComponentView, AMViewStateHandler {
    var myComponent: DeviceComponent!
    
    var position = Vector3D.zero
    var opacity: Float = 1.0
    var depthTest = false
    
    var pointerModel: PointerModel!

    // Initialize with gear. This is the gear to be drawn by this view.
    init(component: DeviceComponent, shaftLength sLen: Float, shaftRadius sRad: Float, pointerLength pLen: Float, pointerWidth pWidth: Float) {
        
        super.init()
		myComponent = component
		
		
		pointerModel = PointerModel(shaftLength:sLen, shaftRadius:sRad, pointerLength:pLen, pointerWidth:pWidth)
    }

    // Set position in 3D space
    func setPosition(_ pos: Vector3D) {
        position = pos
    }

    func setPositionRelativeTo(_ component: ComponentView, verticalOffset vOffset: Float) {
        let v = component.position
        
        position.x = v.x
        position.y = v.y
        position.z = v.z + vOffset
    }

    // Protocol Methods:
    var rotation: Float {
        return myComponent.rotation
    }

    var radius: Float {
        return Float(pointerModel.pointerLength)
    }

    func draw() {
	
	if self.opacity > 0.0 {
		glPushMatrix()
		
		if (!depthTest) {
			glTranslatef(position.x, position.y, position.z)
		} else {
			glTranslatef(position.x, position.y, position.z/2)
		}
		let rotation = myComponent.rotation
		glRotatef(rotation, 0.0, 0.0, 1.0)
		
        if (depthTest) {
            glEnable(GLenum(GL_DEPTH_TEST))
        }
		
		glPushMatrix()
		glScalef(1.0, 1.0, 1.0)
		glColor4f(1.0, 1.0, 1.0, 0.5*self.opacity)
		pointerModel.draw()
		glPopMatrix()
		
        if (depthTest) {
            glDisable(GLenum(GL_DEPTH_TEST))
        }
		
		glPopMatrix()
	}
}

    func updateWithState(_ state: AMState, phase: AMStatePhase) {
        switch (state) {
        case .pointers:
            opacity = 1.0
            depthTest = false

        case .gears:
            opacity = 0.2
            depthTest = false

        case .box:
            opacity = 1.0
            depthTest = true

        case .pinAndSlot:
            opacity = 0.0

        default: //STATE_DEFAULT
            opacity = 1.0
            depthTest = false
        }
    }

}
