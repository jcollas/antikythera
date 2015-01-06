//
//  BoxModel.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BoxModel.h"


@implementation BoxModel

- (id) initWithWidth:(float)w Height:(float)h Length:(float)len {
	if (self=[super init]) {
		[self buildModelWithWidth:w Height:h Length:len];
	}
	
	return self;
}

- (void) buildModelWithWidth:(float)w Height:(float)h Length:(float)len {
	float halfLength,halfWidth,halfHeight;
	
	_width = w; halfWidth = _width/2;
	_height = h; halfLength = _height/2;
	_length = len; halfHeight = _length/2;
	
	vertexCount = 8;
	vertices = (Vertex3D*)malloc(vertexCount*sizeof(Vertex3D));
	elementCount = 34;
	elements = (GLushort*)malloc(elementCount*sizeof(GLushort));
	
	// Pointer Vertices
	vertices[0] = Vertex3DMake(halfLength,-halfWidth,halfHeight);
	vertices[1] = Vertex3DMake(halfLength,halfWidth,halfHeight);
	
	vertices[2] = Vertex3DMake(-halfLength,-halfWidth,halfHeight);
	vertices[3] = Vertex3DMake(-halfLength,halfWidth,halfHeight);
	
	vertices[4] = Vertex3DMake(halfLength,-halfWidth,-halfHeight);
	vertices[5] = Vertex3DMake(halfLength,halfWidth,-halfHeight);
	
	vertices[6] = Vertex3DMake(-halfLength,-halfWidth,-halfHeight);
	vertices[7] = Vertex3DMake(-halfLength,halfWidth,-halfHeight);
	
	// Pointer Elements
	elements[0] =	0;
	elements[1] =	1;
	elements[2] =	2;
	elements[3] =	3;
	
	elements[4] =	3;
	elements[5] =	1;
	
	elements[6] =	1;
	elements[7] =	5;
	elements[8] =	3;
	elements[9] =	7;
	
	elements[10] =	7;
	elements[11] =	5;
	
	elements[12] =	5;
	elements[13] =	4;
	elements[14] =	7;
	elements[15] =	6;
	
	elements[16] =	6;
	elements[17] =	4;
	
	elements[18] =	4;
	elements[19] =	0;
	elements[20] =	6;
	elements[21] =	2;
	
	elements[22] =	2;
	elements[23] =	0;
	
	elements[24] =	0;
	elements[25] =	4;
	elements[26] =	1;
	elements[27] =	5;
	
	elements[28] =	5;
	elements[29] =	3;
	
	elements[30] =	3;
	elements[31] =	7;
	elements[32] =	2;
	elements[33] =	6;
	
	
//	elements[0] =	0;
//	elements[1] =	1;
//	elements[2] =	3;
//	elements[3] =	5;
//	elements[4] =	7;
//	elements[5] =	6;
//	elements[6] =	3;
//	elements[7] =	2;
//	elements[8] =	0;
//	elements[9] =	6;
//	elements[10] =	4;
//	elements[11] =	5;
//	elements[12] =	0;
//	elements[13] =	1;
}

@end
