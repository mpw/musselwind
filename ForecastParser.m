//
//  ForecastParser.m
//  MusselWind
//
//  Created by Marcel Weiher on 18.1.10.
//  Copyright 2010 Marcel Weiher. All rights reserved.
//

#import "ForecastParser.h"
#import "MPWMAXParser.h"
#import "WindObservation.h"

@implementation ForecastParser

objectAccessor( NSString, latitude, setLatitude )
objectAccessor( NSString, longitude, setLongitude )
objectAccessor( NSString, fromDate, setFromDate)
objectAccessor( NSString, toDate, setToDate )

-initWithStationId:(NSString*)newId
{
	self=[super initWithStationId:newId];
	[self setLatitude:@"37.667"];
	[self setLongitude:@"-122.489"];
	[self setFromDate:@"2010-01-28"];
	[self setToDate:@"2010-01-29"];
	
	return self;
}

-(NSString*)formattedDate:(NSDateComponents*)dateComponents
{
	return [NSString stringWithFormat:@"%04d-%02d-%02d",
			[dateComponents year],[dateComponents month],[dateComponents day]];
				
}

-(void)setStartDay:(NSDate*)day numDays:(int)numDays
{
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *startDay =
	[gregorian components:( NSYearCalendarUnit |  NSDayCalendarUnit | NSMonthCalendarUnit) fromDate:day];
	[self setFromDate:[self formattedDate:startDay]];
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
	[offsetComponents setDay:numDays];
	NSDate *nextDay= [gregorian dateByAddingComponents:offsetComponents toDate:day options:0];
	[self setToDate:[self formattedDate:[gregorian components:( NSYearCalendarUnit |  NSDayCalendarUnit | NSMonthCalendarUnit) fromDate:nextDay]]];
}

-(void)setDay:(NSDate*)day
{
	[self setStartDay:day numDays:0];
}


-timeLayoutElement:children attributes:attrs parser:parser
{
//	NSLog(@"time: %@",children);
	return [[children allValues] retain];
}

-directionElement:children attributes:attrs parser:parser
{
//	NSLog(@"direction: %@",children);
	return [[children allValues] retain];
}

-windSpeedElement:children attributes:attrs parser:parser
{
//	NSLog(@"wind-speed: %@",children);
	return [[children allValues] retain];
}


-valueElement:children attributes:attrs parser:parser
{
	return [[children lastObject] retain];
}

-defaultElement:children attributes:attrs parser:parser
{
	return nil;
}

-dwmlElement:children attributes:attrs parser:parser
{
	return [[children objectForKey:@"data"] retain];
}

-(NSString*)dateFormatString
{
	return @"yyyy-MM-dd'T'HH:mm:ss";
}


-dataElement:children attributes:attrs parser:parser
{
	NSArray *times,*speeds,*directions;
	NSMutableArray *samples=[NSMutableArray array];
	times=[children objectForKey:@"time-layout"];
	speeds=[[children objectForKey:@"parameters"] objectForKey:@"wind-speed"];
	directions=[[children objectForKey:@"parameters"] objectForKey:@"direction"];
//	NSLog(@"times: %@ speeds: %@ directions: %@",times,speeds,directions);
	NSDateFormatter *formatter=[self dateConverter];
	for (int i=0;i<[times count];i++) {
		WindObservation *sample=[[[WindObservation alloc] init] autorelease];
		[sample setSpeed:[[speeds objectAtIndex:i] floatValue]];
		[sample setGust:[sample speed]];
		[sample setDirection:[[directions objectAtIndex:i] intValue]];
		NSString *dateString = [times objectAtIndex:i];
		[sample setDate:[formatter dateFromString:[dateString substringToIndex:[dateString length]-6]]]; 
//		NSLog(@"observation[%d]=%@",i,sample);
		[samples addObject:sample];
	}
	
	return [samples retain];
}


-(void)initializeParser
{
	[self setXmlparser:[MPWMAXParser parser]];
	[[self xmlparser] setHandler:self forElements:[NSArray arrayWithObjects:@"dwml",@"data",@"name",@"direction",@"wind-speed",@"time-layout",@"layout-key",@"start-valid-time",@"value",nil] inNamespace:nil prefix:@"" 
							 map:[NSDictionary dictionaryWithObjectsAndKeys:
								  @"nothing",@"layout-key",
								  @"nothing",@"name",
								  @"windSpeed",@"wind-speed",
								  @"timeLayout",@"time-layout",
								  @"value",@"start-valid-time",
								  nil]];
}


-(NSString*)baseURL
{
//	return @"http://www.weather.gov/forecasts/xml/sample_products/browser_interface/ndfdXMLclient.php?lat=%@&lon=%@&product=time-series&begin=%@T07:00:00-08:00&end=%@T19:00:00-08:00&wdir=wdir&wspd=wspd";
	return @"http://www.weather.gov/forecasts/xml/sample_products/browser_interface/ndfdXMLclient.php?lat=%@&lon=%@&product=time-series&begin=%@&end=%@&wdir=wdir&wspd=wspd";
}


-(NSString*)weatherURLString
{
	NSString *url= [NSString stringWithFormat:[self baseURL],[self latitude],[self longitude],[self fromDate],[self toDate]];
	NSLog(@"forecast url: '%@'",url);
	return url;
}

-(WindSampleList*)getWeatherDataFromURL:aURL
{
	WindSampleList* list= [super getWeatherDataFromURL:aURL];
//	NSLog(@"forecast parse: %@",list);
	return list;
}


@end


#import "DebugMacros.h"


@implementation ForecastParser(testing)


+(void)testWundergroundDataParse
{
	WindSampleList *observations=[self _observationsFromResource:@"forecast.xml"];
	INTEXPECT( [observations count], 6, @"number of forecast data points");
//	NSLog(@"observations: %@",observations);
	WindObservation *first=[observations objectAtIndex:0];
	EXPECTNOTNIL( [first date], @"date");
	
}
	 
+(void)testSettingDate
{
	ForecastParser *parser=[[[self alloc] initWithStationId:@"bogus"] autorelease];
	[parser setDay:[[parser dateConverter] dateFromString:@"2010-02-28T10:00:00-08:00"]];
	IDEXPECT( [parser fromDate], @"2010-02-28", @"from date" );
	IDEXPECT( [parser toDate], @"2010-03-01", @"to date" );
}


+(NSArray*)testSelectors
{
	return [NSArray arrayWithObjects:
			@"testWundergroundDataParse",
			@"testSettingDate",
			nil];
}


@end
