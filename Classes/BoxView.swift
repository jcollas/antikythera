//
//  BoxView.swift
//  Antikythera
//
//  Created by Matt Ricketson on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

import Metal
import MetalKit

class BoxView: NSObject, ComponentView, AMViewStateHandler {
    
    var position = Vector3D.zero
    var rotation: Float = 0.0
    var opacity: Float = 1.0
    var radius: Float = 0.0
    var depthTest = true

    var boxModel: BoxModel!

    // Initialize with gear. This is the gear to be drawn by this view.
    init(width: Float, height: Float, length: Float) {
		boxModel = BoxModel(width: width, height:height, length:length)
    }

    // Set position in 3D space
    func setPosition(_ pos: Vector3D) {
        position = pos
    }
    
//    func setRotation(rot: Float) {
//        rotation = rot
//    }

    func draw() {
        guard let renderer = MetalRenderContext.shared.renderer else { return }

        if opacity > 0.0 {
            renderer.pushMatrix()

            renderer.translate(x: position.x, y: position.y, z: position.z)
            renderer.rotate(angle: rotation * 180.0 / .pi, x: 0.0, y: 0.0, z: 1.0)
            if !depthTest {
                renderer.scale(x: 1.0, y: 1.0, z: (75.0 / 35.0))
            }

            if depthTest {
                renderer.enableDepthTest()
            }

            renderer.pushMatrix()
            renderer.setColor(r: 0.855 / 2, g: 0.573 / 2, b: 0.149 / 2, a: opacity)
            boxModel.draw()
            renderer.popMatrix()

            if depthTest {
                renderer.disableDepthTest()
            }

            renderer.popMatrix()
        }
    }

    func updateWithState(_ state: AMState, phase: AMStatePhase) {
        
        switch state {
            
        case .pointers, .gears:
            opacity = 0.1
            depthTest = false

        case .box:
            opacity = 1.0
            depthTest = true

        case .pinAndSlot:
            opacity = 0.0

        default: //STATE_DEFAULT
            opacity = 0.15
            depthTest = false
        }
    }

}
