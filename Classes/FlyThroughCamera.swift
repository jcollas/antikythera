//
//  FlyThroughCamera.swift
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import Metal
import MetalKit

class FlyThroughCamera: NSObject, CameraViewpoint {

    var rot: Float = 0.0
    var lastDrawTime: TimeInterval = 0

    func updateViewpoint() {
        guard let renderer = MetalRenderContext.shared.renderer else { return }

        renderer.loadIdentity()
        renderer.translate(x: 0.0, y: 0.0, z: -100.0 + 50 * sin(-rot / 100))
        renderer.rotate(angle: -rot, x: 1.0, y: 1.0, z: 1.0)

        if lastDrawTime != 0 {
            let timeSinceLastDraw = Date.timeIntervalSinceReferenceDate - lastDrawTime
            rot += Float(10 * timeSinceLastDraw)
        }
        lastDrawTime = Date.timeIntervalSinceReferenceDate
    }

}
