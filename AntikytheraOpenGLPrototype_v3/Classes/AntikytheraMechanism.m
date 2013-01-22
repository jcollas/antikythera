//
//  AntikytheraMechanism.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "AntikytheraMechanism.h"


@implementation AntikytheraMechanism

@synthesize	gA1,gB0,gB1,gB2,gB3,
				gC1,gC2,gD1,gD2,gE1,
				gE2,gE3,gE4,gE5,gE6,
				gF1,gF2,gG1,gG2,gH1,
				gH2,gI1,gK1,gK2,gL1,
				gL2,gM1,gM2,gM3,gN1,
				gN2,gP1,gP2,gO1;

@synthesize	cB1toB2,cB0toB3,cC1toC2,
				cD1toD2,cE1toE2,cE2toE5,
				cE3toE4,cK1toK2,cE1toE6,
				cF1toF2,cG1toG2,cH1toH2,
				cL1toL2,cM1toM2,cM2toM3,
				cN1toN2,cP1toP2;

// Protocol Methods:
- (void) buildDevice {
	// ---
	// Initialize Components
	// ---
	// Gears:
	gA1		= [self newGearWithToothCount:48];
	gB0		= [self newGearWithToothCount:20];
	gB1		= [self newGearWithToothCount:224];
	gB2		= [self newGearWithToothCount:64];
	gB3		= [self newGearWithToothCount:32];
	gC1		= [self newGearWithToothCount:38];
	gC2		= [self newGearWithToothCount:48];
	gD1		= [self newGearWithToothCount:24];
	gD2		= [self newGearWithToothCount:127];
	gE1		= [self newGearWithToothCount:32];
	gE2		= [self newGearWithToothCount:32];
	gE3		= [self newGearWithToothCount:223];
	gE4		= [self newGearWithToothCount:188];
	gE5		= [self newGearWithToothCount:50 RadiusScale:0.96f];
	gE6		= [self newGearWithToothCount:50];
	gF1		= [self newGearWithToothCount:53];
	gF2		= [self newGearWithToothCount:30];
	gG1		= [self newGearWithToothCount:54];
	gG2		= [self newGearWithToothCount:20];
	gH1		= [self newGearWithToothCount:60];
	gH2		= [self newGearWithToothCount:15];
	gI1		= [self newGearWithToothCount:60];
	gK1		= [self newGearWithToothCount:50 RadiusScale:0.96f];
	gK2		= [self newGearWithToothCount:50];
	gL1		= [self newGearWithToothCount:38];
	gL2		= [self newGearWithToothCount:53];
	gM1		= [self newGearWithToothCount:96];
	gM2		= [self newGearWithToothCount:15];
	gM3		= [self newGearWithToothCount:27];
	gN1		= [self newGearWithToothCount:53];
	gN2		= [self newGearWithToothCount:15];
	gP1		= [self newGearWithToothCount:60];
	gP2		= [self newGearWithToothCount:12];
	gO1		= [self newGearWithToothCount:60];
	
	
	
	// ---
	// Link Gears to Their Direct Neighbors
	// ---
	// Gears:
	[self linkGear:gA1 With:gB1];
	[self linkGear:gB2 With:gC1];
	[self linkGear:gB2 With:gL1];
	[self linkGear:gB3 With:gE1];
	[self linkGear:gC2 With:gD1];
	[self linkGear:gE2 With:gD2];
	[self linkGear:gE3 With:gM3];
	[self linkGear:gE4 With:gF1];
	[self linkGear:gE5 With:gK1];
	[self linkGear:gE6 With:gK2];
	[self linkGear:gF2 With:gG1];
	[self linkGear:gH1 With:gG2];
	[self linkGear:gI1 With:gH2];
	[self linkGear:gL2 With:gM1];
	[self linkGear:gM2 With:gN1];
	[self linkGear:gN2 With:gP1];
	[self linkGear:gP2 With:gO1];
	
	
	
	// ---
	// Connect Gear Groups Together
	// ---
	cB0toB3	= [self newConnectorWithRadius:1.0f Top:gB0 Bottom:gB3];
	cB1toB2	= [self newConnectorWithRadius:2.0f Top:gB1 Bottom:gB2];
	cC1toC2	= [self newConnectorWithRadius:1.0f Top:gC1 Bottom:gC2];
	cD1toD2	= [self newConnectorWithRadius:1.0f Top:gD1 Bottom:gD2];
	cE1toE6	= [self newConnectorWithRadius:1.0f Top:gE1 Bottom:gE6];
	cE2toE5	= [self newConnectorWithRadius:2.0f Top:gE2 Bottom:gE5];
	cE3toE4	= [self newConnectorWithRadius:1.0f Top:gE3 Bottom:gE4];
	cF1toF2	= [self newConnectorWithRadius:1.0f Top:gF1 Bottom:gF2];
	cG1toG2	= [self newConnectorWithRadius:1.0f Top:gG1 Bottom:gG2];
	cH1toH2	= [self newConnectorWithRadius:1.0f Top:gH1 Bottom:gH2];
	cK1toK2	= [self newPinAndSlotConnectorWithRadius:0.5f Top:gK1 Bottom:gK2];	
	cL1toL2	= [self newConnectorWithRadius:1.0f Top:gL1 Bottom:gL2];
	cM1toM2	= [self newConnectorWithRadius:1.0f Top:gM1 Bottom:gM2];
	cM2toM3	= [self newConnectorWithRadius:1.0f Top:gM2 Bottom:gM3];
	cN1toN2	= [self newConnectorWithRadius:1.0f Top:gN1 Bottom:gN2];
	cP1toP2	= [self newConnectorWithRadius:1.0f Top:gP1 Bottom:gP2];
	
}

// Initialize new gear with specific tooth count
- (Gear*) newGearWithToothCount:(int)teeth {
	Gear *gear = (Gear*)[[Gear alloc] initWithToothCount:teeth];
	return gear;
}
- (Gear*) newGearWithToothCount:(int)teeth RadiusScale:(float)scale {
	Gear *gear = (Gear*)[[Gear alloc] initWithToothCount:teeth RadiusScale:scale];
	return gear;
}

// Link gears together (set them as mutual neighbors)
- (void) linkGear:(Gear*)gear1 With:(Gear*)gear2 {
	[gear1 addNeighbor:gear2];
	[gear2 addNeighbor:gear1];
}

// Initialize new connecter with specific radius and default connections
- (Connector*) newConnectorWithRadius:(float)radius Top:(id<DeviceComponent>)top  Bottom:(id<DeviceComponent>)bottom {
	Connector *connector = (Connector*)[[Connector alloc] initWithRadius:radius];
	
	// If connecting gears, make sure the gears are aware
	if ([top isKindOfClass:[Gear class]])
		[(Gear*)top addNeighbor:connector];
	if ([bottom isKindOfClass:[Gear class]])
		[(Gear*)bottom addNeighbor:connector];
	
	[connector setConnections:top Bottom:bottom];
	return connector;
}
- (PinAndSlotConnector*) newPinAndSlotConnectorWithRadius:(float)radius Top:(Gear*)top  Bottom:(Gear*)bottom {
	float aOffset,pOffset;
	PinAndSlotConnector *connector;
	
	aOffset = ([bottom getRadius]*2) - ([top getRadius]*2);
	pOffset = [top getRadius]*0.7f;
	
	connector = (PinAndSlotConnector*)[[PinAndSlotConnector alloc] initWithRadius:radius ArborOffset:aOffset PinOffset:pOffset];
	
	[top addNeighbor:connector];
	[bottom addNeighbor:connector];
	
	[connector setConnections:top Bottom:bottom];
	
	return connector;
}

// Rotate input gear
- (void) rotate:(float)arcAngle {
//	[gA1 updateRotation:arcAngle FromSource:nil];
	[gA1 rotate:arcAngle];
}

@end
