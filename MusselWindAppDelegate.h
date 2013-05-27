//
//  MusselWindAppDelegate.h
//  MusselWind
//
//  Created by Marcel Weiher on 11/1/09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class StationDataParser,WindHistoryView,HistoryDataParser,WeatherStationController,WindRoseXView;

@interface MusselWindAppDelegate : NSObject /* <NSApplicationDelegate> */ {
    NSWindow					*window;
	IBOutlet NSImageView		*imageView;
	IBOutlet WindHistoryView	*windCurrent;
	IBOutlet WindHistoryView	*windHistory;
	IBOutlet WindRoseXView		*windRoseView;
	IBOutlet NSTextField		*speed,*gust,*direction;
	WeatherStationController	*weatherStation;
}

@end
