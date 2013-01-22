//
//  ConnectorView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ConnectorView.h"


@implementation ConnectorView

// Initialize with gear. This is the gear to be drawn by this view.
- (id) initWithConnector:(Connector*)connector {
	if (self = [super init]) {
		myConnector = connector;
		
		position = Vector3DMake(0.0f,0.0f,0.0f);
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
		position = Vector3DAdd([top getPosition],[bottom getPosition]);
		position = Vector3DMake(position.x/2.0,position.y/2.0,position.z/2.0);
		distance = Vector3DMakeWithStartAndEndPoints([top getPosition],[bottom getPosition]);
		length = Vector3DMagnitude(distance)/2.0;
	} else {
		position = Vector3DMake(0.0f,0.0f,0.0f);
		length = 0.0f;
	}
}

// Protocol Methods:
- (Vector3D) getPosition { return position; }
- (float) getRotation { return [myConnector getRotation]; }
- (float) getRadius { return [myConnector getRadius]; }
- (float) getOpacity { return opacity; }

- (void) draw {
	float rotation;
	
	if ([self getOpacity] > 0.0f) {
		glPushMatrix();
		
		glColor4f(1.0f, 1.0f, 1.0f, 0.5f*[self getOpacity]);
		
		glTranslatef(position.x, position.y, position.z);
		rotation = [myConnector getRotation];
		glRotatef(rotation,0.0f,0.0f,1.0f);
		glScalef(1.0f,1.0f,length);
		
		[connectorModel draw];
		
		glPopMatrix();
	}
}

- (void) updateWithState:(AMState)state Phase:(AMStatePhase)phase {
	switch (state) {
		case STATE_POINTERS:
			opacity = 0.2f;
			break;
		case STATE_GEARS:
			opacity = 1.0f;
			break;
		case STATE_BOX:
			opacity = 0.0f;
			break;
		case STATE_PIN_AND_SLOT:
			opacity = 0.0f;
			break;
		default: //STATE_DEFAULT
			opacity = 1.0f;
			break;
	}
}

@end
