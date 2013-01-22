//
//  UserDialView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserDialView.h"


@implementation UserDialView

- (id) initWithRadius:(float)rad Mechanism:(AntikytheraMechanism*)mechanism View:(UIView*)view {
	if (self=[super init]) {
		position = Vertex3DMake(0.0f, 0.0f, 0.0f);
		rotation = 0;
		radius = rad;
		color = Color3DMake(1.0f, 1.0f, 1.0f, 1.0f);
		
		myView = view;
		myMechanism = mechanism;
		
		boxModel = [[BoxModel alloc] initWithWidth:rad*0.1f Height:rad*0.75f Length:0.5f];
	}
	
	return self;
}

- (void) setPosition:(Vector3D)pos { position = pos; }
- (void) setOpacity:(float)opac { color.alpha = opac; }
- (void) setColor:(Color3D)col { color = col; }

- (BOOL) hitTest:(Vector3D)hit {
	float outerRadius,innerRadius,distance;
	
	outerRadius = radius*1.75f;
	innerRadius = radius*0.75f;
	distance = hypotf(hit.x-position.x,hit.y-position.y);
	
	if ((distance <= outerRadius)&&(distance >= innerRadius)) {
		return YES;
	} else {
		return NO;
	}
}

- (void) draw {
	float angle,angleInc;
	int sides = 32;
	
	angleInc = 360.0f/((float)sides);
	
	glPushMatrix();
	
	glTranslatef(position.x, position.y, position.z);
	glRotatef(rotation, 0.0f, 0.0f, 1.0f);
	
	for (int i=0; i<sides; i++) {
		angle = i*angleInc;
		
		glPushMatrix();
		glTranslatef(radius*cosf(DEGREES_TO_RADIANS(angle)), radius*sinf(DEGREES_TO_RADIANS(angle)), 0.0f);
		glRotatef(angle, 0.0f, 0.0f, 1.0f);
		glColor4f(color.red, color.green, color.blue, color.alpha);
		[boxModel draw];
		glPopMatrix();
	}
	
	glPopMatrix();
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event touchesForView:myView];
	NSEnumerator *enumerator = [allTouches objectEnumerator];
	UITouch *touch = (UITouch*)[enumerator nextObject];
	CGPoint location = [touch locationInView:myView];
	lastPosition = Vertex3DMake(location.x, myView.bounds.size.height-location.y, 0.0f);
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event touchesForView:myView];
	NSEnumerator *enumerator = [allTouches objectEnumerator];
	UITouch *touch = (UITouch*)[enumerator nextObject];
	CGPoint location = [touch locationInView:myView];
	Vector3D newPosition = Vector3DMake(location.x, myView.bounds.size.height-location.y, 0.0f);
	
	Vector3D norm1 = Vector3DMakeWithStartAndEndPoints(position,lastPosition);
	Vector3D norm2 = Vector3DMakeWithStartAndEndPoints(position,newPosition);
	
	Vector3DNormalize(&norm1);
	Vector3DNormalize(&norm2);
	
	float angle = atan2f(norm2.y,norm2.x) - atan2f(norm1.y,norm1.x);
	
	if (fabs(angle) >= M_PI) {
		if (angle > 0) {
			angle -= 2.0f*M_PI;
		} else {
			angle += 2.0f*M_PI;
		}
	}
	
	angle = RADIANS_TO_DEGREES(angle);
	if (angle != 0.0f) {
		rotation += angle; NSLog(@"%f",angle);
		[myMechanism rotate:angle];
		
		lastPosition = newPosition;
	}
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {}

@end
