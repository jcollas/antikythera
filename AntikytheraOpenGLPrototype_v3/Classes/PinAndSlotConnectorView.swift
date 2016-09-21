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
    
    var pinPosition = Vector3D.zero
    var slotPosition = Vector3D.zero
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
    func setPositionFromConnections(_ top: ComponentView, bottom: ComponentView) {
        
        if myConnector.hasTopComponent && myConnector.hasBottomComponent {
            let topPosition = top.position
            let bottomPosition = bottom.position
            pinPosition = Vector3D(x: topPosition.x, y: topPosition.y, z:(topPosition.z+bottomPosition.z)/2.0)
            slotPosition = bottomPosition
            let distance = topPosition.startAndEndPoints(bottomPosition)
            length = distance.magnitude / 2.0
        } else {
            pinPosition = Vector3D.zero
            slotPosition = Vector3D.zero
            length = 0.0
        }
    }

    // Protocol Methods:
    var position: Vector3D {
        return pinPosition
    }

    var rotation: Float {
        return myConnector.rotation
    }

    var radius: Float {
        return myConnector.radius
    }

    func draw() {
        glPushMatrix()
        
        self.drawPin()
        self.drawSlot()
        
        glPopMatrix()
    }

    func drawPin() {
        let rotation = myConnector.pinRotation
        
        if self.opacity > 0.0 {
            glPushMatrix()
            
            glColor4f(1.0, 1.0, 1.0, 0.8*self.opacity)
            
            glTranslatef(pinPosition.x, pinPosition.y, pinPosition.z)
            glRotatef(rotation, 0.0, 0.0, 1.0)
            glTranslatef(myConnector.pinOffset, 0.0, 0.0)
            glScalef(1.0, 1.0, length)
            
            connectorModel.draw()
            
            glPopMatrix()
        }
    }

    func drawSlot() {
        
    }

    func updateWithState(_ state: AMState, phase: AMStatePhase) {
        switch (state) {
        case .pointers, .box:
            opacity = 0.0

        case .gears, .pinAndSlot:
            opacity = 1.0

        default: //STATE_DEFAULT
            opacity = 1.0
        }
    }

}
