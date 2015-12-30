//
//  AntikytheraMechanismView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import Foundation

class AntikytheraMechanismView: NSObject, DeviceView {
    var myMechanism: AntikytheraMechanism!
    
    var views: [ModelView] = []
    
    var gvA1: GearView! // 48
    var gvB0: GearView! // 20
	var gvB1: GearView! // 224
	var gvB2: GearView! // 64
	var gvB3: GearView! // 32
	var gvC1: GearView! // 38
	var gvC2: GearView! // 48
	var gvD1: GearView! // 24
	var gvD2: GearView! // 127
	var gvE1: GearView! // 32
	var gvE2: GearView! // 32
	var gvE3: GearView! // 223
	var gvE4: GearView! // 188
	var gvE5: GearView! // 50
	var gvE6: GearView! // 50
	var gvF1: GearView! // 53
	var gvF2: GearView! // 30
	var gvG1: GearView! // 54
	var gvG2: GearView! // 20
	var gvH1: GearView! // 60
	var gvH2: GearView! // 15
	var gvI1: GearView! // 60
	var gvK1: GearView! // 50
	var gvK2: GearView! // 50
	var gvL1: GearView! // 38
	var gvL2: GearView! // 53
	var gvM1: GearView! // 96
	var gvM2: GearView! // 15
	var gvM3: GearView! // 27
	var gvN1: GearView! // 53
	var gvN2: GearView! // 15
	var gvP1: GearView! // 60
	var gvP2: GearView! // 12
	var gvO1: GearView! // 60
    
    var cvB1toB2: ConnectorView!
    var cvB0toB3: ConnectorView!
    var cvC1toC2: ConnectorView!
    var cvD1toD2: ConnectorView!
    var cvE1toE2: ConnectorView!
    var cvE2toE5: ConnectorView!
    var cvE3toE4: ConnectorView!
    var cvE1toE6: ConnectorView!
    var cvF1toF2: ConnectorView!
    var cvG1toG2: ConnectorView!
    var cvH1toH2: ConnectorView!
    var cvL1toL2: ConnectorView!
    var cvM1toM2: ConnectorView!
    var cvM2toM3: ConnectorView!
    var cvN1toN2: ConnectorView!
    var cvP1toP2: ConnectorView!
    var cvN2toMetonic: ConnectorView!
    
    var	cvK1toK2: PinAndSlotConnectorView!
    
    var year: PointerView!
    var metonic: PointerView!
    var saros: PointerView!
    var callippic: PointerView!
    var exeligmos: PointerView!
    
    var lunar: LunarPointerView!
    var box: BoxView!

    var currentState: AMState = .Default
    var currentStatePhase: AMStatePhase = .Running

    // Initializes view with specific mechanism
    init(mechanism: AntikytheraMechanism) {
        super.init()
		myMechanism = mechanism
        
        buildDeviceView()
    }

    // Protocol Methods:
    func buildDeviceView() {
        let dScale: Float = 2.0
        
        // ---
        // Initialize GearViews
        // ---
        gvA1 = newGearView(myMechanism.gA1)
        gvB0 = newGearView(myMechanism.gB0)
        gvB1 = newGearView(myMechanism.gB1)
        gvB2 = newGearView(myMechanism.gB2)
        gvB3 = newGearView(myMechanism.gB3)
        gvC1 = newGearView(myMechanism.gC1)
        gvC2 = newGearView(myMechanism.gC2)
        gvD1 = newGearView(myMechanism.gD1)
        gvD2 = newGearView(myMechanism.gD2)
        gvE1 = newGearView(myMechanism.gE1)
        gvE2 = newGearView(myMechanism.gE2)
        gvE3 = newGearView(myMechanism.gE3)
        gvE4 = newGearView(myMechanism.gE4)
        gvE5 = newGearView(myMechanism.gE5)
        gvE6 = newGearView(myMechanism.gE6)
        gvF1 = newGearView(myMechanism.gF1)
        gvF2 = newGearView(myMechanism.gF2)
        gvG1 = newGearView(myMechanism.gG1)
        gvG2 = newGearView(myMechanism.gG2)
        gvH1 = newGearView(myMechanism.gH1)
        gvH2 = newGearView(myMechanism.gH2)
        gvI1 = newGearView(myMechanism.gI1)
        gvK1 = newGearView(myMechanism.gK1)
        gvK2 = newGearView(myMechanism.gK2)
        gvL1 = newGearView(myMechanism.gL1)
        gvL2 = newGearView(myMechanism.gL2)
        gvM1 = newGearView(myMechanism.gM1)
        gvM2 = newGearView(myMechanism.gM2)
        gvM3 = newGearView(myMechanism.gM3)
        gvN1 = newGearView(myMechanism.gN1)
        gvN2 = newGearView(myMechanism.gN2)
        gvP1 = newGearView(myMechanism.gP1)
        gvP2 = newGearView(myMechanism.gP2)
        gvO1 = newGearView(myMechanism.gO1)
        
        
        // ---
        // Position & Format Components
        // ---
        gvB0.setPosition(Vector3D(x: 0.0, y: 0.0, z: 40.0))
        gvB1.setPositionRelativeTo(gvB0, verticalOffset:-5.0*dScale)
        gvA1.setPositionRelativeTo(gvB1, atAngle:Float(M_PI))
        gvB2.setPositionRelativeTo(gvB1, verticalOffset:-5.0*dScale)
        gvB3.setPositionRelativeTo(gvB2, verticalOffset:-5.0*dScale)
        gvC1.setPositionRelativeTo(gvB2, atAngle:0.0)
        gvC2.setPositionRelativeTo(gvC1, verticalOffset:-5.0*dScale)
        gvD1.setPositionRelativeTo(gvC2, atAngle:0.0)
        gvD2.setPositionRelativeTo(gvD1, verticalOffset:-5.0*dScale)
        gvE2.setPositionRelativeTo(gvD2, atAngle:Float(M_PI+(M_PI/8.32)))
        gvE5.setPositionRelativeTo(gvE2, verticalOffset:-8.0*dScale)
        gvE6.setPositionRelativeTo(gvE5, verticalOffset:-2.0*dScale)
        gvE1.setPositionRelativeTo(gvE2, verticalOffset:5.0*dScale)
        gvL1.setPositionRelativeTo(gvB2, atAngle:Float(M_PI*1.237))
        gvL2.setPositionRelativeTo(gvL1, verticalOffset:-5.0*dScale)
        gvM1.setPositionRelativeTo(gvL2, atAngle:Float(M_PI*0.978))
        gvM2.setPositionRelativeTo(gvM1, verticalOffset:-8.0*dScale)
        gvM3.setPositionRelativeTo(gvM2, verticalOffset:-2.0*dScale)
        gvE3.setPositionRelativeTo(gvM3, atAngle:0.0)
        gvE4.setPositionRelativeTo(gvE3, verticalOffset:-1.0*dScale)
        gvF1.setPositionRelativeTo(gvE4, atAngle:-0.05)
        gvF2.setPositionRelativeTo(gvF1, verticalOffset:-3.0*dScale)
        gvG1.setPositionRelativeTo(gvF2, atAngle:Float(M_PI_2*0.9))
        gvG2.setPositionRelativeTo(gvG1, verticalOffset:-3.0*dScale)
        gvH1.setPositionRelativeTo(gvG2, atAngle:Float(M_PI*0.7))
        gvH2.setPositionRelativeTo(gvH1, verticalOffset:-3.0*dScale)
        gvI1.setPositionRelativeTo(gvH2, atAngle:Float(-M_PI_2*1.4))
        gvK1.setPositionRelativeTo(gvE5, atAngle:0.0)
        gvK2.setPositionRelativeTo(gvE6, atAngle:0.0)
        gvN1.setPositionRelativeTo(gvM2, atAngle:Float(M_PI_2*1.55))
        gvN2.setPositionRelativeTo(gvN1, verticalOffset:-5.0*dScale)
        gvP1.setPositionRelativeTo(gvN2, atAngle:Float(M_PI_2*(-0.7)))
        gvP2.setPositionRelativeTo(gvP1, verticalOffset:-5.0*dScale)
        gvO1.setPositionRelativeTo(gvP2, atAngle:(0.9))
        
        // ---
        // Initialize BoxView
        // ---
        box = BoxView(width:100.0, height:170.0, length:35.0)
        self.addSubView(box)
        box.setPosition(Vector3D(x: 0.0, y: 0.0, z: -2.0))
        box.rotation = 2.8
        
        
        // ---
        // Initialize PointerViews
        // ---
        var shaftLength: Float = -4.0*dScale
        year = newPointerView(myMechanism.gB1, shaftLength:shaftLength, shaftRadius:2.0, pointerLength:30.0, pointerWidth:1.0)
        year.setPositionRelativeTo(gvB1, verticalOffset:-shaftLength)
        
        shaftLength = -1.0*dScale
        lunar = newLunarPointerView(myMechanism.gB0, yearPointer:year, shaftLength:shaftLength, shaftRadius:1.0, pointerLength:25.0, pointerWidth:1.0)
        lunar.setPositionRelativeTo(gvB0, verticalOffset:-shaftLength)
        
        shaftLength = 14.0*dScale
        metonic = newPointerView(myMechanism.gN2, shaftLength:shaftLength, shaftRadius:1.0, pointerLength:30.0, pointerWidth:1.0)
        metonic.setPositionRelativeTo(gvN2, verticalOffset:-shaftLength)
        
        shaftLength = 10.0*dScale
        saros = newPointerView(myMechanism.gG2, shaftLength:shaftLength, shaftRadius:1.0, pointerLength:30.0, pointerWidth:1.0)
        saros.setPositionRelativeTo(gvG2, verticalOffset:-shaftLength)
        
        shaftLength = 8.0*dScale
        callippic = newPointerView(myMechanism.gO1, shaftLength:shaftLength, shaftRadius:0.5, pointerLength:10.0, pointerWidth:0.5)
        callippic.setPositionRelativeTo(gvO1, verticalOffset:-shaftLength)
        
        shaftLength = 6.0*dScale
        exeligmos = newPointerView(myMechanism.gI1, shaftLength:shaftLength, shaftRadius:0.5, pointerLength:10.0, pointerWidth:0.5)
        exeligmos.setPositionRelativeTo(gvI1, verticalOffset:-shaftLength)
        
        
        // ---
        // Initialize ConnectorViews
        // ---
        cvB1toB2 = newConnectorView(myMechanism.cB1toB2, withConnections:gvB1, bottom:gvB2)
        cvB0toB3 = newConnectorView(myMechanism.cB0toB3, withConnections:gvB0, bottom:gvB3)
        cvC1toC2 = newConnectorView(myMechanism.cC1toC2, withConnections:gvC1, bottom:gvC2)
        cvD1toD2 = newConnectorView(myMechanism.cD1toD2, withConnections:gvD1, bottom:gvD2)
//        cvE1toE2 = newConnectorView(myMechanism.cE1toE2, withConnections:gvE1, bottom:gvE2)
        cvE2toE5 = newConnectorView(myMechanism.cE2toE5, withConnections:gvE2, bottom:gvE5)
        cvE3toE4 = newConnectorView(myMechanism.cE3toE4, withConnections:gvE3, bottom:gvE4)
        
        cvK1toK2 = newPinAndSlotConnectorView(myMechanism.cK1toK2, withConnections:gvK1, bottom:gvK2)
        //	[gvE5 setAsPinAndSlotGear:YES]; [gvE6 setAsPinAndSlotGear:YES];
        gvK1.setAsPinAndSlotGear(true)
        gvK2.setAsPinAndSlotGear(true)
        
        cvE1toE6 = newConnectorView(myMechanism.cE1toE6, withConnections:gvE1, bottom:gvE6)
        cvF1toF2 = newConnectorView(myMechanism.cF1toF2, withConnections:gvF1, bottom:gvF2)
        cvG1toG2 = newConnectorView(myMechanism.cG1toG2, withConnections:gvG1, bottom:gvG2)
        cvH1toH2 = newConnectorView(myMechanism.cH1toH2, withConnections:gvH1, bottom:gvH2)
        cvL1toL2 = newConnectorView(myMechanism.cL1toL2, withConnections:gvL1, bottom:gvL2)
        cvM1toM2 = newConnectorView(myMechanism.cM1toM2, withConnections:gvM1, bottom:gvM2)
        cvM2toM3 = newConnectorView(myMechanism.cM2toM3, withConnections:gvM2, bottom:gvM3)
        cvN1toN2 = newConnectorView(myMechanism.cN1toN2, withConnections:gvN1, bottom:gvN2)
        cvP1toP2 = newConnectorView(myMechanism.cP1toP2, withConnections:gvP1, bottom:gvP2)
        
        
        // ---
        // Initialize View State
        // ---
        setCurrentState(.Default, phase: .Running)
    }

    func addSubView(view: ModelView) {
        views.append(view)
    }

    func newGearView(gear: Gear) -> GearView {
        let view = GearView(gear: gear)
        
        self.addSubView(view)
        return view
    }

    func newPointerView(component: DeviceComponent, shaftLength sLen: Float, shaftRadius sRad: Float, pointerLength pLen: Float, pointerWidth pWidth: Float) -> PointerView {
        let view = PointerView(component: component, shaftLength:sLen, shaftRadius:sRad, pointerLength:pLen, pointerWidth:pWidth)
        
        self.addSubView(view)
        return view
    }

    func newLunarPointerView(component: DeviceComponent, yearPointer pointer: PointerView, shaftLength sLen: Float, shaftRadius sRad: Float, pointerLength pLen: Float, pointerWidth pWidth: Float) -> LunarPointerView {
        let view = LunarPointerView(component: component, yearPointer:pointer, shaftLength:sLen, shaftRadius:sRad, pointerLength:pLen, pointerWidth:pWidth)
        
        self.addSubView(view)
        return view
    }

    func newConnectorView(connector: Connector, withConnections top: GearView, bottom: GearView) -> ConnectorView {
        let view = ConnectorView(connector: connector)

        view.setPositionFromConnections(top, bottom: bottom)
        self.addSubView(view)
        return view
    }

    func newPinAndSlotConnectorView(connector: PinAndSlotConnector, withConnections top: GearView, bottom: GearView) -> PinAndSlotConnectorView {
        let view = PinAndSlotConnectorView(connector: connector)

        view.setPositionFromConnections(top, bottom: bottom)
        self.addSubView(view)
        return view
    }

    func draw() {
        for view in views {
            view.draw()
        }
    }

    func setCurrentState(state: AMState, phase: AMStatePhase) {
        currentState = state
        currentStatePhase = phase
        
        for view in views {
            if view is AMViewStateHandler {
                (view as! AMViewStateHandler).updateWithState(currentState, phase: currentStatePhase)
            }
        }
    }

}
