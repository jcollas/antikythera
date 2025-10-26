//
//  GLView.h
//  Antikythera
//
//  Created by Matt Ricketson on 2/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

import UIKit
import OpenGLES

@objc
protocol GLViewDelegate {

    func drawView(_ theView: UIView)
    func setupView(_ theView: UIView)

}

class GLView: UIView {
    
    var backingWidth: GLint = 0
    var backingHeight: GLint = 0
    
    var viewRenderbuffer: GLuint = 0
    var viewFramebuffer: GLuint = 0
    var depthRenderbuffer: GLuint = 0

    var animationInterval: TimeInterval!
    @IBOutlet weak var delegate: GLViewDelegate!
    var context: EAGLContext?
    var animationTimer: Timer? {
        willSet {
            animationTimer?.invalidate()
        }
    }

    override class var layerClass: AnyClass {
        return CAEAGLLayer.self
    }

    required init?(coder aCoder: NSCoder) {
        
        super.init(coder: aCoder)
        
        // Get the layer
        let eaglLayer = self.layer as! CAEAGLLayer
        
        eaglLayer.contentsScale = UIScreen.main.scale
        eaglLayer.isOpaque = true
        eaglLayer.drawableProperties = [ kEAGLDrawablePropertyRetainedBacking: false,
                                             kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8 ]
        
        context = /*EAGLContext(API: .OpenGLES2) ??*/ EAGLContext(api: .openGLES1)
        if self.context == nil || EAGLContext.setCurrent(self.context) == false {
            return nil
        }
        
        self.animationInterval = 1.0 / kRenderingFrequency
    }

    @objc func drawView() {
        glBindFramebufferOES(GLenum(GL_FRAMEBUFFER_OES), viewFramebuffer)
        self.delegate?.drawView(self)
        glBindRenderbufferOES(GLenum(GL_RENDERBUFFER_OES), viewRenderbuffer)
        self.context?.presentRenderbuffer(Int(GL_RENDERBUFFER_OES))
    }
    
    override func layoutSubviews() {
        EAGLContext.setCurrent(self.context)
        self.destroyFramebuffer()
        _ = self.createFramebuffer()
        self.drawView()
    }
    
    func createFramebuffer() -> Bool {
        glGenFramebuffersOES(1, &viewFramebuffer)
        glGenRenderbuffersOES(1, &viewRenderbuffer)
        
        glBindFramebufferOES(GLenum(GL_FRAMEBUFFER_OES), viewFramebuffer)
        glBindRenderbufferOES(GLenum(GL_RENDERBUFFER_OES), viewRenderbuffer)
        self.context?.renderbufferStorage(Int(GL_RENDERBUFFER_OES), from: self.layer as! CAEAGLLayer)
        glFramebufferRenderbufferOES(GLenum(GL_FRAMEBUFFER_OES), GLenum(GL_COLOR_ATTACHMENT0_OES), GLenum(GL_RENDERBUFFER_OES), viewRenderbuffer)
        
        glGetRenderbufferParameterivOES(GLenum(GL_RENDERBUFFER_OES), GLenum(GL_RENDERBUFFER_WIDTH_OES), &backingWidth)
        glGetRenderbufferParameterivOES(GLenum(GL_RENDERBUFFER_OES), GLenum(GL_RENDERBUFFER_HEIGHT_OES), &backingHeight)
        
        if USE_DEPTH_BUFFER == 1 {
            glGenRenderbuffersOES(1, &depthRenderbuffer)
            glBindRenderbufferOES(GLenum(GL_RENDERBUFFER_OES), depthRenderbuffer)

            let renderWidth = GLint( CGFloat(backingWidth) * UIScreen.main.scale)
            let renderHeight = GLint( CGFloat(backingHeight) * UIScreen.main.scale)
            glRenderbufferStorageOES(GLenum(GL_RENDERBUFFER_OES), GLenum(GL_DEPTH_COMPONENT16_OES), renderWidth, renderHeight)
            glFramebufferRenderbufferOES(GLenum(GL_FRAMEBUFFER_OES), GLenum(GL_DEPTH_ATTACHMENT_OES), GLenum(GL_RENDERBUFFER_OES), depthRenderbuffer)
        }
        
        if glCheckFramebufferStatusOES(GLenum(GL_FRAMEBUFFER_OES)) != GLenum(GL_FRAMEBUFFER_COMPLETE_OES) {
            NSLog("failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GLenum(GL_FRAMEBUFFER_OES)))
            return false
        }
        //    [self.delegate setupView:self]
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
        self.animationTimer = Timer.scheduledTimer(timeInterval: self.animationInterval, target: self, selector: #selector(GLView.drawView), userInfo: nil, repeats: true)
    }
    
    func stopAnimation() {
        self.animationTimer = nil
    }
    
    func setAnimationInterval(_ interval: TimeInterval) {
        animationInterval = interval
        if animationTimer != nil {
            stopAnimation()
            startAnimation()
        }
    }

    deinit {
        stopAnimation()
        
        if EAGLContext.current() == self.context {
            EAGLContext.setCurrent(nil)
        }
    }

}
