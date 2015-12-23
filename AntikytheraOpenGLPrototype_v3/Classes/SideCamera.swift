//
//  SideCamera.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

import OpenGLES

class SideCamera: NSObject, CameraViewpoint {

    func updateViewpoint() {
        glLoadIdentity()
        
        glTranslatef(0.0, 0.0, 0)
        glRotatef(-90, 1.0, 0.0, 0.0)
        glTranslatef(0.0, 150.0, 40.0)
        
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GLenum(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
    }

}
