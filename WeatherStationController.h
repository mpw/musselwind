//
//  WeatherStationController.h
//  MusselWind
//
//  Created by Marcel Weiher on 15.11.09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccessorMacros.h"
#import "CocoaUIKit.h"

@class StationDataParser,HistoryDataParser,ForecastParser,WindSampleList;

@interface WeatherStationController : NSObject {
	id							imageView;
	id							windCurrent;
	id							windHistory;
	IBOutlet id					windForecast;
	id							windRoseView;
	id							speed,gust,direction;
	StationDataParser			*observationParser;
	HistoryDataParser			*historyParser;
	ForecastParser				*forecastParser;
	WindSampleList				*history,*observations,*forecast;
	BOOL						haveNewSamples;
	
}

idAccessor_h( imageView, setImageView )
idAccessor_h( windCurrent, setWindCurrent )
idAccessor_h( windHistory, setWindHistory )
idAccessor_h( windForecast, setWindForecast )
idAccessor_h( windRoseView, setWindRoseView )
idAccessor_h( speed, setSpeed )
idAccessor_h( gust, setGust )
idAccessor_h( direction, setDirection )

-initWithStationId:(NSString*)newStationId;
-(WindSampleList*)forecastForDayFromNow:(int)relativeDay;

@end
