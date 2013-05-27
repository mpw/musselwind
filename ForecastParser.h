//
//  ForecastParser.h
//  MusselWind
//
//  Created by Marcel Weiher on 18.1.10.
//  Copyright 2010 Marcel Weiher. All rights reserved.
//


#import "WeatherDataParser.h"


@interface ForecastParser : WeatherDataParser {
	NSString *latitude,*longitude;
	NSString *fromDate,*toDate;
}

objectAccessor_h( NSString, latitude, setLatitude )
objectAccessor_h( NSString, longitude, setLongitude )
objectAccessor_h( NSString, fromDate, setFromDate)
objectAccessor_h( NSString, toDate, setToDate )

-(void)setStartDay:(NSDate*)day numDays:(int)numDays;
-(void)setDay:(NSDate*)day;


@end
