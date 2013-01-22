//
//  AntikytheraMechanism.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MechanicalDevice.h"
#import "DeviceComponent.h"
#import "Connector.h"
#import "Gear.h"
#import "PinAndSlotConnector.h"


@interface AntikytheraMechanism : NSObject <MechanicalDevice> {
	Gear		*gA1, // 48
				*gB0, // 20
				*gB1, // 224
				*gB2, // 64
				*gB3, // 32
				*gC1, // 38
				*gC2, // 48
				*gD1, // 24
				*gD2, // 127
				*gE1, // 32
				*gE2, // 32
				*gE3, // 223
				*gE4, // 188
				*gE5, // 50
				*gE6, // 50
				*gF1, // 53
				*gF2, // 30
				*gG1, // 54
				*gG2, // 20
				*gH1, // 60
				*gH2, // 15
				*gI1, // 60
				*gK1, // 50
				*gK2, // 50
				*gL1, // 38
				*gL2, // 53
				*gM1, // 96
				*gM2, // 15
				*gM3, // 27
				*gN1, // 53
				*gN2, // 15
				*gP1, // 60
				*gP2, // 12
				*gO1; // 60
	
	Connector	*cB1toB2,
				*cB0toB3,
				*cC1toC2,
				*cD1toD2,
				*cE1toE2,
				*cE2toE5,
				*cE3toE4,
				*cE1toE6,
				*cF1toF2,
				*cG1toG2,
				*cH1toH2,
				*cL1toL2,
				*cM1toM2,
				*cM2toM3,
				*cN1toN2,
				*cP1toP2;
	
	PinAndSlotConnector	*cK1toK2;
}

@property (nonatomic,readonly) Gear			*gA1,*gB0,*gB1,*gB2,*gB3,
											*gC1,*gC2,*gD1,*gD2,*gE1,
											*gE2,*gE3,*gE4,*gE5,*gE6,
											*gF1,*gF2,*gG1,*gG2,*gH1,
											*gH2,*gI1,*gK1,*gK2,*gL1,
											*gL2,*gM1,*gM2,*gM3,*gN1,
											*gN2,*gP1,*gP2,*gO1;

@property (nonatomic,readonly) Connector	*cB1toB2,*cB0toB3,*cC1toC2,
											*cD1toD2,*cE1toE2,*cE2toE5,
											*cE3toE4,*cE1toE6,
											*cF1toF2,*cG1toG2,*cH1toH2,
											*cL1toL2,*cM1toM2,*cM2toM3,
											*cN1toN2,*cP1toP2;

@property (nonatomic,readonly) PinAndSlotConnector	*cK1toK2;

- (Gear*) newGearWithToothCount:(int)teeth;
- (Gear*) newGearWithToothCount:(int)teeth RadiusScale:(float)scale;
- (void) linkGear:(Gear*)gear1 With:(Gear*)gear2;
- (Connector*) newConnectorWithRadius:(float)radius Top:(id<DeviceComponent>)top  Bottom:(id<DeviceComponent>)bottom;
- (PinAndSlotConnector*) newPinAndSlotConnectorWithRadius:(float)radius Top:(Gear*)top  Bottom:(Gear*)bottom;

- (void) rotate:(float)arcAngle;

@end
