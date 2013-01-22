//
//  GearShaderModel.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLModel3D.h"
#import "Gear.h"


@interface GearShaderModel : GLModel3D {

}

- (id) initWithGear:(Gear*)gear;

- (void) buildModelFromGear:(Gear*)gear;

@end
