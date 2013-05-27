//
//  WeatherDataParser.h
//  MusselWind
//
//  Created by Marcel Weiher on 15.11.09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccessorMacros.h"


@class MPWMAXParser,WindObservation,WindSampleList;

@interface WeatherDataParser : NSObject {
	MPWMAXParser	*xmlparser;
	NSString		*stationId;
}

-initWithStationId:(NSString*)newId;
-(WindSampleList*)getWeatherData;

objectAccessor_h( NSString, stationId, setStationId )
objectAccessor_h( MPWMAXParser, xmlparser, setXmlparser )
-(NSDateFormatter*)dateConverter;


@end

@interface WeatherDataParser(testing)

+(WindSampleList*)_observationsFromResource:(NSString*)resourceName;

@end
