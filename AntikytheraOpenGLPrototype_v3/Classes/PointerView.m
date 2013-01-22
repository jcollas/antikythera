//
//  PointerView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "PointerView.h"


@implementation PointerView

// Initialize with gear. This is the gear to be drawn by this view.
- (id) initWithComponent:(id<DeviceComponent>)component ShaftLength:(float)sLen ShaftRadius:(float)sRad PointerLength:(float)pLen PointerWidth:(float)pWidth {
	if (self = [super init]) {
		myComponent = component;
		
		position = Vector3DMake(0.0f,0.0f,0.0f);
		opacity = 1.0f;
		depthTest = NO;
		
		pointerModel = (PointerModel*)[[PointerModel alloc] initWithShaftLength:sLen ShaftRadius:sRad PointerLength:pLen PointerWidth:pWidth];
	}
	
	return self;
}

// Set position in 3D space
- (void) setPosition:(Vector3D)pos { position = pos; }
- (void) setPositionRelativeTo:(id<ComponentView>)component VerticalOffset:(float)vOffset {
	Vector3D v = [component getPosition];
	
	position.x = v.x;
	position.y = v.y;
	position.z = v.z + vOffset;
}

// Protocol Methods:
- (Vector3D) getPosition { return position; }
- (float) getRotation { return [myComponent getRotation]; }
- (float) getRadius { return pointerModel.pointerLength; }
- (float) getOpacity { return opacity; }

- (void) draw {
	float rotation;
	
	if ([self getOpacity] > 0.0f) {
		glPushMatrix();
		
		if (!depthTest) {
			glTranslatef(position.x, position.y, position.z);
		} else {
			glTranslatef(position.x, position.y, position.z/2);
		}
		rotation = [myComponent getRotation];
		glRotatef(rotation,0.0f,0.0f,1.0f);
		
		if (depthTest) glEnable(GL_DEPTH_TEST);
		
		glPushMatrix();
		glScalef(1.0f, 1.0f, 1.0f);
		glColor4f(1.0f, 1.0f, 1.0f, 0.5f*[self getOpacity]);
		[pointerModel draw];
		glPopMatrix();
		
		if (depthTest) glDisable(GL_DEPTH_TEST);
		
		glPopMatrix();
	}
}

- (void) updateWithState:(AMState)state Phase:(AMStatePhase)phase {
	switch (state) {
		case STATE_POINTERS:
			opacity = 1.0f;
			depthTest = NO;
			break;
		case STATE_GEARS:
			opacity = 0.2f;
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
			opacity = 1.0f;
			depthTest = NO;
			break;
	}
}

@end
