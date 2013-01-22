//
//  GLModel3D.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelView.h"
#import "OpenGLCommon.h"


@interface GLModel3D : NSObject <ModelView> {
	Vertex3D *vertices;
	GLushort *elements;
	
	int vertexCount;
	int elementCount;
}

+ (void) enableGLModel3D;

@end
