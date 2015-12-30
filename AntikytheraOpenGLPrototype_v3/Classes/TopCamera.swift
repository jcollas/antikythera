//
//  TopCamera.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import OpenGLES

class TopCamera: NSObject, CameraViewpoint {

    func updateViewpoint() {
        glLoadIdentity()
        
        glTranslatef(0.0,0.0,-100.0)
        //glRotatef(-10, 1.0f, 0.0f, 0.0f)
        
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GLenum(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
    }

}
