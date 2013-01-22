//
//  BoxView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BoxView.h"


@implementation BoxView

// Initialize with gear. This is the gear to be drawn by this view.
- (id) initWithWidth:(float)width Height:(float)height Length:(float)length {
	if (self = [super init]) {
		position = Vector3DMake(0.0f,0.0f,0.0f);
		opacity = 1.0f;
		rotation = 0.0f;
		depthTest = YES;
		
		boxModel = [[BoxModel alloc] initWithWidth:width Height:height Length:length];
	}
	
	return self;
}

// Set position in 3D space
- (void) setPosition:(Vector3D)pos { position = pos; }
- (void) setRotation:(float)rot { rotation = rot; }

// Protocol Methods:
- (Vector3D) getPosition { return position; }
- (float) getRotation { return rotation; }
- (float) getRadius { return 0.0f; }
- (float) getOpacity { return opacity; }

- (void) draw {
	if ([self getOpacity] > 0.0f) {
		glPushMatrix();
		
		glTranslatef(position.x, position.y, position.z);
		glRotatef(rotation, 0.0f, 0.0f, 1.0f);
		if (!depthTest) glScalef(1.0f, 1.0f, (75.0f/35.0f));
		
		if (depthTest) glEnable(GL_DEPTH_TEST);		
		
		glPushMatrix();
		glColor4f(0.855f/2, 0.573f/2, 0.149f/2, [self getOpacity]);
		[boxModel draw];
		glPopMatrix();
		
		if (depthTest) glDisable(GL_DEPTH_TEST);		
		
		glPopMatrix();
	}
}

- (void) updateWithState:(AMState)state Phase:(AMStatePhase)phase {
	switch (state) {
		case STATE_POINTERS:
			opacity = 0.1f;
			depthTest = NO;
			break;
		case STATE_GEARS:
			opacity = 0.1f;
			depthTest = NO;
			break;
		case STATE_BOX:
			opacity = 1.0f;
			depthTest = YES;
			break;
		case STATE_PIN_AND_SLOT:
			opacity = 0.0f;
			break;
		default: //STATE_DEFAULT
			opacity = 0.15f;
			depthTest = NO;
			break;
	}
}

@end
