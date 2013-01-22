//
//  PinAndSlotConnectorView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "PinAndSlotConnectorView.h"


@implementation PinAndSlotConnectorView

// Initialize with gear. This is the gear to be drawn by this view.
- (id) initWithConnector:(PinAndSlotConnector*)connector {
	if (self = [super init]) {
		myConnector = connector;
		
		pinPosition = Vector3DMake(0.0f,0.0f,0.0f);
		slotPosition = Vector3DMake(0.0f,0.0f,0.0f);
		length = 0.0f;
		opacity = 1.0f;
		
		connectorModel = (ConnectorModel*)[[ConnectorModel alloc] initWithConnector:myConnector];
	}
	
	return self;
}

// Sets the position in 3D space based on the views visible connections
// NOTE: view connections may differ from the model connections.
- (void) setPositionFromConnections:(id<ComponentView>)top Bottom:(id<ComponentView>)bottom {
	Vector3D distance;
	
	if ([myConnector hasTopComponent]&&[myConnector hasTopComponent]) {
		pinPosition = Vector3DMake([top getPosition].x,[top getPosition].y,([top getPosition].z+[bottom getPosition].z)/2.0);
		slotPosition = [bottom getPosition];
		distance = Vector3DMakeWithStartAndEndPoints([top getPosition],[bottom getPosition]);
		length = Vector3DMagnitude(distance)/2.0f;
	} else {
		pinPosition = Vector3DMake(0.0f,0.0f,0.0f);
		slotPosition = Vector3DMake(0.0f,0.0f,0.0f);
		length = 0.0f;
	}
}

// Protocol Methods:
- (Vector3D) getPosition { return pinPosition; }
- (float) getRotation { return [myConnector getRotation]; }
- (float) getRadius { return [myConnector getRadius]; }
- (float) getOpacity { return opacity; }

- (void) draw {
	glPushMatrix();
	
	[self drawPin];
	[self drawSlot];
	
	glPopMatrix();
}

- (void) drawPin {
	float rotation = [myConnector getPinRotation];
	
	if ([self getOpacity] > 0.0f) {
		glPushMatrix();
		
		glColor4f(1.0f, 1.0f, 1.0f, 0.8f*[self getOpacity]);
		
		glTranslatef(pinPosition.x, pinPosition.y, pinPosition.z);
		glRotatef(rotation,0.0f,0.0f,1.0f);
		glTranslatef([myConnector getPinOffset], 0.0f, 0.0f);
		glScalef(1.0f,1.0f,length);
		
		[connectorModel draw];
		
		glPopMatrix();
	}
}

- (void) drawSlot {}

- (void) updateWithState:(AMState)state Phase:(AMStatePhase)phase {
	switch (state) {
		case STATE_POINTERS:
			opacity = 0.0f;
			break;
		case STATE_GEARS:
			opacity = 1.0f;
			break;
		case STATE_BOX:
			opacity = 0.0f;
			break;
		case STATE_PIN_AND_SLOT:
			opacity = 1.0f;
			break;
		default: //STATE_DEFAULT
			opacity = 1.0f;
			break;
	}
}

@end
