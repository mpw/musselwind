//
//  MusselWindAppDelegate.m
//  MusselWind
//
//  Created by Marcel Weiher on 11/1/09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import "MusselWindAppDelegate.h"
#import "WeatherStationController.h"

@implementation MusselWindAppDelegate

objectAccessor( WeatherStationController, weatherStation, setWeatherStation )



-init
{
	self=[super init];
	[self setWeatherStation:[[[WeatherStationController alloc] initWithStationId:@"KCADALYC1"] autorelease]];
	return self;
}

-copyKeys
{
	return [NSArray arrayWithObjects:@"imageView",
	 @"windRoseView",
	 @"windCurrent",
	 @"windHistory",
	 @"speed",@"gust",@"direction",nil];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	for ( id key in [self copyKeys]  ) {
		[weatherStation setValue:[self valueForKey:key] forKey:key];
	 }
		 
	[weatherStation loadWeatherData ];
//	[NSException raise:@"justfortheheckofit" format:@"see if this bombs"];
}

@end
