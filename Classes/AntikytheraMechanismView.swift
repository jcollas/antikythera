//
//  AntikytheraMechanismView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import Foundation

let kDepthScale: Float = 2.0

class AntikytheraMechanismView: NSObject, DeviceView {
    var myMechanism: AntikytheraMechanism!
    
    var views: [ModelView] = []
    
    // we don't use these dictionaries after creating them, but the old code kept them around so we will too
    var gearViewsByName = [String:GearView]()
    var connectorViewsByName = [String:ComponentView]()
    var pointersByName = [String : PointerView]()
    
    var box: BoxView!

    var currentState: AMState = .default
    var currentStatePhase: AMStatePhase = .running

    // Initializes view with specific mechanism
    init(mechanism: AntikytheraMechanism) {
        super.init()
		myMechanism = mechanism
        
        buildDeviceView()
    }

    // Protocol Methods:
    func buildDeviceView() {
        
        // ---
        // Initialize GearViews
        // ---
        for gear in myMechanism.gears {
            let gearView = GearView(gear: gear)
            self.gearViewsByName[gear.name] = gearView
            self.addSubView(gearView)
        }
        
        // ---
        // Position & Format Components
        // ---
        
        // NOTE: we must sort the gears so that placments are in order
        //      - that is; the gears must be placed *after* the gear they are relative to!
        let gearsInPlacementOrder = myMechanism.sortGearsForPlacementOrder()
        for gear in gearsInPlacementOrder {
            let gearView = gearViewsByName[gear.name]!
            gearView.setPosition(info: gear.placementInfo, allGearViews: gearViewsByName)
        }
        

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
        for pointerInfo in myMechanism.pointers {
            let (pointerView, pointerName) = try! PointerView.makePointerView(info: pointerInfo, allGears: myMechanism.gearsByName, allGearViews: self.gearViewsByName, allPointers: self.pointersByName)
            self.pointersByName[pointerName] = pointerView
            self.addSubView(pointerView)
        }
        
        // ---
        // Initialize ConnectorViews
        // ---
        
        for connector in myMechanism.connectors {
            
            // get the gear views related to this connector
            let topGearView = self.gearViewsByName[ connector.topComponent!.name ]!
            let bottomGearView = self.gearViewsByName[ connector.bottomComponent!.name ]!
            
            // create the connector view itself
            if let pinAndSlotConnector =  connector as? PinAndSlotConnector {
                // this is a pin-and-slot connector, which has a special view
                let connectorView = newPinAndSlotConnectorView(pinAndSlotConnector, withConnections:topGearView, bottom:bottomGearView)
                // also, let the gear views know they're in a pin-and-slot arrangement
                topGearView.setAsPinAndSlotGear(true)
                bottomGearView.setAsPinAndSlotGear(true)
                
                self.connectorViewsByName[connector.name] = connectorView

            } else {
                // this is a regular connector
                let connectorView = newConnectorView(connector, withConnections: topGearView, bottom: bottomGearView)
                self.connectorViewsByName[connector.name] = connectorView
            }
        }

        
        // ---
        // Initialize View State
        // ---
        setCurrentState(.default, phase: .running)
    }

    func addSubView(_ view: ModelView) {
        views.append(view)
    }

    func newConnectorView(_ connector: Connector, withConnections top: GearView, bottom: GearView) -> ConnectorView {
        let view = ConnectorView(connector: connector)

        view.setPositionFromConnections(top, bottom: bottom)
        self.addSubView(view)
        return view
    }

    func newPinAndSlotConnectorView(_ connector: PinAndSlotConnector, withConnections top: GearView, bottom: GearView) -> PinAndSlotConnectorView {
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

    func setCurrentState(_ state: AMState, phase: AMStatePhase) {
        currentState = state
        currentStatePhase = phase
        
        for view in views {
            if view is AMViewStateHandler {
                (view as! AMViewStateHandler).updateWithState(currentState, phase: currentStatePhase)
            }
        }
    }

}
