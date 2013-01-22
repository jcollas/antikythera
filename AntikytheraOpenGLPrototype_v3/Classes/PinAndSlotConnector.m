//
//  PinAndSlotConnector.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "PinAndSlotConnector.h"


@implementation PinAndSlotConnector

// Initialize with a certain radius, along with pin and slot info
- (id) initWithRadius:(float)Radius ArborOffset:(float)aOffset PinOffset:(float)pOffset {
	if (self = [super initWithRadius:Radius]) {
		arborOffset = aOffset;
		pinOffset = pOffset;
	}
	
	return self;
}

- (float) getPinOffset { return pinOffset; }
- (float) getSlotOffset { return pinOffset; }
- (float) getPinRotation { return rotation; }
- (float) getSlotRotation { return [bottomComponent getRotation]; }

- (void) updateBottomComponentRotation:(float)arcAngle {
	float angle,sign,oldRot,newRot;
	
	Vector3D oldPinPosition,newPinPosition,arbor;
	
	if ([self hasBottomComponent]) {
//		if (arcAngle == 0.0f) { [bottomComponent updateRotation:arcAngle FromSource:self]; }
		
		oldRot = DEGREES_TO_RADIANS(rotation-arcAngle);
		newRot = DEGREES_TO_RADIANS(rotation);
		
		oldPinPosition = Vector3DMake(pinOffset*cosf(oldRot),pinOffset*sinf(oldRot),0.0f);
		newPinPosition = Vector3DMake(pinOffset*cosf(newRot),pinOffset*sinf(newRot),0.0f);
		
		arbor = Vector3DMake(arborOffset,0.0f,0.0f);
		
		oldPinPosition = Vector3DMakeWithStartAndEndPoints(arbor,oldPinPosition);
		newPinPosition = Vector3DMakeWithStartAndEndPoints(arbor,newPinPosition);
		
		Vector3DNormalize(&oldPinPosition);
		Vector3DNormalize(&newPinPosition);
		
		sign = (arcAngle/fabs(arcAngle));
		
		angle = sign*acosf(oldPinPosition.x*newPinPosition.x + oldPinPosition.y*newPinPosition.y);
		
		[bottomComponent updateRotation:RADIANS_TO_DEGREES(angle) FromSource:self];
	}
}

@end
