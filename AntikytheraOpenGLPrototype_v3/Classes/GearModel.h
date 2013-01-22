//
//  GearModel.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLModel3D.h"
#import "Gear.h"


@interface GearModel : GLModel3D {

}

- (id) initWithGear:(Gear*)gear;

- (void) buildModelFromGear:(Gear*)gear;

@end
