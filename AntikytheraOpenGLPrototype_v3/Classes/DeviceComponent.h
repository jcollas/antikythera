//
//  DeviceComponent.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DeviceComponent <NSObject>

- (float) getRotation;
- (float) getRadius;

- (void) rotate:(float)arcAngle;
- (void) updateRotation:(float)arcAngle FromSource:(id<DeviceComponent>)source;

@end
