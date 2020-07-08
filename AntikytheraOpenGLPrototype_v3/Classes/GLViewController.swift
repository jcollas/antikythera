//
//  GLViewController.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 2/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES

class GLViewController: UIViewController, GLViewDelegate, UIActionSheetDelegate {

    //This is the main device object that will be shown:
    var antikytheraMechanism: AntikytheraMechanism!
    var antikytheraMechanismView: AntikytheraMechanismView!
    
    var userDial: UserDialView!
    var dialMode = false

    var camera: CameraViewpoint!
    var touchDelegate: Touchable?

    func drawView(_ theView: UIView) {
        glLoadIdentity()
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GLenum(GL_COLOR_BUFFER_BIT) | GLenum(GL_DEPTH_BUFFER_BIT))
        //	glEnable(GL_DEPTH_TEST)
        //	glDisable(GL_CULL_FACE)
        
        camera.updateViewpoint()
        
        //	if (antikytheraMechanismView.currentState == .PinAndSlot) {
        //		[antikytheraMechanism rotate:0.1f]
        //	} else {
        //		[antikytheraMechanism rotate:2.0f]
        //	}
        
        antikytheraMechanismView.draw()
        
        pushOrthoMatrix()
        glPushMatrix()
        //	glTranslatef(self.view.bounds.size.width-160, 160, 0.0f)
        userDial.draw()
        glPopMatrix()
        popOrthoMatrix()
    }

    // UNUSED
    func setupView(_ theView: UIView) {
    
    }

    override func viewDidLoad() {
        let zNear: Float = 1.0, zFar: Float = 2000.0, fieldOfView: Float = 45.0

        glMatrixMode(GLenum(GL_PROJECTION))
        
        //let retinaScale = CGFloat(1.0)
        let retinaScale = UIScreen.main.scale
        let radians = (.pi * fieldOfView) / 180.0
        let size = zNear * Float(tanf(radians/2.0))
        let rect = self.view.bounds
        glFrustumf(Float(-size), Float(size), Float(-size/Float(rect.size.width/rect.size.height)),
                   Float(size/Float(rect.size.width/rect.size.height)), zNear, zFar)
        glViewport(0, 0, GLsizei(rect.size.width * retinaScale), GLsizei(rect.size.height * retinaScale))
        
        glMatrixMode(GLenum(GL_MODELVIEW))
        
        glEnable(GLenum(GL_LINE_SMOOTH))
        glHint(GLenum(GL_LINE_SMOOTH_HINT),GLenum(GL_DONT_CARE))
        
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA),GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        GLModel3D.enableGLModel3D()
        
        //	camera = FlyThroughCamera()
        //	camera = TopCamera()
        //  camera = ShowcaseCamera()
        //	camera = SideCamera()
        camera = UICamera(view: self.view)
        
        touchDelegate = camera as? Touchable
        

        // iterate over gears, connections
        
        antikytheraMechanism = AntikytheraMechanism(loadFromJsonFile: Bundle.main.url(forResource: "device", withExtension: "json")!)
        antikytheraMechanismView = AntikytheraMechanismView(mechanism: antikytheraMechanism)
        
        var dialRad = Float(self.view.bounds.size.width)/10.0
        if (dialRad < 40.0) {
            dialRad = 40.0
        }
        
        userDial = UserDialView(radius:dialRad, mechanism:antikytheraMechanism, view:self.view)
        userDial.color = Color3D(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        userDial.position = Vector3D(x: Float(self.view.bounds.size.width)-dialRad*2.0, y: dialRad*2.0, z: 0.0)
        dialMode = false
    }

    func pushOrthoMatrix() {
        glMatrixMode(GLenum(GL_PROJECTION))
        glPushMatrix()
        glLoadIdentity()
        glOrthof(0, Float(view.bounds.size.width), 0, Float(view.bounds.size.height), -5, 1)
        glMatrixMode(GLenum(GL_MODELVIEW))
        glLoadIdentity()
    }

    func popOrthoMatrix() {
        glMatrixMode(GLenum(GL_PROJECTION))
        glPopMatrix()
        glMatrixMode(GLenum(GL_MODELVIEW))
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let allTouches = event?.touches(for: self.view)
        
        if !dialMode && allTouches?.count == 1 {
            let touch = allTouches?.first
            let location = touch?.location(in: self.view)
            if userDial.hitTest(Vector3D(x: Float(location!.x), y: Float(self.view.bounds.size.height-location!.y), z: 0.0)) {
                userDial.color = Color3D(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.3)
                dialMode = true
                userDial.touchesBegan(touches, withEvent: event)
            } else {
                userDial.color = Color3D(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
                dialMode = false
            }
        }
        
        if !dialMode {
            touchDelegate?.touchesBegan(touches, withEvent:event)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event:UIEvent?) {
        if (dialMode) {
            userDial.touchesMoved(touches, withEvent:event)
        } else {
            touchDelegate?.touchesMoved(touches, withEvent:event)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event:UIEvent?) {
        let allTouches = event?.touches(for: self.view)
        
        if dialMode && allTouches?.count == 1 {
            dialMode = false
            userDial.color = Color3D(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
        } else if (!dialMode) {
            touchDelegate?.touchesEnded(touches, withEvent:event)
        }
        
        
        if (touches.first?.tapCount)! >= 2 {
            let alertController = UIAlertController(title: "Visualization mode", message: "", preferredStyle: .actionSheet)

            let pointersAction = UIAlertAction(title: "Pointers",
                                               style: .default) { action in
                                                self.antikytheraMechanismView.setCurrentState(.pointers, phase: .running)

            }
            let gearsAction = UIAlertAction(title: "Gears",
                                               style: .default) { action in
                                                self.antikytheraMechanismView.setCurrentState(.gears, phase: .running)

            }
            let boxAction = UIAlertAction(title: "Box",
                                               style: .default) { action in
                                                self.antikytheraMechanismView.setCurrentState(.box, phase: .running)

            }
            let pinSlotAction = UIAlertAction(title: "Pin and Slot",
                                               style: .default) { action in
                                                self.antikytheraMechanismView.setCurrentState(.pinAndSlot, phase: .running)

            }
            let defaultAction = UIAlertAction(title: "Default",
                                               style: .cancel) { action in
                                                self.antikytheraMechanismView.setCurrentState(.default, phase: .running)

            }
            alertController.addAction(pointersAction)
            alertController.addAction(gearsAction)
            alertController.addAction(boxAction)
            alertController.addAction(pinSlotAction)
            alertController.addAction(defaultAction)

            self.present(alertController,
                animated: true, completion: nil)
        }
        
    }

}
