//
//  PointerView.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceComponent.h"
#import "ComponentView.h"
#import "PointerModel.h"
#import "AMViewStateHandler.h"


@interface PointerView : NSObject <ComponentView,AMViewStateHandler> {
	id<DeviceComponent> myComponent;
	
	Vector3D position;
	float opacity;
	BOOL depthTest;
	
	PointerModel *pointerModel;
}

- (id) initWithComponent:(id<DeviceComponent>)component ShaftLength:(float)sLen ShaftRadius:(float)sRad PointerLength:(float)pLen PointerWidth:(float)pWidth;

- (void) setPosition:(Vector3D)pos;
- (void) setPositionRelativeTo:(id<ComponentView>)component VerticalOffset:(float)vOffset;

@end