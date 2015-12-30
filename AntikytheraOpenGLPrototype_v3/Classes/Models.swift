//
//  ModelView.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import OpenGLES

protocol MechanicalDevice: NSObjectProtocol {

    func buildDevice()

}

protocol ModelView {

    func draw()

}

protocol DeviceView: ModelView {

    func buildDeviceView()
    
}

func == (lhs: DeviceComponent, rhs: DeviceComponent) -> Bool {
    return lhs === rhs
}

func != (lhs: DeviceComponent, rhs: DeviceComponent) -> Bool {
    return lhs !== rhs
}

protocol DeviceComponent: NSObjectProtocol {

    func getRotation() -> Float
    func getRadius() -> Float

    func rotate(arcAngle: Float)
    func updateRotation(arcAngle: Float, fromSource source: DeviceComponent)

}


protocol ComponentView: ModelView {

    func getPosition() -> Vector3D
    func getRotation() -> Float
    func getRadius() -> Float
    func getOpacity() -> Float

}

enum AMState {
    case Default
    case Pointers
    case Gears
    case Box
    case PinAndSlot
}

enum AMStatePhase {
    case Start
    case Running
    case End
}

protocol AMViewStateHandler {

    func updateWithState(state: AMState, phase: AMStatePhase)

}