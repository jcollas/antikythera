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

    func drawView(theView: UIView) {
        glLoadIdentity()
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GLenum(GL_COLOR_BUFFER_BIT) | GLenum(GL_DEPTH_BUFFER_BIT))
        //	glEnable(GL_DEPTH_TEST);
        //	glDisable(GL_CULL_FACE);
        
        camera.updateViewpoint()
        
        //	if (antikytheraMechanismView.currentState == STATE_PIN_AND_SLOT) {
        //		[antikytheraMechanism rotate:0.1f];
        //	} else {
        //		[antikytheraMechanism rotate:2.0f];
        //	}
        
        antikytheraMechanismView.draw()
        
        pushOrthoMatrix()
        glPushMatrix()
        //	glTranslatef(self.view.bounds.size.width-160, 160, 0.0f);
        userDial.draw()
        glPopMatrix()
        popOrthoMatrix()
    }

    // UNUSED
    func setupView(theView: UIView) {
    
    }

    override func viewDidLoad() {
        let zNear: Float = 1.0, zFar: Float = 2000.0, fieldOfView: Float = 45.0

        glMatrixMode(GLenum(GL_PROJECTION))
        
        let radians = (Float(M_PI) * fieldOfView) / 180.0
        let size = zNear * Float(tanf(radians/2.0))
        let rect = self.view.bounds
        glFrustumf(Float(-size), Float(size), Float(-size/Float(rect.size.width/rect.size.height)),
                   Float(size/Float(rect.size.width/rect.size.height)), zNear, zFar)
        glViewport(0, 0, GLsizei(rect.size.width), GLsizei(rect.size.height))
        
        glMatrixMode(GLenum(GL_MODELVIEW))
        
        glEnable(GLenum(GL_LINE_SMOOTH))
        glHint(GLenum(GL_LINE_SMOOTH_HINT),GLenum(GL_DONT_CARE))
        
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA),GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        GLModel3D.enableGLModel3D()
        
        //	camera = (id<CameraViewpoint>)[[FlyThroughCamera alloc] init];
        //	camera = (id<CameraViewpoint>)[[TopCamera alloc] init];
        //	camera = (id<CameraViewpoint>)[[ShowcaseCamera alloc] init];
        //	camera = (id<CameraViewpoint>)[[SideCamera alloc] init];
        camera = UICamera(view:self.view)
        
        if camera is Touchable {
            touchDelegate = camera as? Touchable
        } else {
            touchDelegate = nil
        }
        
        antikytheraMechanism = AntikytheraMechanism()
        antikytheraMechanism.buildDevice()
        
        antikytheraMechanismView = AntikytheraMechanismView(mechanism: antikytheraMechanism)
        antikytheraMechanismView.buildDeviceView()
        
        var dialRad = Float(self.view.bounds.size.width)/10.0
        if (dialRad < 40.0) {
            dialRad = 40.0
        }
        
        userDial = UserDialView(radius:dialRad, mechanism:antikytheraMechanism, view:self.view)
        userDial.setColor( Color3DMake(1.0, 1.0, 1.0, 0.5) )
        userDial.setPosition(Vertex3DMake(self.view.bounds.size.width-CGFloat(dialRad*2.0), CGFloat(dialRad*2.0), 0.0))
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

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let allTouches = event?.touchesForView(self.view)
        
        if !dialMode && allTouches?.count == 1 {
            let touch = allTouches?.first
            let location = touch?.locationInView(self.view)
            if userDial.hitTest(Vertex3DMake(location!.x,self.view.bounds.size.height-location!.y,0.0)) {
                userDial.setColor(Color3DMake(1.0, 0.0, 0.0, 0.3))
                dialMode = true
                userDial.touchesBegan(touches, withEvent: event)
            } else {
                userDial.setColor(Color3DMake(1.0, 1.0, 1.0, 0.3))
                dialMode = false
            }
        }
        
        if (!dialMode && touchDelegate != nil) {
            touchDelegate?.touchesBegan(touches, withEvent:event)
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event:UIEvent?) {
        if (dialMode) {
            userDial.touchesMoved(touches, withEvent:event)
        } else {
            if (touchDelegate != nil) {
                touchDelegate?.touchesMoved(touches, withEvent:event)
            }
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event:UIEvent?) {
        let allTouches = event?.touchesForView(self.view)
        
        if dialMode && allTouches?.count == 1 {
            dialMode = false
            userDial.setColor(Color3DMake(1.0, 1.0, 1.0, 0.3))
        } else if (!dialMode) {
            if (touchDelegate != nil) {
                touchDelegate?.touchesEnded(touches, withEvent:event)
            }
        }
        
        
        if touches.first?.tapCount >= 2 {
            let button1 = NSLocalizedString("Pointers", comment: "")
            let button2 = NSLocalizedString("Gears", comment:"")
            let button3 = NSLocalizedString("Box", comment:"")
            let button4 = NSLocalizedString("Pin and Slot", comment:"")
            let cancelButton = NSLocalizedString("Default", comment:"")
            
            let actionSheet = UIActionSheet(title:NSLocalizedString("Visualization mode", comment:""),
                                                                     delegate:self,
                                            cancelButtonTitle:cancelButton,
                                            destructiveButtonTitle: "",
                                                            otherButtonTitles:button1,button2,button3,button4)
            actionSheet.actionSheetStyle = .BlackTranslucent
            actionSheet.showInView(self.view.window!)
        }
        
    }

    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        switch (buttonIndex) {
            case 0: // STATE_POINTERS
                antikytheraMechanismView.setCurrentState(STATE_POINTERS, phase:PHASE_RUNNING)

            case 1: // STATE_GEARS
                antikytheraMechanismView.setCurrentState(STATE_GEARS, phase:PHASE_RUNNING)

            case 2: // STATE_BOX
                antikytheraMechanismView.setCurrentState(STATE_BOX, phase:PHASE_RUNNING)

            case 3: // STATE_PIN_AND_SLOT
                antikytheraMechanismView.setCurrentState(STATE_PIN_AND_SLOT, phase:PHASE_RUNNING)

            default: // STATE_DEFAULT
                antikytheraMechanismView.setCurrentState(STATE_DEFAULT, phase:PHASE_RUNNING)
        }
    }

}