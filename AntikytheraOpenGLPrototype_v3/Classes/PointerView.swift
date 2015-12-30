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
    
    var position = Vector3D.Zero
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
    func setPosition(pos: Vector3D) {
        position = pos
    }

    func setPositionRelativeTo(component: ComponentView, verticalOffset vOffset: Float) {
        let v = component.getPosition()
        
        position.x = v.x
        position.y = v.y
        position.z = v.z + vOffset
    }

    // Protocol Methods:
    func getPosition() -> Vector3D {
        return position
    }

    func getRotation() -> Float {
        return myComponent.getRotation()
    }

    func getRadius() -> Float {
        return Float(pointerModel.pointerLength)
    }
    
    func getOpacity() -> Float {
        return opacity
    }

    func draw() {
	
	if self.getOpacity() > 0.0 {
		glPushMatrix()
		
		if (!depthTest) {
			glTranslatef(position.x, position.y, position.z)
		} else {
			glTranslatef(position.x, position.y, position.z/2)
		}
		let rotation = myComponent.getRotation()
		glRotatef(rotation, 0.0, 0.0, 1.0)
		
        if (depthTest) {
            glEnable(GLenum(GL_DEPTH_TEST))
        }
		
		glPushMatrix()
		glScalef(1.0, 1.0, 1.0)
		glColor4f(1.0, 1.0, 1.0, 0.5*self.getOpacity())
		pointerModel.draw()
		glPopMatrix()
		
        if (depthTest) {
            glDisable(GLenum(GL_DEPTH_TEST))
        }
		
		glPopMatrix()
	}
}

    func updateWithState(state: AMState, phase: AMStatePhase) {
        switch (state) {
        case .Pointers:
            opacity = 1.0
            depthTest = false

        case .Gears:
            opacity = 0.2
            depthTest = false

        case .Box:
            opacity = 1.0
            depthTest = true

        case .PinAndSlot:
            opacity = 0.0

        default: //STATE_DEFAULT
            opacity = 1.0
            depthTest = false
        }
    }

}
