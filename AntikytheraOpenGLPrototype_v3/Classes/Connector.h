//
//  Connector.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceComponent.h"


@interface Connector : NSObject <DeviceComponent> {
	float radius;
	float rotation;
	
	id<DeviceComponent> topComponent,bottomComponent;
}

- (id) initWithRadius:(float)Radius;

- (void) setConnections:(id<DeviceComponent>)top Bottom:(id<DeviceComponent>)bottom;
- (BOOL) hasTopComponent;
- (BOOL) hasBottomComponent;
- (void) updateTopComponentRotation:(float)arcAngle;
- (void) updateBottomComponentRotation:(float)arcAngle;

@end
