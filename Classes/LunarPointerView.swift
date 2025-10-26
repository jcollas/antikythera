//
//  LunarPointerView.swift
//  Antikythera
//
//  Created by Matt Ricketson on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

import Metal
import MetalKit

class LunarPointerView: PointerView {
    var yearPointer: PointerView
    
    var moonRotation: Float = 0.0
    
    var brightMoonModel: HalfGlobeModel!
    var darkMoonModel: HalfGlobeModel!

    init(component: DeviceComponent, yearPointer pointer: PointerView, shaftLength sLen: Float, shaftRadius sRad: Float, pointerLength pLen: Float, pointerWidth pWidth: Float) {
        yearPointer = pointer
        
        super.init(component: component, shaftLength: sLen, shaftRadius: sRad, pointerLength: pLen, pointerWidth: pWidth)
        
		brightMoonModel = HalfGlobeModel(radius:2.5)
		darkMoonModel = HalfGlobeModel(radius:2.5)
    }

    override func draw() {
        guard let renderer = MetalRenderContext.shared.renderer else { return }

        super.draw()

        let r1 = normalizeRotation(self.rotation * 180.0 / .pi)
        let r2 = normalizeRotation(yearPointer.rotation * 180.0 / .pi)
        let rotDiff = r2 - r1

        moonRotation = rotDiff + 90

        renderer.pushMatrix()

        if !depthTest {
            renderer.translate(x: position.x, y: position.y, z: position.z)
        } else {
            renderer.translate(x: position.x, y: position.y, z: position.z / 2)
        }
        renderer.rotate(angle: myComponent.rotation * 180.0 / .pi, x: 0.0, y: 0.0, z: 1.0)
        renderer.translate(x: self.radius * 2 / 3, y: 0.0, z: 0.0)

        renderer.enableDepthTest()

        renderer.pushMatrix()
        renderer.rotate(angle: moonRotation + 180, x: 1.0, y: 0.0, z: 0.0)
        renderer.translate(x: 0.0, y: 0.1, z: 0.0)
        renderer.scale(x: 1.0, y: 1.0, z: 1.0)
        renderer.setColor(r: 1.0, g: 1.0, b: 1.0, a: 1.0 * self.opacity)
        brightMoonModel.draw()
        renderer.popMatrix()

        renderer.pushMatrix()
        renderer.rotate(angle: moonRotation, x: 1.0, y: 0.0, z: 0.0)
        renderer.translate(x: 0.0, y: 0.1, z: 0.0)
        renderer.setColor(r: 0.5, g: 0.2, b: 0.2, a: 1.0 * self.opacity)
        darkMoonModel.draw()
        renderer.popMatrix()

        renderer.disableDepthTest()

        renderer.popMatrix()
    }

    func normalizeRotation(_ rotation: Float) -> Float {
        var rotation = rotation
        var mult = rotation/360
        
        if (mult >= 1) {
            mult = floorf(mult)
            rotation = rotation - mult*360
        }
        
        return rotation
    }

}
