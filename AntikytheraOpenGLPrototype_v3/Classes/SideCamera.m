//
//  SideCamera.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SideCamera.h"


@implementation SideCamera

- (void) updateViewpoint {
	glLoadIdentity();
	
	glTranslatef(0.0f,0.0f,0);
	glRotatef(-90, 1.0, 0.0, 0.0);
	glTranslatef(0.0f,150.0f,40.0f);
	
	glClearColor(0.0, 0.0, 0.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

@end
