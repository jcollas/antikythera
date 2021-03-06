//
//  UICamera.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

import UIKit
import OpenGLES

let kMIN_ZOOM: CGFloat = 20.0
let kMAX_ZOOM: CGFloat = 600.0

enum GestureType {
    case none
    case ambiguous
    case single
    case double
}

class UICamera: NSObject, CameraViewpoint, Touchable {
    let  myView: UIView!
    
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

    init(view: UIView) {
        
        myView = view

        super.init()        
    }

    func updateViewpoint() {
        glRotatef(-90, 1.0, 0.0, 0.0)
        glTranslatef(center.x+panDiff.x,center.y+panDiff.y,center.z+panDiff.z)
        glTranslatef(0.0, GLfloat(startDist+distance), 0.0)
        
        glRotatef(-GLfloat(phiStart+phiAngle), 1.0, 0.0, 0.0)
        glRotatef(-GLfloat(thetaStart+thetaAngle), 0.0, 0.0, 1.0)
    }

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

}
