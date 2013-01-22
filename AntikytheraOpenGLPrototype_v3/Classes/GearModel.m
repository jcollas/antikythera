//
//  GearModel.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GearModel.h"


@implementation GearModel

- (id) initWithGear:(Gear*)gear {
	if (self = [super init]) {
		[self buildModelFromGear:gear];
	}
	
	return self;
}

- (void) buildModelFromGear:(Gear*)gear {
	float sliceAngle,halfAngle,angle,radius,toothRadius;
	int toothCount;
	const float toothSize = 0.8f;
	
	toothCount = [gear getToothCount];
	radius = [gear getRadius] - toothSize/2.0f;
	toothRadius = radius + toothSize;
	
	sliceAngle = (2.0f*M_PI)/toothCount;
	halfAngle = sliceAngle/2.0f;
	
	vertexCount = (toothCount*4+2);
	vertices = (Vertex3D*)malloc(vertexCount*sizeof(Vertex3D));
	elementCount = (toothCount*10+1);
	elements = (GLushort*)malloc(elementCount*sizeof(GLushort));
	
	
	// Vertices:
	vertices[0] = Vertex3DMake(0.0f,0.0f,1.0f);
	vertices[1] = Vertex3DMake(0.0f,0.0f,-1.0f);
	
	for (int i=0; i<toothCount; i++) {
		angle = i*sliceAngle;
		
		vertices[i*4+2] = Vertex3DMake(radius*cos(angle-halfAngle),radius*sin(angle-halfAngle),1.0f);
		vertices[i*4+3] = Vertex3DMake(toothRadius*cos(angle),toothRadius*sin(angle),1.0f);
		
		vertices[i*4+4] = Vertex3DMake(radius*cos(angle-halfAngle),radius*sin(angle-halfAngle),-1.0f);
		vertices[i*4+5] = Vertex3DMake(toothRadius*cos(angle),toothRadius*sin(angle),-1.0f);
	}
	
	
	// Elements:
	for (int i=0; i<toothCount; i++) {
		elements[i*10] = 0;			//1
		elements[i*10+1] = i*4+2;	//2
		elements[i*10+2] = i*4+3;	//3
		elements[i*10+3] = i*4+4;	//6
		elements[i*10+4] = i*4+5;	//7
		elements[i*10+5] = 1;		//5
		elements[i*10+6] = i*4+5;	//7
		elements[i*10+8] = i*4+3;	//3
		
		if (i<(toothCount-1)) {
			elements[i*10+7] = (i+1)*4+4;	//8
			elements[i*10+9] = (i+1)*4+2;	//4
		} else {
			elements[i*10+7] = 4;	//8
			elements[i*10+9] = 2;	//4
			elements[i*10+10] = 0;	//1
		}
	}
}

@end
