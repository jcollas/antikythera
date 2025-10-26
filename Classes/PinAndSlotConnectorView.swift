//
//  PinAndSlotConnectorView.swift
//  Antikythera
//
//  Created by Matt Ricketson on 4/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import Metal
import MetalKit

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
        guard let renderer = MetalRenderContext.shared.renderer else { return }

        renderer.pushMatrix()

        self.drawPin()
        self.drawSlot()

        renderer.popMatrix()
    }

    func drawPin() {
        guard let renderer = MetalRenderContext.shared.renderer else { return }

        let rotation = myConnector.pinRotation

        if self.opacity > 0.0 {
            renderer.pushMatrix()

            renderer.setColor(r: 1.0, g: 1.0, b: 1.0, a: 0.8 * self.opacity)

            renderer.translate(x: pinPosition.x, y: pinPosition.y, z: pinPosition.z)
            renderer.rotate(angle: rotation * 180.0 / .pi, x: 0.0, y: 0.0, z: 1.0)
            renderer.translate(x: myConnector.pinOffset, y: 0.0, z: 0.0)
            renderer.scale(x: 1.0, y: 1.0, z: length)

            connectorModel.draw()

            renderer.popMatrix()
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
