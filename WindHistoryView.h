//
//  WindHistoryView.h
//  MusselWind
//
//  Created by Marcel Weiher on 11/5/09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AccessorMacros.h"
#import "MPWView.h"

@class WindSampleList;

@interface WindHistoryView : MPWView {
	WindSampleList	*history,*forecast;
}

objectAccessor_h( WindSampleList, history, setHistory )
objectAccessor_h( WindSampleList, forecast, setForecast )
-(int)maxPlottableObservations;
@end
