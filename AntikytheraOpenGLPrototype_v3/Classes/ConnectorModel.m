//
//  ConnectorModel.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ConnectorModel.h"


@implementation ConnectorModel

- (id) initWithConnector:(Connector*)connector {
	if (self = [super init]) {
		[self buildModelFromConnector:connector];
	}
	
	return self;
}

- (void) buildModelFromConnector:(Connector*)connector {
	float sliceAngle,halfAngle,angle,radius;
	const int sideCount = 16;
	
	radius = [connector getRadius];
	
	sliceAngle = (2.0f*M_PI)/sideCount;
	halfAngle = sliceAngle/2.0f;
	
	vertexCount = (sideCount*4+2);
	vertices = (Vertex3D*)malloc(vertexCount*sizeof(Vertex3D));
	elementCount = (sideCount*10+1);
	elements = (GLushort*)malloc(elementCount*sizeof(GLushort));
	
	
	// Vertices:
	vertices[0] = Vertex3DMake(0.0f,0.0f,1.0f);
	vertices[1] = Vertex3DMake(0.0f,0.0f,-1.0f);
	
	for (int i=0; i<sideCount; i++) {
		angle = i*sliceAngle;
		
		vertices[i*4+2] = Vertex3DMake(radius*cos(angle-halfAngle),radius*sin(angle-halfAngle),1.0f);
		vertices[i*4+3] = Vertex3DMake(radius*cos(angle),radius*sin(angle),1.0f);
		
		vertices[i*4+4] = Vertex3DMake(radius*cos(angle-halfAngle),radius*sin(angle-halfAngle),-1.0f);
		vertices[i*4+5] = Vertex3DMake(radius*cos(angle),radius*sin(angle),-1.0f);
	}
	
	
	// Elements:
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
}

@end
