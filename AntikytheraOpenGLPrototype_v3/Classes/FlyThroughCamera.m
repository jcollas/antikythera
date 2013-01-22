//
//  FlyThroughCamera.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "FlyThroughCamera.h"


@implementation FlyThroughCamera

- (void) updateViewpoint {
	static GLfloat rot = 0.0;
	
	glLoadIdentity();
	
	glTranslatef(0.0f,0.0f,-100.0+50*sin(-rot/100));
	glRotatef(-rot, 1.0, 1.0, 1.0);
	
	glClearColor(0.0, 0.0, 0.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	static NSTimeInterval lastDrawTime;
    if (lastDrawTime)
    {
        NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
		rot+=10 * timeSinceLastDraw;
		//		NSLog(@"%f",timeSinceLastDraw);
	}
    lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
}

@end
