//
//  GLModel3D.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GLModel3D.h"


@implementation GLModel3D

// Set OpenGL ES properties to allow for drawing of this kind
+ (void) enableGLModel3D {
	glEnableClientState(GL_VERTEX_ARRAY);
}

- (void) draw {
	glVertexPointer(3, GL_FLOAT, 0, vertices);
	glDrawElements(GL_TRIANGLE_STRIP, elementCount, GL_UNSIGNED_SHORT, elements);
//	glDrawElements(GL_LINE_STRIP, elementCount, GL_UNSIGNED_SHORT, elements);
}

@end
