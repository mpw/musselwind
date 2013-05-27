//
//  WindTouchAppDelegate.h
//  WindTouch
//
//  Created by Marcel Weiher on 15.11.09.
//  Copyright Marcel Weiher 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WindTouchViewController,WeatherStationController;

@interface WindTouchAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    WindTouchViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet WindTouchViewController *viewController;

@end

