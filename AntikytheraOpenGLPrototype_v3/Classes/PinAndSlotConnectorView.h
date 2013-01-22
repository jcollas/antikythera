//
//  PinAndSlotConnectorView.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComponentView.h"
#import "PinAndSlotConnector.h"
#import "ConnectorModel.h"
#import "AMViewStateHandler.h"


@interface PinAndSlotConnectorView : NSObject <ComponentView,AMViewStateHandler> {
	PinAndSlotConnector *myConnector;
	
	Vector3D pinPosition,slotPosition;
	float length;
	float opacity;
	
	ConnectorModel *connectorModel;
}

- (id) initWithConnector:(PinAndSlotConnector*)connector;

- (void) setPositionFromConnections:(id<ComponentView>)top Bottom:(id<ComponentView>)bottom;

- (void) drawPin;
- (void) drawSlot;

@end