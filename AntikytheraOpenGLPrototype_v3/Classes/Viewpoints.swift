//
//  Viewpoints.swift
//  AntikytheraOpenGLPrototype
//
//  Created by Juan J. Collas on 12/23/2015.
//
//

import Foundation

protocol CameraViewpoint2 {

    func updateViewpoint()

}

protocol Touchable2 {

    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent?)

}
