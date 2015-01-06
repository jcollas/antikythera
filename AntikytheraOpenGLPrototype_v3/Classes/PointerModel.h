//
//  PointerModel.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLModel3D.h"


@interface PointerModel : GLModel3D

@property (nonatomic,readonly) float shaftLength;
@property (nonatomic,readonly) float shaftRadius;

@property (nonatomic,readonly) float pointerLength;
@property (nonatomic,readonly) float pointerWidth;

- (id) initWithShaftLength:(float)sLen ShaftRadius:(float)sRad PointerLength:(float)pLen PointerWidth:(float)pWidth;

- (void) buildModelWithShaftLength:(float)sLen ShaftRadius:(float)sRad PointerLength:(float)pLen PointerWidth:(float)pWidth;

@end
