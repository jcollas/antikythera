//
//  BoxView.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComponentView.h"
#import "BoxModel.h"
#import "AMViewStateHandler.h"


@interface BoxView : NSObject <ComponentView,AMViewStateHandler> {
	Vector3D position;
	float rotation;
	float opacity;
	BOOL depthTest;
	
	BoxModel *boxModel;
}

- (id) initWithWidth:(float)width Height:(float)height Length:(float)length;

- (void) setPosition:(Vector3D)pos;
- (void) setRotation:(float)rot;

@end
