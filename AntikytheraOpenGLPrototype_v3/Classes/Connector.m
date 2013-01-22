//
//  Connector.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Connector.h"


@implementation Connector

// Initialize with a certain radius
- (id) initWithRadius:(float)Radius {
	if (self = [super init]) {
		radius = Radius;
		rotation = 0;
		
		topComponent = nil;
		bottomComponent = nil;
	}
	
	return self;
}

// Tests for connection existence
- (BOOL) hasTopComponent { return (topComponent != nil); }
- (BOOL) hasBottomComponent { return (bottomComponent != nil); }

// Convenience method for setting connections easily
- (void) setConnections:(id<DeviceComponent>)top Bottom:(id<DeviceComponent>)bottom {
	topComponent = top;
	bottomComponent = bottom;
}

// Protocol Methods:
- (float) getRotation { return rotation; }
- (float) getRadius { return radius; }
- (void) rotate:(float)arcAngle {
	rotation += arcAngle;
	
	[self updateTopComponentRotation:arcAngle];
	[self updateBottomComponentRotation:arcAngle];
}
- (void) updateRotation:(float)arcAngle FromSource:(id<DeviceComponent>)source {
	rotation += arcAngle;
	
	if (source != topComponent)
		[self updateTopComponentRotation:arcAngle];
	
	if (source != bottomComponent)
		[self updateBottomComponentRotation:arcAngle];
}

// Updates connection rotations, if they exist
- (void) updateTopComponentRotation:(float)arcAngle {
	if ([self hasTopComponent])
		[topComponent updateRotation:arcAngle FromSource:self];
}

- (void) updateBottomComponentRotation:(float)arcAngle {
	if ([self hasBottomComponent])
		[bottomComponent updateRotation:arcAngle FromSource:self];
}

@end
