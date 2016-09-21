//
//  LunarPointerView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

import OpenGLES

class LunarPointerView: PointerView {
    var yearPointer: PointerView
    
    var moonRotation: Float = 0.0
    
    var brightMoonModel: HalfGlobeModel!
    var darkMoonModel: HalfGlobeModel!

    init(component: DeviceComponent, yearPointer pointer: PointerView, shaftLength sLen: Float, shaftRadius sRad: Float, pointerLength pLen: Float, pointerWidth pWidth: Float) {
        yearPointer = pointer
        
        super.init(component: component, shaftLength: sLen, shaftRadius: sRad, pointerLength: pLen, pointerWidth: pWidth)
        
		brightMoonModel = HalfGlobeModel(radius:2.5)
		darkMoonModel = HalfGlobeModel(radius:2.5)
    }

    override func draw() {
        
        super.draw()
        
        let r1 = normalizeRotation(self.rotation)
        let r2 = normalizeRotation(yearPointer.rotation)
        let rotDiff = r2 - r1
        
        moonRotation = rotDiff+90 //RADIANS_TO_DEGREES(cosf(DEGREES_TO_RADIANS(rotDiff)));
        
        glPushMatrix()
        
        if (!depthTest) {
            glTranslatef(position.x, position.y, position.z);
        } else {
            glTranslatef(position.x, position.y, position.z/2);
        }
        glRotatef(myComponent.rotation,0.0, 0.0 ,1.0)
        glTranslatef(self.radius*2/3, 0.0, 0.0)
        
        glEnable(GLenum(GL_DEPTH_TEST))
        
        glPushMatrix()
        glRotatef(moonRotation+180, 1.0, 0.0, 0.0)
        glTranslatef(0.0, 0.1, 0.0)
        glScalef(1.0, 1.0, 1.0)
        glColor4f(1.0, 1.0, 1.0, 1.0*self.opacity)
        brightMoonModel.draw()
        glPopMatrix()
        
        glPushMatrix()
        glRotatef(moonRotation, 1.0, 0.0, 0.0)
        glTranslatef(0.0, 0.1, 0.0)
        glColor4f(0.5, 0.2, 0.2, 1.0*self.opacity)
        darkMoonModel.draw()
        glPopMatrix()
        
        glDisable(GLenum(GL_DEPTH_TEST))
        
        glPopMatrix()
    }

    func normalizeRotation(_ rotation: Float) -> Float {
        var rotation = rotation
        var mult = rotation/360
        
        if (mult >= 1) {
            mult = floorf(mult)
            rotation = rotation - mult*360
        }
        
        return rotation
    }

}
