//
//  ConnectorView.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComponentView.h"
#import "Connector.h"
#import "ConnectorModel.h"
#import "AMViewStateHandler.h"


@interface ConnectorView : NSObject <ComponentView,AMViewStateHandler> {
	Connector *myConnector;
	
	Vector3D position;
	float length,opacity;
	
	ConnectorModel *connectorModel;
}

- (id) initWithConnector:(Connector*)connector;

- (void) setPositionFromConnections:(id<ComponentView>)top Bottom:(id<ComponentView>)bottom;

@end
