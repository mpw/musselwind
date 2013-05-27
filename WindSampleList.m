//
//  WindSampleList.m
//  MusselWind
//
//  Created by Marcel Weiher on 2/28/10.
//  Copyright 2010 Marcel Weiher. All rights reserved.
//

#import "WindSampleList.h"
#import "AccessorMacros.h"
#import "WindObservation.h"

@implementation WindSampleList

objectAccessor( NSMutableArray, samples, setSamples )
objectAccessor( NSDate, minDate , setMinDate )
objectAccessor( NSDate, maxDate , setMaxDate )

-(void)addSamplesFromArray:(NSArray *)sampleArray
{
	for ( WindObservation *observation in sampleArray ) {
		[self addSample:observation];
	}
}

-initWithArray:(NSArray*)sampleArray minDate:(NSDate*)newMin maxDate:(NSDate*)newMax
{
	self=[super init];
	[self setMaxDate:newMax];
	[self setMinDate:newMin];
	[self setSamples:[NSMutableArray array]];
	[self addSamplesFromArray:sampleArray];
	return self;
}

-initWithArray:(NSArray*)sampleArray
{
	return [self initWithArray:sampleArray minDate:nil maxDate:nil];
}

-init
{
	return [self initWithArray:nil];
}

-(void)addSamplesFromSampleList:(WindSampleList*)list
{
	[self addSamplesFromArray:[list samples]];
}

-(void)addSample:(WindObservation*)sample
{
	if ( (![self minDate] || [[sample date] timeIntervalSinceReferenceDate] >= [[self minDate] timeIntervalSinceReferenceDate] ) &&
		(![self maxDate] || [[sample date] timeIntervalSinceReferenceDate] <= [[self maxDate] timeIntervalSinceReferenceDate] )	)
	{
		for (int i=0;i<[self count];i++ ){
			if (   [[sample date] timeIntervalSinceReferenceDate] < [[[self objectAtIndex:i] date] timeIntervalSinceReferenceDate]  ) {
				[[self samples] insertObject:sample atIndex:i];
				return;
			}
		}
		[[self samples] addObject:sample];
	}
}

-(NSUInteger)count { return [[self samples] count]; }

-objectAtIndex:(NSUInteger)anIndex { return [[self samples] objectAtIndex:anIndex]; }
-lastObject { return [[self samples] lastObject]; }


-combinedObservations:other
{
	return [[[[self class] alloc] initWithArray:[[self samples] arrayByAddingObjectsFromArray:[other samples]] minDate:[self minDate] maxDate:[self maxDate]] autorelease];
}

-copyWithZone:(NSZone*)aZone
{
	return [[[self class] alloc] initWithArray:[[[self samples] copyWithZone:aZone] autorelease] minDate:[self minDate] maxDate:[self maxDate]];
}

-sublistWithRange:(NSRange)aRange
{
	return [[[[self class] alloc] initWithArray:[[self samples] subarrayWithRange:aRange]] autorelease];
}

-(float)relativeDateOffsetOfSamplePercent:(WindObservation*)sample
{
	NSTimeInterval minOffset=[[self minDate] timeIntervalSinceReferenceDate];
	NSTimeInterval maxOffset=[[self maxDate] timeIntervalSinceReferenceDate];
	NSTimeInterval secondsOffset=[[sample date] timeIntervalSinceReferenceDate]-minOffset;
	return 100* secondsOffset / ( maxOffset - minOffset );
}

+(NSDate*)startOfDayFromDate:(NSDate*)date
{
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
//	[gregorian setTimeZone:[date timeZone]];	
	NSDateComponents *startDay =
	[gregorian components:( NSYearCalendarUnit |  NSDayCalendarUnit | NSMonthCalendarUnit) fromDate:date];
	NSDate *startOfDay= [gregorian dateFromComponents:startDay];
	return startOfDay;
}

-(void)dealloc
{
	[samples release];
	[super dealloc];
}

-description
{
	return [NSString stringWithFormat:@"<%@:%p from: %@ to %@ samples: %@>",[self class],self,[self minDate],[self maxDate],[[self samples] description]];
}

@end

#import "DebugMacros.h"

@implementation WindSampleList(testing)

+(void)testMinMaxDateScaling
{
	WindSampleList *list=[[[WindSampleList alloc] init] autorelease];
	[list setMinDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0]];
	[list setMaxDate:[NSDate dateWithTimeIntervalSinceReferenceDate:3600]];
	WindObservation *sample=[[[WindObservation alloc] init] autorelease];
	[sample setDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0]];
	FLOATEXPECT( [list relativeDateOffsetOfSamplePercent:sample], 0.0, @"at zero" );
	[sample setDate:[NSDate dateWithTimeIntervalSinceReferenceDate:3600]];
	FLOATEXPECT( [list relativeDateOffsetOfSamplePercent:sample], 100.0, @"at max" );
	[sample setDate:[NSDate dateWithTimeIntervalSinceReferenceDate:1800]];
	FLOATEXPECT( [list relativeDateOffsetOfSamplePercent:sample], 50.0, @"in the middle" );
}

+(void)testDateRangeFiltering
{
	WindSampleList *list=[[[WindSampleList alloc] init] autorelease];
	[list setMinDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0]];
	[list setMaxDate:[NSDate dateWithTimeIntervalSinceReferenceDate:3600]];
	WindObservation *sample=[[[WindObservation alloc] init] autorelease];
	[sample setDate:[NSDate dateWithTimeIntervalSinceReferenceDate:1]];
	[list addSample:sample];
	INTEXPECT( [list count], 1, @"after adding an in-range sample" );
	sample=[[[WindObservation alloc] init] autorelease];
	[sample setDate:[NSDate dateWithTimeIntervalSinceReferenceDate:3700]];
	[list addSample:sample];
	INTEXPECT( [list count], 1, @"after adding an in-range sample" );
}

+(void)testStartOfDayFromDateInDay
{
 	INTEXPECT( (int)[[self startOfDayFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:1*3600]] timeIntervalSinceReferenceDate], 0 , @"start ");
	INTEXPECT( (int)[[self startOfDayFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:3600*37]] timeIntervalSinceReferenceDate], 24*3600 , @"next day ");
}

+testSelectors
{
	return [NSArray arrayWithObjects:
			@"testMinMaxDateScaling",
			@"testDateRangeFiltering",
			@"testStartOfDayFromDateInDay",
			nil];
}

@end
