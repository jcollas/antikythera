//
//  UserDialView.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLCommon.h"
#import "ModelView.h"
#import "BoxModel.h"
#import "Touchable.h"
#import "AntikytheraMechanism.h"


@interface UserDialView : NSObject <ModelView,Touchable> {
	Vertex3D position;
	float radius,rotation;
	Color3D color;
	
	UIView *myView;
	AntikytheraMechanism *myMechanism;
	
	// Touch-handling:
	Vector3D lastPosition;
	
	BoxModel *boxModel;
}

- (id) initWithRadius:(float)rad Mechanism:(AntikytheraMechanism*)mechanism View:(UIView*)view;

- (void) setPosition:(Vector3D)pos;
- (void) setOpacity:(float)opac;
- (void) setColor:(Color3D)col;

- (BOOL) hitTest:(Vector3D)hit;

@end
