//
//  WindSampleList.h
//  MusselWind
//
//  Created by Marcel Weiher on 2/28/10.
//  Copyright 2010 Marcel Weiher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccessorMacros.h"

@class WindObservation;

@interface WindSampleList : NSObject {
	NSMutableArray	*samples;
	NSDate			*minDate,*maxDate;
}

-(void)addSample:(WindObservation*)sample;

-(NSUInteger)count;
-objectAtIndex:(NSUInteger)anIndex;
-sublistWithRange:(NSRange)aRange;
-lastObject;

objectAccessor_h( NSDate, minDate , setMinDate )
objectAccessor_h( NSDate, maxDate , setMaxDate )
-(float)relativeDateOffsetOfSamplePercent:(WindObservation*)sample;
-(void)addSamplesFromSampleList:(WindSampleList*)list;

+(NSDate*)startOfDayFromDate:(NSDate*)date;


@end
