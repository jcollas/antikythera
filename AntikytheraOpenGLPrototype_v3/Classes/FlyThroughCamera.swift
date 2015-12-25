//
//  FlyThroughCamera.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

class FlyThroughCamera: NSObject, CameraViewpoint {
    
    var rot: GLfloat = 0.0
    var lastDrawTime: NSTimeInterval = 0

    func updateViewpoint() {
        
        glLoadIdentity()
        
        glTranslatef(0.0, 0.0, -100.0+50*sin(-rot/100))
        glRotatef(-rot, 1.0, 1.0, 1.0)
        
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GLenum(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        
        if (lastDrawTime != 0) {
            let timeSinceLastDraw = NSDate.timeIntervalSinceReferenceDate() - lastDrawTime
            rot += Float(10 * timeSinceLastDraw)
            //		NSLog(@"%f",timeSinceLastDraw);
        }
        lastDrawTime = NSDate.timeIntervalSinceReferenceDate()
    }

}
