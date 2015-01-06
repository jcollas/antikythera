//
//  AntikytheraOpenGLPrototypeAppDelegate.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 2/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AntikytheraOpenGLPrototypeAppDelegate.h"
#import "GLView.h"
#import "ConstantsAndMacros.h"

@implementation AntikytheraOpenGLPrototypeAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	
	CGRect  rect = [[UIScreen mainScreen] bounds];
    [self.window setFrame:rect];
    
	self.glView.animationInterval = 1.0 / 60.0;
	[self.glView startAnimation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	self.glView.animationInterval = 1.0 / 60.0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	self.glView.animationInterval = 1.0 / 60.0;
}

@end
