//
//  ShowcaseCamera.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import OpenGLES

class ShowcaseCamera: NSObject, CameraViewpoint {

    var rot: GLfloat = 0.0
    var lastDrawTime: TimeInterval = 0
    
    func updateViewpoint() {
        
        glLoadIdentity()
        
        glTranslatef(0.0,0.0,0)
        glRotatef(-90, 1.0, 0.0, 0.0)
        glTranslatef(0.0, 100.0, 40.0)
        
        glRotatef(45*sin(rot/200), 1.0, 0.0, 0.0)
        glRotatef(-rot, 0.0, 0.0, 1.0)
        
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GLenum(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        
        if lastDrawTime != 0 {
            let timeSinceLastDraw = Date.timeIntervalSinceReferenceDate - lastDrawTime
            rot += Float(5 * timeSinceLastDraw)
            //		NSLog(@"%f",timeSinceLastDraw)
        }
        lastDrawTime = Date.timeIntervalSinceReferenceDate
    }

}
