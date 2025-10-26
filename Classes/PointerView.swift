//
//  PointerView.swift
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import Metal
import MetalKit

class PointerView: NSObject, ComponentView, AMViewStateHandler {
    var myComponent: DeviceComponent!
    
    var position = Vector3D.zero
    var opacity: Float = 1.0
    var depthTest = false
    
    var pointerModel: PointerModel!

    class func makePointerView(info: PointerInfo, allGears: [String:Gear], allGearViews: [String:GearView], allPointers: [String:PointerView]) throws -> (PointerView, String) {

        // make the view from the params!
        let gear = allGears[info.onGear]!
        let view : PointerView
        switch info.pointerKind {
        case "regular":
            view = PointerView(component: gear, shaftLength:info.shaftLength * kDepthScale, shaftRadius:info.shaftRadius, pointerLength:info.pointerLength, pointerWidth:info.pointerWidth)
            break
            
        case "lunar":
            guard let yearPointerViewName = info.rotatesToPointer else { throw AntikytheraError.BuildError("Missing rotatesToPointer!") }
            
            let yearPointer = allPointers[yearPointerViewName]!
            view = LunarPointerView(component: gear, yearPointer:yearPointer, shaftLength:info.shaftLength * kDepthScale, shaftRadius:info.shaftRadius, pointerLength:info.pointerLength, pointerWidth:info.pointerWidth)
            break
            
        default:
            throw AntikytheraError.BuildError("Unrecognized pointerKind!")
        }
        
        // and position it!
        let gearView = allGearViews[info.onGear]!
        view.setPositionRelativeTo(gearView, verticalOffset: -(info.shaftLength * kDepthScale))

        
        return (view, info.name)
    }
    
    // Initialize with gear. This is the gear to be drawn by this view.
    init(component: DeviceComponent, shaftLength sLen: Float, shaftRadius sRad: Float, pointerLength pLen: Float, pointerWidth pWidth: Float) {
        
        super.init()
		myComponent = component
		
		
		pointerModel = PointerModel(shaftLength:sLen, shaftRadius:sRad, pointerLength:pLen, pointerWidth:pWidth)
    }

    // Set position in 3D space
    func setPosition(_ pos: Vector3D) {
        position = pos
    }

    func setPositionRelativeTo(_ component: ComponentView, verticalOffset vOffset: Float) {
        let v = component.position
        
        position.x = v.x
        position.y = v.y
        position.z = v.z + vOffset
    }

    // Protocol Methods:
    var rotation: Float {
        return myComponent.rotation
    }

    var radius: Float {
        return Float(pointerModel.pointerLength)
    }

    func draw() {
        guard let renderer = MetalRenderContext.shared.renderer else { return }

        if self.opacity > 0.0 {
            renderer.pushMatrix()

            if !depthTest {
                renderer.translate(x: position.x, y: position.y, z: position.z)
            } else {
                renderer.translate(x: position.x, y: position.y, z: position.z / 2)
            }
            let rotation = myComponent.rotation
            renderer.rotate(angle: rotation * 180.0 / .pi, x: 0.0, y: 0.0, z: 1.0)

            if depthTest {
                renderer.enableDepthTest()
            }

            renderer.pushMatrix()
            renderer.scale(x: 1.0, y: 1.0, z: 1.0)
            renderer.setColor(r: 1.0, g: 1.0, b: 1.0, a: 0.5 * self.opacity)
            pointerModel.draw()
            renderer.popMatrix()

            if depthTest {
                renderer.disableDepthTest()
            }

            renderer.popMatrix()
        }
    }

    func updateWithState(_ state: AMState, phase: AMStatePhase) {
        switch (state) {
        case .pointers:
            opacity = 1.0
            depthTest = false

        case .gears:
            opacity = 0.2
            depthTest = false

        case .box:
            opacity = 1.0
            depthTest = true

        case .pinAndSlot:
            opacity = 0.0

        default: //STATE_DEFAULT
            opacity = 1.0
            depthTest = false
        }
    }

}
