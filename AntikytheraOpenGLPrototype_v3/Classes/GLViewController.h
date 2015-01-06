//
//  GLViewController.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 2/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLView.h"

#import "CameraViewpoint.h"
#import "Touchable.h"
#import "FlyThroughCamera.h"
#import "TopCamera.h"
#import "ShowcaseCamera.h"
#import "SideCamera.h"
#import "UICamera.h"

#import "AntikytheraMechanism.h"
#import "AntikytheraMechanismView.h"
#import "UserDialView.h"

#import "GLModel3D.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

@class AntikytheraDevice;

@interface GLViewController : UIViewController <GLViewDelegate,UIActionSheetDelegate> {
	//This is the main device object that will be shown:
	AntikytheraMechanism *antikytheraMechanism;
	AntikytheraMechanismView *antikytheraMechanismView;
	
	UserDialView *userDial;
	BOOL dialMode;
    BOOL isSetup;
	
	id<CameraViewpoint> camera;
	id<Touchable> touchDelegate;
}

- (void) pushOrthoMatrix;
- (void) popOrthoMatrix;

@end
