//
//  Gear.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceComponent.h"


@interface Gear : NSObject <DeviceComponent> {
	float radius;
	float rotation;
	int toothCount;
	
	NSMutableArray *neighbors;
}

- (id) initWithToothCount:(int)teeth;
- (id) initWithToothCount:(int)teeth RadiusScale:(float)scale;

- (int) getToothCount;

- (void) addNeighbor:(id<DeviceComponent>)neighbor;
- (void) updateNeighborRotations:(float)arcAngle Except:(id<DeviceComponent>)source;

@end
