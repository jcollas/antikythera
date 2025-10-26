//
//  ConnectorView.swift
//  Antikythera
//
//  Created by Matt Ricketson on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import Metal
import MetalKit

class ConnectorView: NSObject, ComponentView, AMViewStateHandler {
    var myConnector: Connector!
    
    var position = Vector3D.zero
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
    func setPositionFromConnections(_ top: ComponentView, bottom: ComponentView) {
        
        if myConnector.hasTopComponent && myConnector.hasBottomComponent {
            position = top.position.add(bottom.position)
            position = Vector3D(x: position.x/2.0, y: position.y/2.0, z: position.z/2.0)
            let distance = top.position.startAndEndPoints(bottom.position)
            length = distance.magnitude/2.0
        } else {
            position = Vector3D.zero
            length = 0.0
        }
    }

// Protocol Methods:

    var rotation: Float {
        return myConnector.rotation
    }
    
    var radius: Float {
        return myConnector.radius
    }

    func draw() {
        guard let renderer = MetalRenderContext.shared.renderer else { return }

        if self.opacity > 0.0 {
            renderer.pushMatrix()

            renderer.setColor(r: 1.0, g: 1.0, b: 1.0, a: 0.5 * self.opacity)

            renderer.translate(x: position.x, y: position.y, z: position.z)
            renderer.rotate(angle: self.rotation * 180.0 / .pi, x: 0.0, y: 0.0, z: 1.0)
            renderer.scale(x: 1.0, y: 1.0, z: length)

            connectorModel.draw()

            renderer.popMatrix()
        }
    }

    func updateWithState(_ state: AMState, phase: AMStatePhase) {
        switch (state) {
            case .pointers:
                opacity = 0.2

            case .gears:
                opacity = 1.0

            case .box:
                opacity = 0.0

            case .pinAndSlot:
                opacity = 0.0

            default: //STATE_DEFAULT
                opacity = 1.0
        }
    }

}
