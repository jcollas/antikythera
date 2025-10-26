//
//  TopCamera.swift
//  Antikythera
//
//  Created by Matt Ricketson on 4/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import Metal
import MetalKit

class TopCamera: NSObject, CameraViewpoint {

    func updateViewpoint() {
        guard let renderer = MetalRenderContext.shared.renderer else { return }

        renderer.loadIdentity()
        renderer.translate(x: 0.0, y: 0.0, z: -100.0)
        // renderer.rotate(angle: -10, x: 1.0, y: 0.0, z: 0.0)
    }

}
