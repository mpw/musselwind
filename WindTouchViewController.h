//
//  WindTouchViewController.h
//  WindTouch
//
//  Created by Marcel Weiher on 15.11.09.
//  Copyright Marcel Weiher 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherStationController,WindHistoryTouchView,WindRoseView;

@interface WindTouchViewController : UIViewController {
	IBOutlet UIImageView*	imageView;
	WeatherStationController *weatherStation;
	IBOutlet WindHistoryTouchView *history,*current;
	IBOutlet WindRoseView *windRose;
	IBOutlet id speedText,directionText;
}


-(IBAction)showForecast:sender;

@end

