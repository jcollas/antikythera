//
//  ShowcaseCamera.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ShowcaseCamera.h"


@implementation ShowcaseCamera

- (void) updateViewpoint {
	static GLfloat rot = 0.0;
	
	glLoadIdentity();
	
	glTranslatef(0.0f,0.0f,0);
	glRotatef(-90, 1.0, 0.0, 0.0);
	glTranslatef(0.0f,100.0f,40.0f);
	
	glRotatef(45*sin(rot/200), 1.0, 0.0, 0.0);
	glRotatef(-rot, 0.0, 0.0, 1.0);
	
	glClearColor(0.0, 0.0, 0.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	static NSTimeInterval lastDrawTime;
    if (lastDrawTime)
    {
        NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
		rot+=5 * timeSinceLastDraw;
		//		NSLog(@"%f",timeSinceLastDraw);
	}
    lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
}

@end
