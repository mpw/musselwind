//
//  WeatherDataParser.m
//  MusselWind
//
//  Created by Marcel Weiher on 15.11.09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import "WeatherDataParser.h"
#import <Foundation/Foundation.h>
#import "MPWMAXParser.h"
#import "WindSampleList.h"


@implementation WeatherDataParser

objectAccessor( NSString, stationId, setStationId )
objectAccessor( MPWMAXParser, xmlparser, setXmlparser )

-(void)initializeParser
{
}

-initWithStationId:(NSString*)newId
{
	self=[super init];
	[self setStationId:newId];
	[self initializeParser];
	return self;
}

-(NSDateFormatter*)dateConverter
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	/* This is required, Cocoa will try to use the current locale otherwise */
	NSLocale *enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[formatter setLocale:enUS];
	[enUS release];
	[formatter setDateFormat:[self dateFormatString]];
	return formatter;
	/* Unicode Locale Data Markup Language */
	
}


-(NSString*)baseURL
{
	return nil;
}

-(NSString*)weatherURLString
{
	return [NSString stringWithFormat:[self baseURL],[self stationId]];;
}

-(WindSampleList*)getWeatherDataFromURL:aURL
{
    WindSampleList *list=nil;
//    NSLog(@"get weather data from URL: %@",aURL);
    @try {
        list= [[[WindSampleList alloc] initWithArray:[[self xmlparser] parsedDataFromURL:aURL]] autorelease];
    } @catch (id exception) {
        NSLog(@"exception: %@",exception);
    }
//    NSLog(@"weather data list: %@",list);
    return list;
}

-(WindSampleList*)getWeatherData
{
//	NSLog(@"getWeatherData, parser: %@  url: %@",[self xmlparser],[self weatherURLString]);
	return [self getWeatherDataFromURL:[self weatherURLString]];
}

-(void)parseWeatherDataInBackground
{
	[[self xmlparser] startParsingFromURL:[NSURL URLWithString:[self weatherURLString]]];
}

-(void)dealloc
{
	[xmlparser release];
	[stationId release];
	[super dealloc];
}


@end
#import "DebugMacros.h"

@implementation WeatherDataParser(testing)

+(WindSampleList*)_observationsFromResource:(NSString*)resourceName
{
	WeatherDataParser *parser=[[[self alloc] initWithStationId:@"KCADALYC1"] autorelease]; 
	NSString *historyDataPath=[self frameworkPath:resourceName];
	EXPECTNOTNIL( historyDataPath, @"history data path");
	NSURL* historyDataURL = [NSURL fileURLWithPath:historyDataPath];
	EXPECTNOTNIL( historyDataURL, @"url");
	EXPECTNOTNIL( [NSData dataWithContentsOfURL:historyDataURL], @"data at URL");
	return [parser getWeatherDataFromURL:[NSURL fileURLWithPath:historyDataPath]];
}




@end

