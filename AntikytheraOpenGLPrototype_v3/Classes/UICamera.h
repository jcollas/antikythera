//
//  UICamera.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CameraViewpoint.h"
#import "Touchable.h"

typedef enum {
	NONE,
	AMBIGUOUS,
	SINGLE,
	DOUBLE
} GestureType;

@interface UICamera : NSObject <CameraViewpoint,Touchable> {
	UIView *myView;
	
	// Touch-handling 
	float phiStart, thetaStart, phiAngle, thetaAngle;
	float startDist, distance;
	Vertex3D center,panDiff;
	CGPoint gestureStartPoint;
	CGFloat gestureStartDistance;
	GestureType currentGesture;
}

- (id) initWithView:(UIView*)view;

- (void) saveViewChanges;

@end