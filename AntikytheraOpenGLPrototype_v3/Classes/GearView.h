//
//  GearView.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComponentView.h"
#import "Gear.h"
#import "GearModel.h"
#import "GearShaderModel.h"
#import "BoxModel.h"
#import "AMViewStateHandler.h"


@interface GearView : NSObject <ComponentView,AMViewStateHandler> {
	Gear *myGear;
	
	Vector3D position;
	float opacity;
	
	BOOL isPinAndSlotGear;
	BOOL isPointerActive;
	
	GearModel *gearModel;
	GearShaderModel *gearShaderModel;
	BoxModel *pointerModel;
}

- (id) initWithGear:(Gear*)gear;

- (void) setPosition:(Vector3D)pos;
- (void) setPositionRelativeTo:(id<ComponentView>)component AtAngle:(float)angle;
- (void) setPositionRelativeTo:(id<ComponentView>)component VerticalOffset:(float)vOffset;

- (void) setAsPinAndSlotGear:(BOOL)flag;

@end
