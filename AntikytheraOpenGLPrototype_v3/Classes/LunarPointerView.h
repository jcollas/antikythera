//
//  LunarPointerView.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PointerView.h"
#import "HalfGlobeModel.h"


@interface LunarPointerView : PointerView {
	PointerView *yearPointer;
	
	float moonRotation;
	
	HalfGlobeModel *brightMoonModel,*darkMoonModel;
}

- (id) initWithComponent:(id<DeviceComponent>)component YearPointer:(PointerView*)pointer ShaftLength:(float)sLen ShaftRadius:(float)sRad PointerLength:(float)pLen PointerWidth:(float)pWidth;

- (float) normalizeRotation:(float)rotation;

@end
