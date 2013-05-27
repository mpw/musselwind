//
//  WindObservation.m
//  MusselWind
//
//  Created by Marcel Weiher on 11/5/09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import "WindObservation.h"
@implementation WindObservation

floatAccessor( speed , setSpeed )
floatAccessor( gust , setGust )
intAccessor( direction , setDirection )
objectAccessor( NSDate, date, setDate )


-(BOOL)isGood
{
	return speed >= 10 && speed < 15 && direction > 220 && direction < 330;
}

-(float)hue
{
	return (([self direction] + 75) % 360 ) / 360.0;
}

-(void)dealloc
{
	[date release];
	[super dealloc];
}

-description
{
	return [NSString stringWithFormat:@"Winds from %d at %g gusting %g at time %@",[self direction],[self speed],[self gust],[self date]];
}

@end
