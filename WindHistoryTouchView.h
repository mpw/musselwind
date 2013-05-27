//
//  WindHistoryTouchView.h
//  MusselWind
//
//  Created by Marcel Weiher on 11/15/09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//


#import "MPWView.h"
#import "AccessorMacros.h"

@class WindSampleList;

@interface WindHistoryTouchView : MPWView {
	WindSampleList	*history,*forecast;
	NSArray *labels;
	int		numSubdivisions;
}

objectAccessor_h( WindSampleList, history, setHistory )
objectAccessor_h( WindSampleList, forecast, setForecast )
objectAccessor_h( NSArray, labels, setLabels )
-(int)maxPlottableObservations;

@end
