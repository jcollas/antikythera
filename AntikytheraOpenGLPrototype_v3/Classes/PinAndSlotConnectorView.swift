//
//  PinAndSlotConnectorView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import OpenGLES

class PinAndSlotConnectorView: NSObject, ComponentView, AMViewStateHandler {
    var myConnector: PinAndSlotConnector!
    
    var pinPosition = Vector3D.Zero
    var slotPosition = Vector3D.Zero
    var length: Float = 0.0
    var opacity: Float = 1.0
    
    var connectorModel: ConnectorModel!

    // Initialize with gear. This is the gear to be drawn by this view.
    init(connector: PinAndSlotConnector) {
        super.init()
		myConnector = connector

		connectorModel = ConnectorModel(connector:myConnector)
    }

    // Sets the position in 3D space based on the views visible connections
    // NOTE: view connections may differ from the model connections.
    func setPositionFromConnections(top: ComponentView, bottom: ComponentView) {
        
        if myConnector.hasTopComponent && myConnector.hasBottomComponent {
            let topPosition = top.getPosition()
            let bottomPosition = bottom.getPosition()
            pinPosition = Vector3D(x: topPosition.x, y: topPosition.y, z:(topPosition.z+bottomPosition.z)/2.0)
            slotPosition = bottomPosition
            let distance = topPosition.startAndEndPoints(bottomPosition)
            length = distance.magnitude / 2.0
        } else {
            pinPosition = Vector3D.Zero
            slotPosition = Vector3D.Zero
            length = 0.0
        }
    }

    // Protocol Methods:
    func getPosition() -> Vector3D {
        return pinPosition
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
        glPushMatrix()
        
        self.drawPin()
        self.drawSlot()
        
        glPopMatrix()
    }

    func drawPin() {
        let rotation = myConnector.getPinRotation()
        
        if self.getOpacity() > 0.0 {
            glPushMatrix()
            
            glColor4f(1.0, 1.0, 1.0, 0.8*self.getOpacity())
            
            glTranslatef(pinPosition.x, pinPosition.y, pinPosition.z)
            glRotatef(rotation, 0.0, 0.0, 1.0)
            glTranslatef(myConnector.getPinOffset(), 0.0, 0.0)
            glScalef(1.0, 1.0, length)
            
            connectorModel.draw()
            
            glPopMatrix()
        }
    }

    func drawSlot() {
        
    }

    func updateWithState(state: AMState, phase: AMStatePhase) {
        switch (state) {
        case .Pointers, .Box:
            opacity = 0.0

        case .Gears, .PinAndSlot:
            opacity = 1.0

        default: //STATE_DEFAULT
            opacity = 1.0
        }
    }

}
