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
    var gears = [Gear]()
    var gearsByName = [String:Gear]()
    // Connectors
    var connectors = [Connector]()
    var connectorsByName = [String:Connector]()
    // Pointer indicators (another array of dictionaries)
    var pointers: [ [String:AnyObject] ]!
    
    init(loadFromJsonFile: URL) {
        super.init()
        do {
            let mechanismData = try Data(contentsOf: loadFromJsonFile )
            if let mechanismDict = try JSONSerialization.jsonObject(with: mechanismData) as? [String:AnyObject] {
                
                // load all the gears
                if let gearsArray = mechanismDict["gears"] as? [AnyObject] {
                    for gearObj in gearsArray {
                        if let gearDict = gearObj as? [String:AnyObject] {
                            let gear = Gear(dict: gearDict)
                            self.gears.append(gear)
                            self.gearsByName[gear.name] = gear
                        }
                    }
                }
                
                // connect the gears
                // (for each gear: get the names of the other gear(s) it should be linked to, resolve it, and connect them)
                for connectGearFrom in self.gears {
                    for connectToName in connectGearFrom.linkedTo {
                        if let connectGearTo = self.gearsByName[connectToName] {
                            // success, these to gears should be linked!
                            self.linkGear(connectGearFrom, with: connectGearTo)
                        } else {
                            // ERROR!  couldn't find that link-to gear!
                            print("ERROR!  Couldn't find gear named '\(connectToName)' (linked to by gear '\(connectGearFrom.name)')")
                            
                        }
                    }
                }
                
                // load all the connectors
                if let connectorsArray = mechanismDict["connectors"] as? [AnyObject] {
                    for connectorObj in connectorsArray {
                        if let connectorDict = connectorObj as? [String:AnyObject] {
                            let connector = try! Connector.makeConnectorFromDictionary(connectorDict, allGears: self.gearsByName)
                            self.connectorsByName[connector.name] = connector
                            self.connectors.append(connector)
                        }
                    }
                }
                
                // load the pointers
                if let pointers = mechanismDict["pointers"] as? [ [String:AnyObject] ] {
                    self.pointers = pointers
                }
                
                
            }
        } catch {
            
        }

        buildDevice()
    }

    // Protocol Methods:
    func buildDevice() {

    }

    // Link gears together (set them as mutual neighbors)
    func linkGear(_ gear1: Gear, with gear2: Gear) {
        gear1.addNeighbor(gear2)
        gear2.addNeighbor(gear1)
    }
    
    // sort the gears based on their ordering
    // (ie., so gears come after the one they are relative-to!)
    func sortGearsForPlacementOrder() -> [Gear] {
        // first pass, apply pla
        var gearsSortedByPlacementOrder = [Gear]()
        var gearsToPlace = [Gear]( self.gears )
        var gearsPlaced = Set<String>()
        repeat {
            for (idx, gear) in gearsToPlace.enumerated() {
                
                if let toGearName = gear.placementInfo["toGear"] as? String {
                    if gearsPlaced.contains(toGearName) {
                        // the current gear is relative to a gear that's already been accepted
                        // so it's okay to add it too!
                        gearsToPlace.remove(at: idx)
                        gearsSortedByPlacementOrder.append(gear)
                        gearsPlaced.insert(gear.name)
                        // we've changed gearsToPlace, so we must start over
                        break
                    }
                } else {
                    //
                    gearsToPlace.remove(at: idx)
                    gearsSortedByPlacementOrder.append(gear)
                    gearsPlaced.insert(gear.name)
                    // we've changed gearsToPlace, so we must start over
                    break
                }
            }
        } while gearsToPlace.count > 0
        
        // gears, sorted by placement priority
        return gearsSortedByPlacementOrder
        

    }


    // Rotate input gear
    func rotate(_ arcAngle: Float) {
        //	[gA1 updateRotation:arcAngle FromSource:nil];
        self.gearsByName["gA1"]!.rotate(arcAngle)
    }

}
