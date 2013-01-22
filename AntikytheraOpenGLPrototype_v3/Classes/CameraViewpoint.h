//
//  ViewPerspective.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 3/20/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLCommon.h"

@protocol CameraViewpoint <NSObject>

- (void) updateViewpoint;

@end
