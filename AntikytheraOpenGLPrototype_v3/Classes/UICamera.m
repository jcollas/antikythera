//
//  UICamera.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UICamera.h"

#define kMIN_ZOOM 20
#define kMAX_ZOOM 600

@implementation UICamera

- (id) initWithView:(UIView*)view {
	if (self=[super init]) {
		phiStart = -30.0f;
		phiAngle = 0;
		thetaStart = 30.0f;
		thetaAngle = 0;
		
		center = Vertex3DMake(0.0f, 0.0f, 0.0f);
		panDiff = Vertex3DMake(0.0f, 0.0f, 0.0f);
		
		startDist = 200.0f;
		distance = 0;
		
		currentGesture = NONE;
		
		myView = view;
	}
	
	return self;
}

- (void) updateViewpoint {
	glRotatef(-90, 1.0, 0.0, 0.0);
	glTranslatef(center.x+panDiff.x,center.y+panDiff.y,center.z+panDiff.z);
	glTranslatef(0.0f,(startDist+distance),0.0f);
	
	glRotatef(-(phiStart+phiAngle), 1.0, 0.0, 0.0);
	glRotatef(-(thetaStart+thetaAngle), 0.0, 0.0, 1.0);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event touchesForView:myView];
//	NSLog(@"touchesBegan: Touches=%d TouchesForView=%d",[touches count],[allTouches count]);
	
	[self saveViewChanges];
	
	if ([allTouches count] == 1) { currentGesture = SINGLE;
		NSEnumerator *enumerator = [allTouches objectEnumerator];
		UITouch *touch = (UITouch*)[enumerator nextObject];
		gestureStartPoint = [touch locationInView:myView];
	} else if ([allTouches count] == 2) { currentGesture = DOUBLE;
		NSEnumerator *enumerator = [allTouches objectEnumerator];
		UITouch *touch1 = (UITouch*)[enumerator nextObject];
		UITouch *touch2 = (UITouch*)[enumerator nextObject];
		
		CGPoint p1 = [touch1 locationInView:myView];
		CGPoint p2 = [touch2 locationInView:myView];
		
		gestureStartDistance = sqrtf((p2.x-p1.x)*(p2.x-p1.x)+(p2.y-p1.y)*(p2.y-p1.y));
		
		gestureStartPoint.x = (p1.x+p2.x)/2;
		gestureStartPoint.y = (p1.y+p2.y)/2;
	} else { currentGesture = NONE; }

}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event touchesForView:myView];
//	NSLog(@"touchesMoved: Touches=%d TouchesForView=%d",[touches count],[allTouches count]);
	
	if (([allTouches count] == 1)) {
		NSEnumerator *enumerator = [allTouches objectEnumerator];
		UITouch *touch = (UITouch*)[enumerator nextObject];
		CGPoint currentPosition = [touch locationInView:myView];
		
		CGFloat deltaX = (gestureStartPoint.x - currentPosition.x)/2;
		CGFloat deltaY = (gestureStartPoint.y - currentPosition.y)/2;
		if ((fabsf(phiAngle-deltaY) < 100)&&(fabsf(thetaAngle-deltaX) < 100)) {
			phiAngle = deltaY;
			thetaAngle = deltaX;
		}
	} else if (([allTouches count] == 2)) {
		NSEnumerator *enumerator = [allTouches objectEnumerator];
		UITouch *touch1 = (UITouch*)[enumerator nextObject];
		UITouch *touch2 = (UITouch*)[enumerator nextObject];
		
		CGPoint p1 = [touch1 locationInView:myView];
		CGPoint p2 = [touch2 locationInView:myView];
		
		CGFloat delta = hypotf((p2.x-p1.x),(p2.y-p1.y));
		CGPoint deltaPos = CGPointMake(gestureStartPoint.x - (p1.x+p2.x)/2,gestureStartPoint.y - (p1.y+p2.y)/2);
		
		panDiff = Vertex3DMake(-deltaPos.x/5, 0.0f, deltaPos.y/5);
		
		distance = (gestureStartDistance - delta);
		if ((startDist+distance) < kMIN_ZOOM) {
			distance = kMIN_ZOOM - startDist;
		} else if ((startDist+distance) > kMAX_ZOOM) {
			distance = kMAX_ZOOM - startDist;
		}
		
		
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event touchesForView:myView];
	NSLog(@"touchesEnded: Touches=%lu TouchesForView=%lu",(unsigned long)[touches count],(unsigned long)[allTouches count]);
	int activeTouches = [allTouches count] - [touches count];
	
	[self saveViewChanges];
	
	if (activeTouches == 1) {
		currentGesture = SINGLE;
		NSEnumerator *enumerator = [allTouches objectEnumerator];
		UITouch *touch = (UITouch*)[enumerator nextObject];
		gestureStartPoint = [touch locationInView:myView];
	} else if (activeTouches == 0) {
		currentGesture = NONE;
	}
}

- (void) saveViewChanges {
	phiStart += phiAngle;
	thetaStart += thetaAngle;
	phiAngle = thetaAngle = 0;
	
	startDist += distance;
	distance = 0;
	
	center.x += panDiff.x;
	center.z += panDiff.z;
	panDiff = Vertex3DMake(0.0f, 0.0f, 0.0f);
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {}

@end
