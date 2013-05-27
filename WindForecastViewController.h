//
//  WindForecastViewController.h
//  MusselWind
//
//  Created by Marcel Weiher on 3/7/10.
//  Copyright 2010 Marcel Weiher. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WindRoseView;

@interface WindForecastViewController : UIViewController {
	IBOutlet WindRoseView	*sampleWindRose;
	NSMutableArray *forecastViews;
}

@end
