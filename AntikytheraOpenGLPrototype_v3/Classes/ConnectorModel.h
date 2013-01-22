//
//  ConnectorModel.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLModel3D.h"
#import "Connector.h"


@interface ConnectorModel : GLModel3D {

}

- (id) initWithConnector:(Connector*)connector;

- (void) buildModelFromConnector:(Connector*)connector;

@end
