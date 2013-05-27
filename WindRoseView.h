//
//  WindRoseView.h
//  MusselWind
//
//  Created by Marcel Weiher on 21.11.09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import "MPWView.h"
#import "AccessorMacros.h"
@class WindSampleList;

@interface WindRoseView : MPWView {
	WindSampleList *observations;
	BOOL drawBackground;
	
	BOOL animating;
	NSTimer	*timer;
	int	currentObservation;
}


boolAccessor_h( drawBackground, setDrawBackground )

@end
