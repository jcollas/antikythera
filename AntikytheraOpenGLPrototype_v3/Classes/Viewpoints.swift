//
//  Viewpoints.swift
//  AntikytheraOpenGLPrototype
//
//  Created by Juan J. Collas on 12/23/2015.
//
//

import UIKit

protocol CameraViewpoint {

    func updateViewpoint()

}

protocol Touchable {

    func touchesBegan(_ touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesMoved(_ touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesEnded(_ touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesCancelled(_ touches: Set<UITouch>, withEvent event: UIEvent?)

}
