//
//  GLViewController.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 2/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "GLViewController.h"
#import "ConstantsAndMacros.h"
#import "OpenGLCommon.h"
@implementation GLViewController

- (void)drawView:(UIView *)theView
{	
	glLoadIdentity();
	glClearColor(0.0, 0.0, 0.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//	glEnable(GL_DEPTH_TEST);
//	glDisable(GL_CULL_FACE);
	
	[camera updateViewpoint];
	
//	if (antikytheraMechanismView.currentState == STATE_PIN_AND_SLOT) {
//		[antikytheraMechanism rotate:0.1f];
//	} else {
//		[antikytheraMechanism rotate:2.0f];
//	}
	
	[antikytheraMechanismView draw];
	
	[self pushOrthoMatrix];
	glPushMatrix();
//	glTranslatef(self.view.bounds.size.width-160, 160, 0.0f);
	[userDial draw];
	glPopMatrix();
	[self popOrthoMatrix];
}

-(void)setupView:(GLView*)view
{
	const GLfloat zNear = 1.0, zFar = 2000.0, fieldOfView = 45.0; 
	GLfloat size;
	
	glMatrixMode(GL_PROJECTION);

	size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView)/2.0); 
	CGRect rect = view.bounds; 
	glFrustumf(-size, size, -size/(rect.size.width/rect.size.height), 
			   size/(rect.size.width/rect.size.height), zNear, zFar); 
	glViewport(0, 0, rect.size.width, rect.size.height);
	
	glMatrixMode(GL_MODELVIEW);
	
	glEnable(GL_LINE_SMOOTH);
	glHint(GL_LINE_SMOOTH_HINT,GL_DONT_CARE);
	
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	
	[GLModel3D enableGLModel3D];
	
//	camera = (id<CameraViewpoint>)[[FlyThroughCamera alloc] init];
//	camera = (id<CameraViewpoint>)[[TopCamera alloc] init];
//	camera = (id<CameraViewpoint>)[[ShowcaseCamera alloc] init];
//	camera = (id<CameraViewpoint>)[[SideCamera alloc] init];
	camera = (id<CameraViewpoint>)[[UICamera alloc] initWithView:self.view];
	
	if ([camera conformsToProtocol:@protocol(Touchable)]) {
		touchDelegate = (id<Touchable>)camera;
	} else {
		touchDelegate = nil;
	}

	antikytheraMechanism = [[AntikytheraMechanism alloc] init];
	[antikytheraMechanism buildDevice];
	
	antikytheraMechanismView = [[AntikytheraMechanismView alloc] initWithMechanism:antikytheraMechanism];
	[antikytheraMechanismView buildDeviceView];
	
	float dialRad = self.view.bounds.size.width/10.0f;
	if (dialRad < 40.0f) dialRad = 40.0f;
	
	userDial = [[UserDialView alloc] initWithRadius:dialRad Mechanism:antikytheraMechanism View:self.view];
	[userDial setColor:Color3DMake(1.0f, 1.0f, 1.0f, 0.5f)];
	[userDial setPosition:Vector3DMake(self.view.bounds.size.width-dialRad*2.0f, dialRad*2.0f, 0.0f)];
	dialMode = NO;
}

- (void) pushOrthoMatrix {
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();
    glOrthof(0, self.view.bounds.size.width, 0, self.view.bounds.size.height, -5, 1);       
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

- (void) popOrthoMatrix {
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();
    glMatrixMode(GL_MODELVIEW);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event touchesForView:self.view];
		
	if (!dialMode && [allTouches count] == 1) {
		NSEnumerator *enumerator = [allTouches objectEnumerator];
		UITouch *touch = (UITouch*)[enumerator nextObject];
		CGPoint location = [touch locationInView:self.view];
		if ([userDial hitTest:Vector3DMake(location.x,self.view.bounds.size.height-location.y,0.0f)]) {
			[userDial setColor:Color3DMake(1.0f, 0.0f, 0.0f, 0.3f)];
			dialMode = YES;
			[userDial touchesBegan:touches withEvent:event];
		} else {
			[userDial setColor:Color3DMake(1.0f, 1.0f, 1.0f, 0.3f)];
			dialMode = NO;
		}
	}
	
	if (!dialMode && touchDelegate != nil)
		[touchDelegate touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (dialMode) {
		[userDial touchesMoved:touches withEvent:event];
	} else {
		if (touchDelegate != nil) [touchDelegate touchesMoved:touches withEvent:event];
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event touchesForView:self.view];

	if (dialMode && [allTouches count] == 1) {
		dialMode = NO;
		[userDial setColor:Color3DMake(1.0f, 1.0f, 1.0f, 0.3f)];
	} else if (!dialMode) {
		if (touchDelegate != nil) [touchDelegate touchesEnded:touches withEvent:event];
	}

	
	if ([[touches anyObject] tapCount] >= 2) {
		NSString *button1,*button2,*button3,*button4,*cancelButton;
		button1 = NSLocalizedStringFromTable(@"Pointers", @"Localized", nil);
		button2 = NSLocalizedStringFromTable(@"Gears", @"Localized", nil);
		button3 = NSLocalizedStringFromTable(@"Box", @"Localized", nil);
		button4 = NSLocalizedStringFromTable(@"Pin and Slot", @"Localized", nil);
		cancelButton = NSLocalizedStringFromTable(@"Default", @"Localized", nil);
		
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"Visualization mode", @"Localized", nil)
														delegate:self cancelButtonTitle:cancelButton destructiveButtonTitle:nil
														otherButtonTitles:button1,button2,button3,button4,nil];
		actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		[actionSheet showInView:self.view.window];
		[actionSheet release];
	}

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0: // STATE_POINTERS
			[antikytheraMechanismView setCurrentState:STATE_POINTERS Phase:PHASE_RUNNING];
			break;
		case 1: // STATE_GEARS
			[antikytheraMechanismView setCurrentState:STATE_GEARS Phase:PHASE_RUNNING];
			break;
		case 2: // STATE_BOX
			[antikytheraMechanismView setCurrentState:STATE_BOX Phase:PHASE_RUNNING];
			break;
		case 3: // STATE_PIN_AND_SLOT
			[antikytheraMechanismView setCurrentState:STATE_PIN_AND_SLOT Phase:PHASE_RUNNING];
			break;
		default: // STATE_DEFAULT
			[antikytheraMechanismView setCurrentState:STATE_DEFAULT Phase:PHASE_RUNNING];
			break;
	}
}

- (void)dealloc
{
	[antikytheraMechanism release];
    [super dealloc];
}

@end
