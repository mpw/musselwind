//
//  HistoryDataParser.m
//  MusselWind
//
//  Created by Marcel Weiher on 15.11.09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import "HistoryDataParser.h"
#import "MPWMAXParser.h"
#import "WindObservation.h"
#import "WindObservationDrawing.h"

@implementation HistoryDataParser

idAccessor( delegate, setDelegate )

-(NSString*)dateFormatString
{
//	Fri, 26 February 2010 03:22:0 GMT
	return @"EEE, dd MMMM yyyy HH:mm:ss zzz";
}

-current_observationElement:children attributes:attrs parser:parser
{
	NSDateFormatter *formatter=[self dateConverter];
	WindObservation *observation=[[WindObservation alloc] init];
	[observation setGust:[[children objectForUniqueKey:@"wind_gust_mph"] floatValue]];
	[observation setSpeed:[[children objectForUniqueKey:@"wind_mph"] floatValue]];
	[observation setDirection:[[children objectForUniqueKey:@"wind_degrees"] intValue]];
	[observation setDate:[formatter dateFromString:[children objectForUniqueKey:@"observation_time_rfc822"]]];
	if ( [self delegate] ) {
		[[self delegate] addWindObservation:observation];
		observation=nil;
	} 
	return observation;
}

-valueElement:children attributes:attrs parser:parser
{
	return [[children lastObject] copy];
}

-day_observationsElement:children attributes:attrs parser:parser
{
	return [[children allValues] retain];
}

-(void)initializeParser
{
	[self setXmlparser:[MPWMAXParser parser]];
	[[self xmlparser] setHandler:self forElements:[NSArray arrayWithObjects:@"current_observation",@"day_observations",@"wind_degrees",@"wind_mph",@"wind_gust_mph",@"html",@"observation_time_rfc822",@"HTML",nil] inNamespace:nil prefix:@"" 
							 map:[NSDictionary dictionaryWithObjectsAndKeys:
								  @"value",@"wind_degrees",
								  @"value",@"wind_mph",
								  @"value",@"wind_gust_mph",
								  @"value",@"observation_time_rfc822",
								  nil]];
}


-(NSString*)baseURL
{
	return @"http://api.wunderground.com/weatherstation/WXDailyHistory.asp?ID=%@&format=XML";
//	return @"http://api.wunderground.com/weatherstation/WXDailyHistory.asp?ID=%@&format=XML&day=14&year=2009&month=6&graphspan=day";
}



@end

#import "DebugMacros.h"


@implementation HistoryDataParser(testing)


+(void)testWundergroundDataParse
{
	NSArray *observations=[self _observationsFromResource:@"historyData.xml"];
	INTEXPECT( [observations count], 230, @"number of observations");
	WindObservation *first=[observations objectAtIndex:1];
	EXPECTNOTNIL( [first date], @"date");
}

+(NSArray*)testSelectors
{
	return [NSArray arrayWithObjects:
				@"testWundergroundDataParse",
			nil];
}


@end
