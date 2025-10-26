//
//  Viewpoints.swift
//  AntikytheraOpenGLPrototype
//
//  Created by Juan J. Collas on 12/23/2015.
//
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

protocol CameraViewpoint {

    func updateViewpoint()

}

#if os(iOS)
protocol Touchable {

    func touchesBegan(_ touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesMoved(_ touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesEnded(_ touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesCancelled(_ touches: Set<UITouch>, withEvent event: UIEvent?)

}
#elseif os(macOS)
protocol Touchable {
    // macOS mouse/trackpad event handling would go here
    // For now, this is a placeholder for future implementation
}
#endif
