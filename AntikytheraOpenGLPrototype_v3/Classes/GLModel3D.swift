//
//  GLModel3D.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import OpenGLES

class GLModel3D: NSObject, ModelView {
    
    var vertices: [Vertex3D] = []
    var elements: [GLushort] = []

// Set OpenGL ES properties to allow for drawing of this kind
    class func enableGLModel3D() {
        glEnableClientState(GLenum(GL_VERTEX_ARRAY))
    }

    func draw() {
        glVertexPointer(3, GLenum(GL_FLOAT), 0, vertices)
        glDrawElements(GLenum(GL_TRIANGLE_STRIP), GLsizei(elements.count), GLenum(GL_UNSIGNED_SHORT), elements)
        //	glDrawElements(GL_LINE_STRIP, elementCount, GL_UNSIGNED_SHORT, elements);
    }

}
