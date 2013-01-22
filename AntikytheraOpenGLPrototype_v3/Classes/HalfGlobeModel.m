//
//  HalfGlobeModel.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HalfGlobeModel.h"


@implementation HalfGlobeModel

- (id) initWidthRadius:(float)radius {
	if (self = [super init]) {
		[self buildModelWithRadius:radius];
	}
	
	return self;
}

- (void) buildModelWithRadius:(float)radius {
	float phiStep,thetaStep,phiAngle,thetaAngle,vx,vy,vz;
	const int lonSideCount = 8;
	const int latSideCount = 8;
	
	phiStep = (M_PI*7/6)/lonSideCount;
	thetaStep = (M_PI*7/6)/latSideCount;
	
	vertexCount = latSideCount*(lonSideCount-1) + 2;
	vertices = (Vertex3D*)malloc(vertexCount*sizeof(Vertex3D));
	elementCount = (latSideCount*2+2)*lonSideCount;
	elements = (GLushort*)malloc(elementCount*sizeof(GLushort));
	
	
	// Shaft Vertices:
	vertices[0] = Vertex3DMake(0.0f,0.0f,radius);
	
	for (int i=1; i<(lonSideCount); i++) {
		phiAngle = i*phiStep;
		for (int n=0; n<latSideCount; n++) {
			thetaAngle = n*thetaStep;
			
			vx = radius*cos(thetaAngle)*sin(phiAngle);
			vy = radius*sin(thetaAngle)*sin(phiAngle);
			vz = radius*cos(phiAngle);
			
			vertices[(i-1)*latSideCount+n+1] = Vertex3DMake(vx,vy,vz);
		}
	}
	
	vertices[vertexCount-1] = Vertex3DMake(0.0f,0.0f,-radius);
	
	// Shaft Elements:
	int eCount,topStart,bottomStart;
	
	// North Pole
	eCount = 0;
	for (int i=0; i<latSideCount; i++) {
		elements[eCount] = 0;
		elements[eCount+1] = i+1;
		eCount += 2;
	}
	elements[eCount] = 0;
	elements[eCount+1] = 1;
	eCount += 2;
	
	// Body
	for (int n=0; n<(lonSideCount-2); n++) {
		topStart = latSideCount*n+1;
		bottomStart = latSideCount*(n+1)+1;
		
		for (int i=0; i<latSideCount; i++) {
			elements[eCount] = topStart+i;
			elements[eCount+1] = bottomStart+i;
			eCount += 2;
		}
		
		elements[eCount] = topStart;
		elements[eCount+1] = bottomStart;
		eCount += 2;
	}
	
	// South Pole
	topStart = latSideCount*(lonSideCount-2)+1;
	for (int i=0; i<latSideCount; i++) {
		elements[eCount] = topStart+i;
		elements[eCount+1] = vertexCount-1;
		eCount += 2;
	}
	elements[eCount] = topStart;
	elements[eCount+1] = vertexCount-1;
	eCount += 2;
	
}

@end
