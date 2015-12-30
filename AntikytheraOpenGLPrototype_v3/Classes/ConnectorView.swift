//
//  ConnectorView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import OpenGLES

class ConnectorView: NSObject, ComponentView, AMViewStateHandler {
    var myConnector: Connector!
    
    var position = Vector3D.Zero
    var length: Float = 0.0
    var opacity: Float = 1.0
    
    var connectorModel: ConnectorModel!

    // Initialize with gear. This is the gear to be drawn by this view.
    init(connector: Connector) {
        myConnector = connector
		connectorModel = ConnectorModel(connector:myConnector)
    }

    // Sets the position in 3D space based on the views visible connections
    // NOTE: view connections may differ from the model connections.
    func setPositionFromConnections(top: ComponentView, bottom: ComponentView) {
        
        if myConnector.hasTopComponent && myConnector.hasBottomComponent {
            position = top.getPosition().add(bottom.getPosition())
            position = Vector3D(x: position.x/2.0, y: position.y/2.0, z: position.z/2.0)
            let distance = top.getPosition().startAndEndPoints(bottom.getPosition())
            length = distance.magnitude/2.0
        } else {
            position = Vector3D.Zero
            length = 0.0
        }
    }

// Protocol Methods:
    func getPosition() -> Vector3D {
        return position
    }
    
    func getRotation() -> Float {
        return myConnector.getRotation()
    }
    
    func getRadius() -> Float {
        return myConnector.getRadius()
    }
    
    func getOpacity() -> Float {
        return opacity
    }

    func draw() {
        
        if self.getOpacity() > 0.0 {
            glPushMatrix()
            
            glColor4f(1.0, 1.0, 1.0, 0.5*self.getOpacity())
            
            glTranslatef(position.x, position.y, position.z)
            let rotation = myConnector.getRotation()
            glRotatef(rotation, 0.0, 0.0, 1.0)
            glScalef(1.0, 1.0, length)
            
            connectorModel.draw()
            
            glPopMatrix()
        }
    }

    func updateWithState(state: AMState, phase: AMStatePhase) {
        switch (state) {
            case .Pointers:
                opacity = 0.2

            case .Gears:
                opacity = 1.0

            case .Box:
                opacity = 0.0

            case .PinAndSlot:
                opacity = 0.0

            default: //STATE_DEFAULT
                opacity = 1.0
        }
    }

}
