//
//  StationDataParser.m
//  MusselWind
//
//  Created by Marcel Weiher on 15.11.09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import "StationDataParser.h"
#import <Foundation/Foundation.h>
#import "MPWMAXParser.h"
#import "WindObservation.h"


@implementation StationDataParser

objectAccessor( NSString, webcamURL, setWebcamURL )

-(NSString*)dateFormatString
{
	return @"yyyy-MM-dd HH:mm:ss";
}

-(NSDateFormatter*)dateConverter
{
	NSDateFormatter *formatter=[super dateConverter];
	[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	return formatter;

}

-valueElement:children attributes:attributes parser:(MPWMAXParser*)aParser
{
	return [[attributes objectForKey:@"val"] retain];
}

-stationElement:children attributes:attributes parser:(MPWMAXParser*)aParser
{
	NSDateFormatter *formatter=[self dateConverter];
	WindObservation *observation=[[[WindObservation alloc] init] autorelease];
	[observation setGust:[[children objectForUniqueKey:@"windgustmph"] floatValue]];
	[observation setSpeed:[[children objectForUniqueKey:@"windspeedmph"] floatValue]];
	[observation setDirection:[[children objectForUniqueKey:@"winddir"] intValue]];
	[observation setDate:[formatter dateFromString:[children objectForUniqueKey:@"dateutc"]]];
	[self setWebcamURL:[children objectForUniqueKey:@"CAM"]];
	return [[NSArray alloc] initWithObjects:observation,nil];
}

-condsElement:children attributes:attributes parser:(MPWMAXParser*)aParser
{
	return [[children objectForKey:[self stationId]] retain];
}


-(void)initializeParser
{
	[self setXmlparser:[MPWMAXParser parser]];
	//	[parser setHandler:self forElements:[NSArray arrayWithObjects:@"current_observation",@"html",@"HTML",nil] inNamespace:nil prefix:@"" map:nil];
	[[self xmlparser] setHandler:self forElements:[NSArray arrayWithObjects:@"CAM",@"conds",[self stationId],@"winddir",@"windspeedmph",@"windgustmph",@"html",@"HTML",@"dateutc",nil] inNamespace:nil prefix:@"" 
				   map:[NSDictionary dictionaryWithObjectsAndKeys:
						@"value",@"winddir",
						@"value",@"windspeedmph",
						@"value",@"windgustmph",
						@"value",@"CAM",
						@"value",@"dateutc",
						@"station",[self stationId],
						nil]];
	[[self xmlparser] setDelegate:self];
	[[self xmlparser] setUndefinedTagAction:MAX_ACTION_NONE];	
}


-(NSString*)baseURL
{
	return @"http://stationdata.wunderground.com/cgi-bin/stationlookup?station=%@";
}


-(void)dealloc
{
	[webcamURL release];
	[super dealloc];
}


@end


#import "DebugMacros.h"


@implementation StationDataParser(testing)


+(void)testWundergroundDataParse
{
	NSArray *observations=[self _observationsFromResource:@"observation.xml"];
	INTEXPECT( [observations count], 1, @"number of observations");
	WindObservation *first=[observations objectAtIndex:0];
	EXPECTNOTNIL( [first date], @"date");
	EXPECTTRUE( [[first date] isKindOfClass:[NSDate class]], @"really a date");
	NSLog(@"current observation data: %@",first);
}

+(NSArray*)testSelectors
{
	return [NSArray arrayWithObjects:
			@"testWundergroundDataParse",
			nil];
}


@end
