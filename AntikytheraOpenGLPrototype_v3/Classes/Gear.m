//
//  Gear.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Gear.h"


@implementation Gear

// Initialize with a specific tooth count. Radius is calculated from tooth count.
- (id) initWithToothCount:(int)teeth {
	if (self = [super init]) {
		toothCount = teeth;
		radius = ((float)teeth)/(2.0f*M_PI);
		rotation = 0.0f;
		
		neighbors = [[NSMutableArray alloc] init];
	}
	
	return self;
}
- (id) initWithToothCount:(int)teeth RadiusScale:(float)scale {
	if (self = [super init]) {
		toothCount = teeth;
		radius = (((float)teeth)/(2.0f*M_PI))*scale;
		rotation = 0.0f;
		
		neighbors = [[NSMutableArray alloc] init];
	}
	
	return self;
}

// Get tooth count
- (int) getToothCount { return toothCount; }

// Add neighbor component to list of neighbors
- (void) addNeighbor:(id<DeviceComponent>)neighbor {
	[neighbors addObject:neighbor];
}

// Protocol Methods:
- (float) getRotation { return rotation; }
- (float) getRadius { return radius; }
- (void) rotate:(float)arcAngle{
	rotation += arcAngle;
	[self updateNeighborRotations:arcAngle Except:nil];
}
- (void) updateRotation:(float)arcAngle FromSource:(id<DeviceComponent>)source {
	float ratio;
	
	if ([source isKindOfClass:[Gear class]]) {
		// inverse ratio because it is initially relative to other gear
		ratio = [source getRadius]/radius;
		arcAngle = -1.0f*arcAngle*ratio;
	}
	
	rotation += arcAngle;
	[self updateNeighborRotations:arcAngle Except:source];
}

// Update neighbor rotations
- (void) updateNeighborRotations:(float)arcAngle Except:(id<DeviceComponent>)source {
	NSEnumerator *enumerator = [neighbors objectEnumerator];
    id<DeviceComponent> component;
	
    while ((component = [enumerator nextObject]) != nil) {
		if (component != source)
			[component updateRotation:arcAngle FromSource:self];
    }
}

@end
