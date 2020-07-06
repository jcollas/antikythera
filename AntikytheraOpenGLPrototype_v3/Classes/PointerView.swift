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

    class func makePointerView(dict: [String:AnyObject], allGears: [String:Gear], allGearViews: [String:GearView], allPointers: [String:PointerView]) throws -> (PointerView, String) {
        
        // get the common parameters from the dict
        guard let pointerName = (dict["name"] as? String) else { throw AntikytheraError.BuildError("Missing pointer name!") }
        guard let shaftLength = (dict["shaftLength"] as? NSNumber)?.floatValue else { throw AntikytheraError.BuildError("Missing shaftLength!") }
        guard let shaftRadius = (dict["shaftRadius"] as? NSNumber)?.floatValue else { throw AntikytheraError.BuildError("Missing shaftRadius!") }
        guard let pointerLength = (dict["pointerLength"] as? NSNumber)?.floatValue else { throw AntikytheraError.BuildError("Missing pointerLength!") }
        guard let pointerWidth = (dict["pointerWidth"] as? NSNumber)?.floatValue else { throw AntikytheraError.BuildError("Missing pointerWidth!") }
        guard let pointerKind = (dict["pointerKind"] as? String) else { throw AntikytheraError.BuildError("Missing pointerKind!") }
        guard let onGearName = (dict["onGear"] as? String) else { throw AntikytheraError.BuildError("Missing onGear!") }
        
        // make the view from the params!
        let gear = allGears[onGearName]!
        let view : PointerView
        switch pointerKind {
        case "regular":
            view = PointerView(component: gear, shaftLength:shaftLength * kDepthScale, shaftRadius:shaftRadius, pointerLength:pointerLength, pointerWidth:pointerWidth)
            break
            
        case "lunar":
            guard let yearPointerViewName = (dict["rotatesToPointer"] as? String) else { throw AntikytheraError.BuildError("Missing rotatesToPointer!") }
            let yearPointer = allPointers[yearPointerViewName]!
            view = LunarPointerView(component: gear, yearPointer:yearPointer, shaftLength:shaftLength * kDepthScale, shaftRadius:shaftRadius, pointerLength:pointerLength, pointerWidth:pointerWidth)
            break
            
        default:
            throw AntikytheraError.BuildError("Unrecognized pointerKind!")
        }
        
        // and position it!
        let gearView = allGearViews[onGearName]!
        view.setPositionRelativeTo(gearView, verticalOffset: -(shaftLength * kDepthScale))

        
        return (view,pointerName)
    }
    
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
