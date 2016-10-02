//
//  AntikytheraMechanism.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import Foundation

class AntikytheraMechanism: NSObject, MechanicalDevice {

    // Initialize Components
    
    // Gears
    let gA1 = Gear(teeth: 48)
    let gB0 = Gear(teeth: 20)
    let gB1 = Gear(teeth: 224)
    let gB2 = Gear(teeth: 64)
    let gB3 = Gear(teeth: 32)
    let gC1 = Gear(teeth: 38)
    let gC2 = Gear(teeth: 48)
    let gD1 = Gear(teeth: 24)
    let gD2 = Gear(teeth: 127)
    let gE1 = Gear(teeth: 32)
    let gE2 = Gear(teeth: 32)
    let gE3 = Gear(teeth: 223)
    let gE4 = Gear(teeth: 188)
    let gE5 = Gear(teeth: 50, radiusScale: 0.96)
    let gE6 = Gear(teeth: 50)
    let gF1 = Gear(teeth: 53)
    let gF2 = Gear(teeth: 30)
    let gG1 = Gear(teeth: 54)
    let gG2 = Gear(teeth: 20)
    let gH1 = Gear(teeth: 60)
    let gH2 = Gear(teeth: 15)
    let gI1 = Gear(teeth: 60)
    let gK1 = Gear(teeth: 50, radiusScale: 0.96)
    let gK2 = Gear(teeth: 50)
    let gL1 = Gear(teeth: 38)
    let gL2 = Gear(teeth: 53)
    let gM1 = Gear(teeth: 96)
    let gM2 = Gear(teeth: 15)
    let gM3 = Gear(teeth: 27)
    let gN1 = Gear(teeth: 53)
    let gN2 = Gear(teeth: 15)
    let gP1 = Gear(teeth: 60)
    let gP2 = Gear(teeth: 12)
    let gO1 = Gear(teeth: 60)
    
    // Connect Gear Groups Together
    var cB0toB3: Connector!
    var cB1toB2: Connector!
    var cC1toC2: Connector!
    var cD1toD2: Connector!
    var cE1toE2: Connector!     // WHAT?
    var cE1toE6: Connector!
    var cE2toE5: Connector!
    var cE3toE4: Connector!
    var cF1toF2: Connector!
    var cG1toG2: Connector!
    var cH1toH2: Connector!
    var cL1toL2: Connector!
    var cM1toM2: Connector!
    var cM2toM3: Connector!
    var cN1toN2: Connector!
    var cP1toP2: Connector!

    var cK1toK2: PinAndSlotConnector!
    
    override init() {
        super.init()
        buildDevice()
    }

    // Protocol Methods:
    func buildDevice() {
//
        cB0toB3	= Connector(radius: 1.0, top: gB0, bottom: gB3)
        cB1toB2	= Connector(radius: 2.0, top:gB1, bottom:gB2)
        cC1toC2	= Connector(radius: 1.0, top:gC1, bottom:gC2)
        cD1toD2	= Connector(radius: 1.0, top:gD1, bottom:gD2)
//        cE1toE2	= Connector(radius: 1.0, top:gE1, bottom:gE2)
        cE1toE6	= Connector(radius: 1.0, top:gE1, bottom:gE6)
        cE2toE5	= Connector(radius: 2.0, top:gE2, bottom:gE5)
        cE3toE4	= Connector(radius: 1.0, top:gE3, bottom:gE4)
        cF1toF2	= Connector(radius: 1.0, top:gF1, bottom:gF2)
        cG1toG2	= Connector(radius: 1.0, top:gG1, bottom:gG2)
        cH1toH2	= Connector(radius: 1.0, top:gH1, bottom:gH2)
        cL1toL2	= Connector(radius: 1.0, top:gL1, bottom:gL2)
        cM1toM2	= Connector(radius: 1.0, top:gM1, bottom:gM2)
        cM2toM3	= Connector(radius: 1.0, top:gM2, bottom:gM3)
        cN1toN2	= Connector(radius: 1.0, top:gN1, bottom:gN2)
        cP1toP2	= Connector(radius: 1.0, top:gP1, bottom:gP2)
        
        cK1toK2	= newPinAndSlotConnectorWithRadius(0.5, top:gK1, bottom:gK2)
//
//        // ---
//        // Link Gears to Their Direct Neighbors
//        // ---
//        // Gears:
        linkGear(gA1, with: gB1)
        linkGear(gB2, with: gC1)
        linkGear(gB2, with: gL1)
        linkGear(gB3, with: gE1)
        linkGear(gC2, with: gD1)
        linkGear(gE2, with: gD2)
        linkGear(gE3, with: gM3)
        linkGear(gE4, with: gF1)
        linkGear(gE5, with: gK1)
        linkGear(gE6, with: gK2)
        linkGear(gF2, with: gG1)
        linkGear(gH1, with: gG2)
        linkGear(gI1, with: gH2)
        linkGear(gL2, with: gM1)
        linkGear(gM2, with: gN1)
        linkGear(gN2, with: gP1)
        linkGear(gP2, with: gO1)
    }

    // Link gears together (set them as mutual neighbors)
    func linkGear(_ gear1: Gear, with gear2: Gear) {
        gear1.addNeighbor(gear2)
        gear2.addNeighbor(gear1)
    }

    // Initialize new connecter with specific radius and default connections
    func newConnectorWithRadius(_ radius: Float, top: DeviceComponent, bottom: DeviceComponent) -> Connector {
        let connector = Connector(radius: radius)
        
        // If connecting gears, make sure the gears are aware
        (top as? Gear)?.addNeighbor(connector)
        (bottom as? Gear)?.addNeighbor(connector)
        
        connector.setConnections(top, bottom: bottom)
        return connector
    }
    
    func newPinAndSlotConnectorWithRadius(_ radius: Float, top: Gear, bottom: Gear) -> PinAndSlotConnector {
        
        let aOffset = (bottom.radius*2) - (top.radius*2)
        let pOffset = top.radius*0.7
        
        let connector = PinAndSlotConnector(radius:radius, arborOffset:aOffset, pinOffset:pOffset)
        
        top.addNeighbor(connector)
        bottom.addNeighbor(connector)
        
        connector.setConnections(top, bottom:bottom)
        
        return connector
    }

    // Rotate input gear
    func rotate(_ arcAngle: Float) {
        //	[gA1 updateRotation:arcAngle FromSource:nil]
        gA1.rotate(arcAngle)
    }

}
