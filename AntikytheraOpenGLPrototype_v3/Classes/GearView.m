//
//  GearView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GearView.h"


@implementation GearView

// Initialize with gear. This is the gear to be drawn by this view.
- (id) initWithGear:(Gear*)gear {
	if (self = [super init]) {
		myGear = gear;
		
		position = Vector3DMake(0.0f,0.0f,0.0f);
		opacity = 1.0f;
		isPinAndSlotGear = NO;
		isPointerActive = NO;
		
		gearModel = [[GearModel alloc] initWithGear:myGear];
		gearShaderModel = [[GearShaderModel alloc] initWithGear:myGear];
		pointerModel = [[BoxModel alloc] initWithWidth:1.0f Height:100.0f Length:1.0f];
	}
	
	return self;
}

// Set position in 3D space
- (void) setPosition:(Vector3D)pos { position = pos; }
- (void) setPositionRelativeTo:(id<ComponentView>)component AtAngle:(float)angle {
	float distance = [self getRadius] + [component getRadius];
	Vector3D v = [component getPosition];
	
	position.x = v.x + distance*cos(angle);
	position.y = v.y + distance*sin(angle);
	position.z = v.z;
}
- (void) setPositionRelativeTo:(id<ComponentView>)component VerticalOffset:(float)vOffset {
	Vector3D v = [component getPosition];
	
	position.x = v.x;
	position.y = v.y;
	position.z = v.z + vOffset;
}

- (void) setAsPinAndSlotGear:(BOOL)flag { isPinAndSlotGear = flag; }

// Protocol Methods:
- (Vector3D) getPosition { return position; }
- (float) getRotation { return [myGear getRotation]; }
- (float) getRadius { return [myGear getRadius]; }
- (float) getOpacity { return opacity; }

- (void) draw {
	if ([self getOpacity] > 0.0f) {
		glPushMatrix();
		
		glTranslatef(position.x, position.y, position.z);
		glRotatef([myGear getRotation],0.0f,0.0f,1.0f);
		
		glPushMatrix();
		glScalef(1.0f, 1.0f, 0.5f);
		glColor4f(1.0f, 1.0f, 1.0f, 0.2f*[self getOpacity]);
		[gearModel draw];
		glPopMatrix();
		
		glPushMatrix();
		glScalef(1.0f, 1.0f, 0.6f);
		glColor4f(1.0f, 0.0f, 0.0f, 0.3f*[self getOpacity]);
		[gearShaderModel draw];
		glPopMatrix();
		
		if (isPointerActive) {
			glPushMatrix();
			glTranslatef(50.0f, 0.0f, 0.0f);
			glScalef(1.0f, 1.0f, 0.6f);
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
			[pointerModel draw];
			glPopMatrix();
		}
		
		glPopMatrix();
	}
}

- (void) updateWithState:(AMState)state Phase:(AMStatePhase)phase {
	switch (state) {
		case STATE_POINTERS:
			opacity = 0.2f;
			isPointerActive = NO;
			break;
		case STATE_GEARS:
			opacity = 1.0f;
			isPointerActive = NO;
			break;
		case STATE_BOX:
			opacity = 0.0f;
			isPointerActive = NO;
			break;
		case STATE_PIN_AND_SLOT:
			if (isPinAndSlotGear) {
				opacity = 1.0f;
				isPointerActive = YES;
			} else {
				opacity = 0.0f;
				isPointerActive = NO;
			}
			break;
		default: //STATE_DEFAULT
			opacity = 1.0f;
			isPointerActive = NO;
			break;
	}
}

@end
