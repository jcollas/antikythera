//
//  GLView.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 2/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@protocol GLViewDelegate
- (void)drawView:(UIView *)theView;
- (void)setupView:(UIView *)theView;
@end

@interface GLView : UIView 
{
    
@private

    GLint backingWidth;
    GLint backingHeight;
    
    GLuint viewRenderbuffer, viewFramebuffer;
    GLuint depthRenderbuffer;
}

@property (nonatomic) NSTimeInterval animationInterval;
@property (nonatomic, weak) /* weak ref */ IBOutlet id <GLViewDelegate> delegate;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView;
@end
