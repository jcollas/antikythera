//
//  LunarPointerView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LunarPointerView.h"

@implementation LunarPointerView

- (id) initWithComponent:(id<DeviceComponent>)component YearPointer:(PointerView*)pointer ShaftLength:(float)sLen ShaftRadius:(float)sRad PointerLength:(float)pLen PointerWidth:(float)pWidth {
	if (self=[super initWithComponent:component ShaftLength:sLen ShaftRadius:sRad PointerLength:pLen PointerWidth:pWidth]) {
		yearPointer = pointer;
		moonRotation = 0;
		
		brightMoonModel = [[HalfGlobeModel alloc] initWidthRadius:2.5f];
		darkMoonModel = [[HalfGlobeModel alloc] initWidthRadius:2.5f];
	}
	
	return self;
}

- (void) draw {
	float rotDiff,r1,r2;
	
	[super draw];
	
	r1 = [self normalizeRotation:[self getRotation]];
	r2 = [self normalizeRotation:[yearPointer getRotation]];
	rotDiff = r2 - r1;
	
	moonRotation = rotDiff+90; //RADIANS_TO_DEGREES(cosf(DEGREES_TO_RADIANS(rotDiff)));
	
	glPushMatrix();
	
	if (!depthTest) {
		glTranslatef(position.x, position.y, position.z);
	} else {
		glTranslatef(position.x, position.y, position.z/2);
	}
	glRotatef([myComponent getRotation],0.0f,0.0f,1.0f);
	glTranslatef([self getRadius]*2/3, 0.0f, 0.0f);
	
	glEnable(GL_DEPTH_TEST);
	
	glPushMatrix();
	glRotatef(moonRotation+180, 1.0f, 0.0f, 0.0f);
	glTranslatef(0.0f, 0.1f, 0.0f);
	glScalef(1.0f, 1.0f, 1.0f);
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f*[self getOpacity]);
	[brightMoonModel draw];
	glPopMatrix();
	
	glPushMatrix();
	glRotatef(moonRotation, 1.0f, 0.0f, 0.0f);
	glTranslatef(0.0f, 0.1f, 0.0f);
	glColor4f(0.5f, 0.2f, 0.2f, 1.0f*[self getOpacity]);
	[darkMoonModel draw];
	glPopMatrix();
	
	glDisable(GL_DEPTH_TEST);
	
	glPopMatrix();
}

- (float) normalizeRotation:(float)rotation {
	float mult;
	
	mult = rotation/360;
	if (mult >= 1) {
		mult = floorf(mult);
		rotation = rotation - mult*360;
	}
	
	return rotation;
}

@end
