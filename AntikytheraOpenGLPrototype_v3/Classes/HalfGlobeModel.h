//
//  HalfGlobeModel.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLModel3D.h"

@interface HalfGlobeModel : GLModel3D {

}

- (id) initWidthRadius:(float)radius;

- (void) buildModelWithRadius:(float)radius;

@end
