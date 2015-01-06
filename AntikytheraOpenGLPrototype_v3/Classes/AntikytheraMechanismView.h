//
//  AntikytheraMechanismView.h
//  AntikytheraOpenGLPrototype
//
//  created by Matt Ricvketson on 4/7/10.
//  copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceView.h"
#import "AntikytheraMechanism.h"
#import "GearView.h"
#import "ConnectorView.h"
#import "PinAndSlotConnectorView.h"
#import "PointerView.h"
#import "LunarPointerView.h"
#import "BoxView.h"

#import "AMViewStateHandler.h"


@interface AntikytheraMechanismView : NSObject <DeviceView> {
	AntikytheraMechanism *myMechanism;
	
	NSMutableArray *views;
	
	GearView	*gvA1, // 48
				*gvB0, // 20
				*gvB1, // 224
				*gvB2, // 64
				*gvB3, // 32
				*gvC1, // 38
				*gvC2, // 48
				*gvD1, // 24
				*gvD2, // 127
				*gvE1, // 32
				*gvE2, // 32
				*gvE3, // 223
				*gvE4, // 188
				*gvE5, // 50
				*gvE6, // 50
				*gvF1, // 53
				*gvF2, // 30
				*gvG1, // 54
				*gvG2, // 20
				*gvH1, // 60
				*gvH2, // 15
				*gvI1, // 60
				*gvK1, // 50
				*gvK2, // 50
				*gvL1, // 38
				*gvL2, // 53
				*gvM1, // 96
				*gvM2, // 15
				*gvM3, // 27
				*gvN1, // 53
				*gvN2, // 15
				*gvP1, // 60
				*gvP2, // 12
				*gvO1; // 60
	
	ConnectorView	*cvB1toB2,
					*cvB0toB3,
					*cvC1toC2,
					*cvD1toD2,
					*cvE1toE2,
					*cvE2toE5,
					*cvE3toE4,
					*cvE1toE6,
					*cvF1toF2,
					*cvG1toG2,
					*cvH1toH2,
					*cvL1toL2,
					*cvM1toM2,
					*cvM2toM3,
					*cvN1toN2,
					*cvP1toP2,
					*cvN2toMetonic;
	
	PinAndSlotConnectorView	*cvK1toK2;
	
	PointerView		*year,
					*metonic,
					*saros,
					*callippic,
					*exeligmos;
	
	LunarPointerView	*lunar;
	
	BoxView		*box;
}

@property (nonatomic,readonly) AMState currentState;
@property (nonatomic,readonly) AMStatePhase currentStatePhase;

- (id) initWithMechanism:(AntikytheraMechanism*)mechanism;

- (void) addSubView:(id<ModelView>)view;

- (void) setCurrentState:(AMState)state Phase:(AMStatePhase)phase;

- (GearView*) newGearView:(Gear*)gear;
- (PointerView*) newPointerView:(id<DeviceComponent>)component ShaftLength:(float)sLen ShaftRadius:(float)sRad PointerLength:(float)pLen PointerWidth:(float)pWidth;
- (LunarPointerView*) newLunarPointerView:(id<DeviceComponent>)component YearPointer:(PointerView*)pointer ShaftLength:(float)sLen ShaftRadius:(float)sRad PointerLength:(float)pLen PointerWidth:(float)pWidth;
- (ConnectorView*) newConnectorView:(Connector*)connector WithConnections:(GearView*)top Bottom:(GearView*)bottom;
- (PinAndSlotConnectorView*) newPinAndSlotConnectorView:(PinAndSlotConnector*)connector WithConnections:(GearView*)top Bottom:(GearView*)bottom;

@end