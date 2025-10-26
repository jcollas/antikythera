//
//  SideCamera.swift
//  Antikythera
//
//  Created by Matt Ricketson on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

import Metal
import MetalKit

class SideCamera: NSObject, CameraViewpoint {

    func updateViewpoint() {
        guard let renderer = MetalRenderContext.shared.renderer else { return }

        renderer.loadIdentity()
        renderer.translate(x: 0.0, y: 0.0, z: 0)
        renderer.rotate(angle: -90, x: 1.0, y: 0.0, z: 0.0)
        renderer.translate(x: 0.0, y: 150.0, z: 40.0)
    }

}
