//
//  ShowcaseCamera.swift
//  Antikythera
//
//  Created by Matt Ricketson on 4/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import Metal
import MetalKit

class ShowcaseCamera: NSObject, CameraViewpoint {

    var rot: Float = 0.0
    var lastDrawTime: TimeInterval = 0

    func updateViewpoint() {
        guard let renderer = MetalRenderContext.shared.renderer else { return }

        renderer.loadIdentity()
        renderer.translate(x: 0.0, y: 0.0, z: 0)
        renderer.rotate(angle: -90, x: 1.0, y: 0.0, z: 0.0)
        renderer.translate(x: 0.0, y: 100.0, z: 40.0)

        renderer.rotate(angle: 45 * sin(rot / 200), x: 1.0, y: 0.0, z: 0.0)
        renderer.rotate(angle: -rot, x: 0.0, y: 0.0, z: 1.0)

        if lastDrawTime != 0 {
            let timeSinceLastDraw = Date.timeIntervalSinceReferenceDate - lastDrawTime
            rot += Float(5 * timeSinceLastDraw)
        }
        lastDrawTime = Date.timeIntervalSinceReferenceDate
    }

}
