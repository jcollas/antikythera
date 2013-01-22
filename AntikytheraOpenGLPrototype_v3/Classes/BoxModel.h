//
//  BoxModel.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLModel3D.h"


@interface BoxModel : GLModel3D {
	float width,height,length;
}

@property (nonatomic,readonly) float width,height,length;

- (id) initWithWidth:(float)w Height:(float)h Length:(float)len;

- (void) buildModelWithWidth:(float)w Height:(float)h Length:(float)len;

@end
