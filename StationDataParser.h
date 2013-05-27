//
//  StationDataParser.h
//  MusselWind
//
//  Created by Marcel Weiher on 15.11.09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import "WeatherDataParser.h"


@interface StationDataParser : WeatherDataParser {
	NSString		*webcamURL;
}

-(NSString*)webcamURL;

@end
