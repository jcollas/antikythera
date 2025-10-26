//
//  UICamera.swift
//  Antikythera
//
//  Created by Matt Ricketson on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import Metal
import MetalKit

let kMIN_ZOOM: CGFloat = 20.0
let kMAX_ZOOM: CGFloat = 600.0

enum GestureType {
    case none
    case ambiguous
    case single
    case double
}

class UICamera: NSObject, CameraViewpoint, Touchable {
    #if os(iOS)
    let myView: UIView!
    #elseif os(macOS)
    let myView: NSView!
    #endif
    
    // Touch-handling
    var phiStart: CGFloat = -30.0
    var thetaStart: CGFloat = 30.0
    var phiAngle: CGFloat = 0.0
    var thetaAngle: CGFloat = 0.0

    var startDist: CGFloat = 200.0
    var distance: CGFloat = 0.0
    var center = Vertex3D.zero
    var panDiff = Vertex3D.zero
    var gestureStartPoint = CGPoint(x: 0.0, y: 0.0)
    var gestureStartDistance: CGFloat!
    var currentGesture: GestureType = .none

    #if os(iOS)
    init(view: UIView) {
        myView = view
        super.init()
    }
    #elseif os(macOS)
    init(view: NSView) {
        myView = view
        super.init()
    }
    #endif

    func updateViewpoint() {
        guard let renderer = MetalRenderContext.shared.renderer else { return }

        renderer.rotate(angle: -90, x: 1.0, y: 0.0, z: 0.0)
        renderer.translate(x: center.x + panDiff.x, y: center.y + panDiff.y, z: center.z + panDiff.z)
        renderer.translate(x: 0.0, y: Float(startDist + distance), z: 0.0)

        renderer.rotate(angle: -Float(phiStart + phiAngle), x: 1.0, y: 0.0, z: 0.0)
        renderer.rotate(angle: -Float(thetaStart + thetaAngle), x: 0.0, y: 0.0, z: 1.0)
    }

    #if os(iOS)
    func touchesBegan(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
        let allTouches = event?.touches(for: myView)
        //	NSLog(@"touchesBegan: Touches=%d TouchesForView=%d",[touches count],[allTouches count])
        
        saveViewChanges()
        
        switch allTouches!.count {
        
        case 1:
            currentGesture = .single
            let touch = allTouches!.first
            gestureStartPoint = touch!.location(in: myView)
            
        case 2:
            currentGesture = .double
            let locations = allTouches!.map { $0.location(in: myView) }
            let p1 = locations[0]
            let p2 = locations[1]
            
            let xsquared = Float((p2.x-p1.x)*(p2.x-p1.x))
            let ysquared = Float((p2.y-p1.y)*(p2.y-p1.y))
            gestureStartDistance = CGFloat(sqrtf(xsquared+ysquared))
            
            gestureStartPoint.x = (p1.x+p2.x)/2
            gestureStartPoint.y = (p1.y+p2.y)/2
            
        default:
            currentGesture = .none
        }
        
    }

    func touchesMoved(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
        let allTouches = event?.touches(for: myView)
        //	NSLog("touchesMoved: Touches=\(touches.count) TouchesForView=\(allTouches.count)")
        
        switch allTouches!.count {
            
        case 1:
            let touch = allTouches?.first
            let currentPosition = touch?.location(in: myView)
            
            let deltaX: CGFloat = (gestureStartPoint.x - currentPosition!.x)/2
            let deltaY: CGFloat = (gestureStartPoint.y - currentPosition!.y)/2
            if ((fabsf(Float(phiAngle-deltaY)) < 100)&&(fabsf(Float(thetaAngle-deltaX)) < 100)) {
                phiAngle = deltaY
                thetaAngle = deltaX
            }
            
        case 2:
            let locations = allTouches!.map { $0.location(in: myView) }
            let p1 = locations[0]
            let p2 = locations[1]
            
            let delta = hypotf(Float(p2.x-p1.x), Float(p2.y-p1.y))
            let deltaPos = CGPoint(x: gestureStartPoint.x - (p1.x+p2.x)/2,y: gestureStartPoint.y - (p1.y+p2.y)/2)
            
            panDiff = Vertex3D(x: Float(-deltaPos.x)/5.0, y: 0.0, z: Float(deltaPos.y)/5.0)
            
            distance = (gestureStartDistance - CGFloat(delta))
            if ((startDist+distance) < kMIN_ZOOM) {
                distance = kMIN_ZOOM - startDist
            } else if ((startDist+distance) > kMAX_ZOOM) {
                distance = kMAX_ZOOM - startDist
            }
                                           
        default:
            break
        }
    }

    func touchesEnded(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
        let allTouches = event?.touches(for: myView)
        NSLog("touchesEnded: Touches=%lu TouchesForView=%lu",touches.count, allTouches!.count)
        let activeTouches = allTouches!.count - touches.count
        
        saveViewChanges()
        
        switch activeTouches {
            
        case 1:
            currentGesture = .single
            let touch = touches.first
            gestureStartPoint = touch!.location(in: myView)
            
        default:
            currentGesture = .none
        }
    }

    func saveViewChanges() {
        phiStart += phiAngle
        thetaStart += thetaAngle
        phiAngle = 0.0
        thetaAngle = 0.0
        
        startDist += distance
        distance = 0
        
        center.x += panDiff.x
        center.z += panDiff.z
        panDiff = Vertex3D.zero
    }

    func touchesCancelled(_ touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
    #endif

}
