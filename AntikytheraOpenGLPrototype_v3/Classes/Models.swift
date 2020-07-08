//
//  ModelView.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import OpenGLES

protocol MechanicalDevice {

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

enum AntikytheraError : Error {
    case BuildError(String)
}

protocol DeviceComponent: NSObjectProtocol {

    var rotation: Float { get }
    var radius: Float { get }
    var name : String { get }

    func rotate(_ arcAngle: Float)
    func updateRotation(_ arcAngle: Float, fromSource source: DeviceComponent)

}

protocol ComponentView: ModelView {

    var position: Vector3D { get }
    var rotation: Float { get }
    var radius: Float { get }
    var opacity: Float { get }

}

enum AMState {
    case `default`
    case pointers
    case gears
    case box
    case pinAndSlot
}

enum AMStatePhase {
    case start
    case running
    case end
}

protocol AMViewStateHandler {

    func updateWithState(_ state: AMState, phase: AMStatePhase)

}
