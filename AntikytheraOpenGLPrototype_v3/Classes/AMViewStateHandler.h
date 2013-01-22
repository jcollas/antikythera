//
//  AMViewStateHandler.h
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	STATE_DEFAULT,
	STATE_POINTERS,
	STATE_GEARS,
	STATE_BOX,
	STATE_PIN_AND_SLOT
} AMState;

typedef enum {
	PHASE_START,
	PHASE_RUNNING,
	PHASE_END
} AMStatePhase;

@protocol AMViewStateHandler

- (void) updateWithState:(AMState)state Phase:(AMStatePhase)phase;

@end