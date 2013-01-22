//
//  PointerModel.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "PointerModel.h"


@implementation PointerModel

@synthesize shaftLength;
@synthesize shaftRadius;

@synthesize pointerLength;
@synthesize pointerWidth;

- (id) initWithShaftLength:(float)sLen ShaftRadius:(float)sRad PointerLength:(float)pLen PointerWidth:(float)pWidth {
	if (self = [super init]) {
		[self buildModelWithShaftLength:sLen ShaftRadius:sRad PointerLength:pLen PointerWidth:pWidth]; //Weird bug: for some reason -- gone?
	}
	
	return self;
}

- (void) buildModelWithShaftLength:(float)sLen ShaftRadius:(float)sRad PointerLength:(float)pLen PointerWidth:(float)pWidth {
	float sliceAngle,halfAngle,angle;
	const int sideCount = 8;
	
	shaftLength = sLen;
	shaftRadius = sRad;
	
	pointerLength = pLen;
	pointerWidth = pWidth;
	
	sliceAngle = (2.0f*M_PI)/sideCount;
	halfAngle = sliceAngle/2.0f;
	
	vertexCount = (sideCount*4+2) + (8);
	vertices = (Vertex3D*)malloc(vertexCount*sizeof(Vertex3D));
	elementCount = (sideCount*10+1) + (2) + (14);
	elements = (GLushort*)malloc(elementCount*sizeof(GLushort));
	
	
	// Shaft Vertices:
	vertices[0] = Vertex3DMake(0.0f,0.0f,shaftLength);
	vertices[1] = Vertex3DMake(0.0f,0.0f,0.0f);
	
	for (int i=0; i<sideCount; i++) {
		angle = i*sliceAngle;
		
		vertices[i*4+2] = Vertex3DMake(shaftRadius*cos(angle-halfAngle),shaftRadius*sin(angle-halfAngle),shaftLength);
		vertices[i*4+3] = Vertex3DMake(shaftRadius*cos(angle),shaftRadius*sin(angle),shaftLength);
		
		vertices[i*4+4] = Vertex3DMake(shaftRadius*cos(angle-halfAngle),shaftRadius*sin(angle-halfAngle),0.0f);
		vertices[i*4+5] = Vertex3DMake(shaftRadius*cos(angle),shaftRadius*sin(angle),0.0f);
	}
	
	
	// Shaft Elements:
	for (int i=0; i<sideCount; i++) {
		elements[i*10] = 0;			//1
		elements[i*10+1] = i*4+2;	//2
		elements[i*10+2] = i*4+3;	//3
		elements[i*10+3] = i*4+4;	//6
		elements[i*10+4] = i*4+5;	//7
		elements[i*10+5] = 1;		//5
		elements[i*10+6] = i*4+5;	//7
		elements[i*10+8] = i*4+3;	//3
		
		if (i<(sideCount-1)) {
			elements[i*10+7] = (i+1)*4+4;	//8
			elements[i*10+9] = (i+1)*4+2;	//4
		} else {
			elements[i*10+7] = 4;	//8
			elements[i*10+9] = 2;	//4
			elements[i*10+10] = 0;	//1
		}
	}
	
	// Transition:
	int le = (sideCount-1)*10+10;
	int lv = (sideCount-1)*4+5;
	elements[le+1] = 0;
	elements[le+2] = lv+1;
	
	// Pointer Vertices
	float height = shaftLength/fabs(shaftLength);
	vertices[lv+1] = Vertex3DMake(shaftRadius,0.0f,height);
	vertices[lv+2] = Vertex3DMake(0.0f,shaftRadius,height);
	
	vertices[lv+3] = Vertex3DMake(pointerLength,0.0f,height);
	vertices[lv+4] = Vertex3DMake(pointerLength-shaftRadius,shaftRadius,height);
	
	vertices[lv+5] = Vertex3DMake(shaftRadius,0.0f,0.0f);
	vertices[lv+6] = Vertex3DMake(0.0f,shaftRadius,0.0f);
	
	vertices[lv+7] = Vertex3DMake(pointerLength,0.0f,0.0f);
	vertices[lv+8] = Vertex3DMake(pointerLength-shaftRadius,shaftRadius,0.0f);
	
	// Pointer Elements
	elements[le+3] = lv+1;
	elements[le+4] = lv+2;
	elements[le+5] = lv+4;
	elements[le+6] = lv+6;
	elements[le+7] = lv+8;
	elements[le+8] = lv+7;
	elements[le+9] = lv+4;
	elements[le+10] = lv+3;
	elements[le+11] = lv+1;
	elements[le+12] = lv+7;
	elements[le+13] = lv+5;
	elements[le+14] = lv+6;
	elements[le+15] = lv+1;
	elements[le+16] = lv+2;
	
}

@end
