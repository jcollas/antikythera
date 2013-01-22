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

@synthesize window;
@synthesize glView;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	
	CGRect  rect = [[UIScreen mainScreen] bounds];
    [window setFrame:rect];
    
	glView.animationInterval = 1.0 / 60.0;
	[glView startAnimation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	glView.animationInterval = 1.0 / 60.0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	glView.animationInterval = 1.0 / 60.0;
}


- (void)dealloc {
	[window release];
	[glView release];
	[super dealloc];
}

@end
