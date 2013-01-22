//
//  ComponentView.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelView.h"
#import "OpenGLCommon.h"


@protocol ComponentView <ModelView>

- (Vector3D) getPosition;
- (float) getRotation;
- (float) getRadius;
- (float) getOpacity;

@end
