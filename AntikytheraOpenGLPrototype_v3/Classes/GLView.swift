//
//  GLView.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 2/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

import UIKit
import OpenGLES

@objc
protocol GLViewDelegate {

    func drawView(theView: UIView)
    func setupView(theView: UIView)

}

class GLView: UIView {
    
    var backingWidth: GLint = 0
    var backingHeight: GLint = 0
    
    var viewRenderbuffer: GLuint = 0
    var viewFramebuffer: GLuint = 0
    var depthRenderbuffer: GLuint = 0

    var animationInterval: NSTimeInterval!
    @IBOutlet weak var delegate: GLViewDelegate!
    var context: EAGLContext?
    var animationTimer: NSTimer? {
        willSet {
            animationTimer?.invalidate()
        }
    }

    override class func layerClass() -> AnyClass {
        return CAEAGLLayer.self
    }

    required init?(coder aCoder: NSCoder) {
        
        super.init(coder: aCoder)
        
        // Get the layer
        let eaglLayer = self.layer as! CAEAGLLayer
        
        eaglLayer.opaque = true
        eaglLayer.drawableProperties = [ kEAGLDrawablePropertyRetainedBacking: false,
                                             kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8 ]
        
        context = /*EAGLContext(API: .OpenGLES2) ??*/ EAGLContext(API: .OpenGLES1)
        if self.context == nil || EAGLContext.setCurrentContext(self.context) == false {
            return nil
        }
        
        self.animationInterval = 1.0 / kRenderingFrequency
    }

    func drawView() {
        glBindFramebufferOES(GLenum(GL_FRAMEBUFFER_OES), viewFramebuffer)
        self.delegate?.drawView(self)
        glBindRenderbufferOES(GLenum(GL_RENDERBUFFER_OES), viewRenderbuffer)
        self.context?.presentRenderbuffer(Int(GL_RENDERBUFFER_OES))
    }
    
    override func layoutSubviews() {
        EAGLContext.setCurrentContext(self.context)
        self.destroyFramebuffer()
        self.createFramebuffer()
        self.drawView()
    }
    
    func createFramebuffer() -> Bool {
        glGenFramebuffersOES(1, &viewFramebuffer)
        glGenRenderbuffersOES(1, &viewRenderbuffer)
        
        glBindFramebufferOES(GLenum(GL_FRAMEBUFFER_OES), viewFramebuffer)
        glBindRenderbufferOES(GLenum(GL_RENDERBUFFER_OES), viewRenderbuffer)
        self.context?.renderbufferStorage(Int(GL_RENDERBUFFER_OES), fromDrawable: self.layer as! CAEAGLLayer)
        glFramebufferRenderbufferOES(GLenum(GL_FRAMEBUFFER_OES), GLenum(GL_COLOR_ATTACHMENT0_OES), GLenum(GL_RENDERBUFFER_OES), viewRenderbuffer)
        
        glGetRenderbufferParameterivOES(GLenum(GL_RENDERBUFFER_OES), GLenum(GL_RENDERBUFFER_WIDTH_OES), &backingWidth)
        glGetRenderbufferParameterivOES(GLenum(GL_RENDERBUFFER_OES), GLenum(GL_RENDERBUFFER_HEIGHT_OES), &backingHeight)
        
        if USE_DEPTH_BUFFER == 1 {
            glGenRenderbuffersOES(1, &depthRenderbuffer)
            glBindRenderbufferOES(GLenum(GL_RENDERBUFFER_OES), depthRenderbuffer);
            glRenderbufferStorageOES(GLenum(GL_RENDERBUFFER_OES), GLenum(GL_DEPTH_COMPONENT16_OES), backingWidth, backingHeight)
            glFramebufferRenderbufferOES(GLenum(GL_FRAMEBUFFER_OES), GLenum(GL_DEPTH_ATTACHMENT_OES), GLenum(GL_RENDERBUFFER_OES), depthRenderbuffer)
        }
        
        if glCheckFramebufferStatusOES(GLenum(GL_FRAMEBUFFER_OES)) != GLenum(GL_FRAMEBUFFER_COMPLETE_OES) {
            NSLog("failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GLenum(GL_FRAMEBUFFER_OES)))
            return false
        }
        //    [self.delegate setupView:self];
        return true
    }
    
    func destroyFramebuffer() {
        glDeleteFramebuffersOES(1, &viewFramebuffer)
        viewFramebuffer = 0
        glDeleteRenderbuffersOES(1, &viewRenderbuffer)
        viewRenderbuffer = 0
        
        if(depthRenderbuffer != 0) {
            glDeleteRenderbuffersOES(1, &depthRenderbuffer)
            depthRenderbuffer = 0
        }
    }
    
    func startAnimation() {
        self.animationTimer = NSTimer.scheduledTimerWithTimeInterval(self.animationInterval, target:self, selector:"drawView", userInfo:nil, repeats:true)
    }
    
    func stopAnimation() {
        self.animationTimer = nil
    }
    
    func setAnimationInterval(interval: NSTimeInterval) {
        animationInterval = interval
        if animationTimer != nil {
            stopAnimation()
            startAnimation()
        }
    }

    deinit {
        stopAnimation()
        
        if EAGLContext.currentContext() == self.context {
            EAGLContext.setCurrentContext(nil)
        }
    }

}
