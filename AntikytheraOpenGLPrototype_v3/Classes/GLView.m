//
//  GLView.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 2/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "GLView.h"
#import "ConstantsAndMacros.h"
#import "AntikytheraOpenGLPrototype-Swift.h"

@interface GLView ()
@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;
- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;
@end

#pragma mark -

@implementation GLView

+ (Class)layerClass 
{
    return [CAEAGLLayer class];
}
- (id)initWithCoder:(NSCoder*)coder {
    
    if ((self = [super initWithCoder:coder])) {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = @{ kEAGLDrawablePropertyRetainedBacking: @NO,
                                          kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8 };
        
#if kAttemptToUseOpenGLES2
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        if (context == NULL)
        {
#endif
            self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
            
            if (!self.context || ![EAGLContext setCurrentContext:self.context]) {
                return nil;
            }
#if kAttemptToUseOpenGLES2
        }
#endif
        
        self.animationInterval = 1.0 / kRenderingFrequency;
    }
    return self;
}
- (void)drawView 
{
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    [self.delegate drawView:self];
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [self.context presentRenderbuffer:GL_RENDERBUFFER_OES];
}
- (void)layoutSubviews 
{
    [EAGLContext setCurrentContext:self.context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}
- (BOOL)createFramebuffer 
{
    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [self.context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) 
    {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) 
    {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
//    [self.delegate setupView:self];
    return YES;
}
- (void)destroyFramebuffer 
{
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) 
    {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}
- (void)startAnimation 
{
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:self.animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}
- (void)stopAnimation 
{
    self.animationTimer = nil;
}
- (void)setAnimationTimer:(NSTimer *)newTimer 
{
    [_animationTimer invalidate];
    _animationTimer = newTimer;
}
- (void)setAnimationInterval:(NSTimeInterval)interval
{
    _animationInterval = interval;
    if (self.animationTimer)
    {
        [self stopAnimation];
        [self startAnimation];
    }
}
- (void)dealloc 
{
    [self stopAnimation];
    
    if ([EAGLContext currentContext] == self.context)
        [EAGLContext setCurrentContext:nil];
}

@end
