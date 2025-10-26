//
//  Connector.m
//  Antikythera
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import Foundation

class Connector: NSObject, DeviceComponent {
    
    var radius: Float = 0.0
    var rotation: Float = 0.0
    var name = ""
    
    var topComponent: DeviceComponent?
    var bottomComponent: DeviceComponent?
    
    // Tests for connection existence
    var hasTopComponent: Bool {
        return topComponent != nil
    }
    
    var hasBottomComponent: Bool {
        return bottomComponent != nil
    }
    
    class func makeConnector(info: ConnectorInfo, allGears: [String:Gear]) throws -> Connector {
        // get the type
        let connector: Connector

        switch info.connectionType {
        case "connector":
            connector = try Connector(info: info, allGears: allGears)
        case "pin-and-slot":
            connector = try PinAndSlotConnector(info: info, allGears: allGears)
            break
        default:
            throw AntikytheraError.BuildError("makeConnectorFromDictionary: Unrecognized connector type")
        }
        return connector
    }


    // Initialize with a certain radius
    init(radius: Float) {
		self.radius = radius
    }

    init(info: ConnectorInfo, allGears: [String:Gear]) throws {
        super.init()
        
        self.name = info.name
        self.radius = info.radius

        guard let top = allGears[info.topGear] else { throw AntikytheraError.BuildError("Couldn't find top gear")  }
        guard let bottom = allGears[info.bottomGear] else { throw AntikytheraError.BuildError("Couldn't find bottom gear")  }
        
        // If connecting gears, make sure the gears are aware
        top.addNeighbor(self)
        bottom.addNeighbor(self)
        
        setConnections(top, bottom: bottom)
    }

    convenience init(radius: Float, top: DeviceComponent, bottom: DeviceComponent) {
        self.init(radius: radius)
        
        // If connecting gears, make sure the gears are aware
        (top as? Gear)?.addNeighbor(self)
        (bottom as? Gear)?.addNeighbor(self)
        
        setConnections(top, bottom: bottom)
    }

    // Convenience method for setting connections easily
    func setConnections(_ top: DeviceComponent, bottom: DeviceComponent) {
        topComponent = top
        bottomComponent = bottom
    }

    // Protocol Methods:

    func rotate(_ arcAngle: Float) {
        rotation += arcAngle
        
        updateTopComponentRotation(arcAngle)
        updateBottomComponentRotation(arcAngle)
    }
    
    func updateRotation(_ arcAngle: Float, fromSource source: DeviceComponent) {
        rotation += arcAngle
        
        if let topComponent = topComponent, source != topComponent {
            updateTopComponentRotation(arcAngle)
        }
        
        if let bottomComponent = bottomComponent, source != bottomComponent {
            updateBottomComponentRotation(arcAngle)
        }
    }

    // Updates connection rotations, if they exist
    func updateTopComponentRotation(_ arcAngle: Float) {
        topComponent?.updateRotation(arcAngle, fromSource: self)
    }

    func updateBottomComponentRotation(_ arcAngle: Float) {
        bottomComponent?.updateRotation(arcAngle, fromSource: self)
    }

}
