//
//  AntikytheraMechanismView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "AntikytheraMechanismView.h"


@implementation AntikytheraMechanismView

// Initializes view with specific mechanism
- (id) initWithMechanism:(AntikytheraMechanism*)mechanism {
	if (self = [super init]) {
		myMechanism = mechanism;
		
		views = [[NSMutableArray alloc] init];
	}
	
	return self;
}

// Protocol Methods:
- (void) buildDeviceView {
	const float dScale = 2.0;
	
	
	// ---
	// Initialize GearViews
	// ---
	gvA1 = [self newGearView:myMechanism.gA1];
	gvB0 = [self newGearView:myMechanism.gB0];
	gvB1 = [self newGearView:myMechanism.gB1];
	gvB2 = [self newGearView:myMechanism.gB2];
	gvB3 = [self newGearView:myMechanism.gB3];
	gvC1 = [self newGearView:myMechanism.gC1];
	gvC2 = [self newGearView:myMechanism.gC2];
	gvD1 = [self newGearView:myMechanism.gD1];
	gvD2 = [self newGearView:myMechanism.gD2];
	gvE1 = [self newGearView:myMechanism.gE1];
	gvE2 = [self newGearView:myMechanism.gE2];
	gvE3 = [self newGearView:myMechanism.gE3];
	gvE4 = [self newGearView:myMechanism.gE4];
	gvE5 = [self newGearView:myMechanism.gE5];
	gvE6 = [self newGearView:myMechanism.gE6];
	gvF1 = [self newGearView:myMechanism.gF1];
	gvF2 = [self newGearView:myMechanism.gF2];
	gvG1 = [self newGearView:myMechanism.gG1];
	gvG2 = [self newGearView:myMechanism.gG2];
	gvH1 = [self newGearView:myMechanism.gH1];
	gvH2 = [self newGearView:myMechanism.gH2];
	gvI1 = [self newGearView:myMechanism.gI1];
	gvK1 = [self newGearView:myMechanism.gK1];
	gvK2 = [self newGearView:myMechanism.gK2];
	gvL1 = [self newGearView:myMechanism.gL1];
	gvL2 = [self newGearView:myMechanism.gL2];
	gvM1 = [self newGearView:myMechanism.gM1];
	gvM2 = [self newGearView:myMechanism.gM2];
	gvM3 = [self newGearView:myMechanism.gM3];
	gvN1 = [self newGearView:myMechanism.gN1];
	gvN2 = [self newGearView:myMechanism.gN2];
	gvP1 = [self newGearView:myMechanism.gP1];
	gvP2 = [self newGearView:myMechanism.gP2];
	gvO1 = [self newGearView:myMechanism.gO1];
	
	
	// ---
	// Position & Format Components
	// ---
	[gvB0	setPosition:Vector3DMake(0.0f,0.0f,40.0f)];
	[gvB1	setPositionRelativeTo:gvB0 VerticalOffset:-5.0*dScale];
	[gvA1	setPositionRelativeTo:gvB1 AtAngle:(M_PI)];
	[gvB2	setPositionRelativeTo:gvB1 VerticalOffset:-5.0*dScale];
	[gvB3	setPositionRelativeTo:gvB2 VerticalOffset:-5.0*dScale];
	[gvC1	setPositionRelativeTo:gvB2 AtAngle:0.0];
	[gvC2	setPositionRelativeTo:gvC1 VerticalOffset:-5.0*dScale];
	[gvD1	setPositionRelativeTo:gvC2 AtAngle:0.0];
	[gvD2	setPositionRelativeTo:gvD1 VerticalOffset:-5.0*dScale];
	[gvE2	setPositionRelativeTo:gvD2 AtAngle:(M_PI+(M_PI/8.32))];
	[gvE5	setPositionRelativeTo:gvE2 VerticalOffset:-8.0*dScale];
	[gvE6	setPositionRelativeTo:gvE5 VerticalOffset:-2.0*dScale];
	[gvE1	setPositionRelativeTo:gvE2 VerticalOffset:5.0*dScale];
	[gvL1	setPositionRelativeTo:gvB2 AtAngle:(M_PI*1.237f)];
	[gvL2	setPositionRelativeTo:gvL1 VerticalOffset:-5.0*dScale];
	[gvM1	setPositionRelativeTo:gvL2 AtAngle:(M_PI*0.978f)];
	[gvM2	setPositionRelativeTo:gvM1 VerticalOffset:-8.0*dScale];
	[gvM3	setPositionRelativeTo:gvM2 VerticalOffset:-2.0*dScale];
	[gvE3	setPositionRelativeTo:gvM3 AtAngle:0.0];
	[gvE4	setPositionRelativeTo:gvE3 VerticalOffset:-1.0*dScale];
	[gvF1	setPositionRelativeTo:gvE4 AtAngle:-0.05];
	[gvF2	setPositionRelativeTo:gvF1 VerticalOffset:-3.0*dScale];
	[gvG1	setPositionRelativeTo:gvF2 AtAngle:(M_PI_2*0.9)];
	[gvG2	setPositionRelativeTo:gvG1 VerticalOffset:-3.0*dScale];
	[gvH1	setPositionRelativeTo:gvG2 AtAngle:(M_PI*0.7)];
	[gvH2	setPositionRelativeTo:gvH1 VerticalOffset:-3.0*dScale];
	[gvI1	setPositionRelativeTo:gvH2 AtAngle:(-M_PI_2*1.4)];
	[gvK1	setPositionRelativeTo:gvE5 AtAngle:0.0];
	[gvK2	setPositionRelativeTo:gvE6 AtAngle:0.0];
	[gvN1	setPositionRelativeTo:gvM2 AtAngle:(M_PI_2*1.55)];
	[gvN2	setPositionRelativeTo:gvN1 VerticalOffset:-5.0*dScale];
	[gvP1	setPositionRelativeTo:gvN2 AtAngle:(M_PI_2*-0.7f)];
	[gvP2	setPositionRelativeTo:gvP1 VerticalOffset:-5.0*dScale];
	[gvO1	setPositionRelativeTo:gvP2 AtAngle:(0.9f)];
	
	// ---
	// Initialize BoxView
	// ---
	box = (BoxView*)[[BoxView alloc] initWithWidth:100.0f Height:170.0f Length:35.0f];
	[self addSubView:box];
	[box setPosition:Vector3DMake(0.0f,0.0f,-2.0f)];
	[box setRotation:2.8f];
	
	
	// ---
	// Initialize PointerViews
	// ---
	int shaftLength;
	
	shaftLength = -4.0f*dScale;
	year = [self newPointerView:myMechanism.gB1 ShaftLength:shaftLength ShaftRadius:2.0f PointerLength:30.0f PointerWidth:1.0f];
	[year setPositionRelativeTo:gvB1 VerticalOffset:-shaftLength];
	
	shaftLength = -1.0f*dScale;
	lunar = [self newLunarPointerView:myMechanism.gB0 YearPointer:year ShaftLength:shaftLength ShaftRadius:1.0f PointerLength:25.0f PointerWidth:1.0f];
	[lunar setPositionRelativeTo:gvB0 VerticalOffset:-shaftLength];
	
	shaftLength = 14.0f*dScale;
	metonic = [self newPointerView:myMechanism.gN2 ShaftLength:shaftLength ShaftRadius:1.0f PointerLength:30.0f PointerWidth:1.0f];
	[metonic setPositionRelativeTo:gvN2 VerticalOffset:-shaftLength];
	
	shaftLength = 10.0f*dScale;
	saros = [self newPointerView:myMechanism.gG2 ShaftLength:shaftLength ShaftRadius:1.0f PointerLength:30.0f PointerWidth:1.0f];
	[saros setPositionRelativeTo:gvG2 VerticalOffset:-shaftLength];
	
	shaftLength = 8.0f*dScale;
	callippic = [self newPointerView:myMechanism.gO1 ShaftLength:shaftLength ShaftRadius:0.5f PointerLength:10.0f PointerWidth:0.5f];
	[callippic setPositionRelativeTo:gvO1 VerticalOffset:-shaftLength];
	
	shaftLength = 6.0f*dScale;
	exeligmos = [self newPointerView:myMechanism.gI1 ShaftLength:shaftLength ShaftRadius:0.5f PointerLength:10 PointerWidth:0.5f];
	[exeligmos setPositionRelativeTo:gvI1 VerticalOffset:-shaftLength];
	
	
	// ---
	// Initialize ConnectorViews
	// ---
	cvB1toB2 = [self newConnectorView:myMechanism.cB1toB2 WithConnections:gvB1 Bottom:gvB2];
	cvB0toB3 = [self newConnectorView:myMechanism.cB0toB3 WithConnections:gvB0 Bottom:gvB3];
	cvC1toC2 = [self newConnectorView:myMechanism.cC1toC2 WithConnections:gvC1 Bottom:gvC2];
	cvD1toD2 = [self newConnectorView:myMechanism.cD1toD2 WithConnections:gvD1 Bottom:gvD2];
	cvE1toE2 = [self newConnectorView:myMechanism.cE1toE2 WithConnections:gvE1 Bottom:gvE2];
	cvE2toE5 = [self newConnectorView:myMechanism.cE2toE5 WithConnections:gvE2 Bottom:gvE5];
	cvE3toE4 = [self newConnectorView:myMechanism.cE3toE4 WithConnections:gvE3 Bottom:gvE4];
	
	cvK1toK2 = [self newPinAndSlotConnectorView:myMechanism.cK1toK2 WithConnections:gvK1 Bottom:gvK2];
//	[gvE5 setAsPinAndSlotGear:YES]; [gvE6 setAsPinAndSlotGear:YES];
	[gvK1 setAsPinAndSlotGear:YES]; [gvK2 setAsPinAndSlotGear:YES];
	
	cvE1toE6 = [self newConnectorView:myMechanism.cE1toE6 WithConnections:gvE1 Bottom:gvE6];
	cvF1toF2 = [self newConnectorView:myMechanism.cF1toF2 WithConnections:gvF1 Bottom:gvF2];
	cvG1toG2 = [self newConnectorView:myMechanism.cG1toG2 WithConnections:gvG1 Bottom:gvG2];
	cvH1toH2 = [self newConnectorView:myMechanism.cH1toH2 WithConnections:gvH1 Bottom:gvH2];
	cvL1toL2 = [self newConnectorView:myMechanism.cL1toL2 WithConnections:gvL1 Bottom:gvL2];
	cvM1toM2 = [self newConnectorView:myMechanism.cM1toM2 WithConnections:gvM1 Bottom:gvM2];
	cvM2toM3 = [self newConnectorView:myMechanism.cM2toM3 WithConnections:gvM2 Bottom:gvM3];
	cvN1toN2 = [self newConnectorView:myMechanism.cN1toN2 WithConnections:gvN1 Bottom:gvN2];
	cvP1toP2 = [self newConnectorView:myMechanism.cP1toP2 WithConnections:gvP1 Bottom:gvP2];
	
	
	// ---
	// Initialize View State
	// ---
	[self setCurrentState:STATE_DEFAULT Phase:PHASE_RUNNING];
}

- (void) addSubView:(id<ModelView>)view { [views addObject:view]; }

- (GearView*) newGearView:(Gear*)gear {
	GearView *view = (GearView*)[[GearView alloc] initWithGear:gear];
	[self addSubView:view];
	return view;
}

- (PointerView*) newPointerView:(id<DeviceComponent>)component ShaftLength:(float)sLen ShaftRadius:(float)sRad PointerLength:(float)pLen PointerWidth:(float)pWidth {
	PointerView *view = (PointerView*)[[PointerView alloc] initWithComponent:component ShaftLength:sLen ShaftRadius:sRad PointerLength:pLen PointerWidth:pWidth];
	[self addSubView:view];
	return view;
}

- (LunarPointerView*) newLunarPointerView:(id<DeviceComponent>)component YearPointer:(PointerView*)pointer ShaftLength:(float)sLen ShaftRadius:(float)sRad PointerLength:(float)pLen PointerWidth:(float)pWidth {
	LunarPointerView *view = (LunarPointerView*)[[LunarPointerView alloc] initWithComponent:component YearPointer:pointer ShaftLength:sLen ShaftRadius:sRad PointerLength:pLen PointerWidth:pWidth];
	[self addSubView:view];
	return view;
}

- (ConnectorView*) newConnectorView:(Connector*)connector WithConnections:(GearView*)top Bottom:(GearView*)bottom {
	ConnectorView *view = (ConnectorView*)[[ConnectorView alloc] initWithConnector:connector];
	[view setPositionFromConnections:top Bottom:bottom];
	[self addSubView:view];
	return view;
}

- (PinAndSlotConnectorView*) newPinAndSlotConnectorView:(PinAndSlotConnector*)connector WithConnections:(GearView*)top Bottom:(GearView*)bottom {
	PinAndSlotConnectorView *view = (PinAndSlotConnectorView*)[[PinAndSlotConnectorView alloc] initWithConnector:connector];
	[view setPositionFromConnections:top Bottom:bottom];
	[self addSubView:view];
	return view;
}

- (void) draw {
	NSEnumerator *enumerator = [views objectEnumerator];
    id<ModelView> view;
	
    while ((view = [enumerator nextObject]) != nil) { [view draw]; }
}

- (void) setCurrentState:(AMState)state Phase:(AMStatePhase)phase {
	_currentState = state;
	_currentStatePhase = phase;
	
	NSEnumerator *enumerator = [views objectEnumerator];
    id view;
	
    while ((view = [enumerator nextObject]) != nil) {
		if ([(NSObject*)view conformsToProtocol:@protocol(AMViewStateHandler)]) {
			[(id<AMViewStateHandler>)view updateWithState:_currentState Phase:_currentStatePhase];
		}
	}
}

@end
