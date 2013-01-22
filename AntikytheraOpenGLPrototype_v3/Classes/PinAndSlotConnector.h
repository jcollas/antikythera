//
//  PinAndSlotConnector.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connector.h"
#import "OpenGLCommon.h"


@interface PinAndSlotConnector : Connector {
	float arborOffset;
	float pinOffset;
}

- (id) initWithRadius:(float)Radius ArborOffset:(float)aOffset PinOffset:(float)pOffset;

- (float) getPinOffset;
- (float) getSlotOffset;
- (float) getPinRotation;
- (float) getSlotRotation;

@end
