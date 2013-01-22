//
//  DeviceView.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelView.h"
#import "OpenGLCommon.h"

@protocol DeviceView <ModelView>

- (void) buildDeviceView;

@end
