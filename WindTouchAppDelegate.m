//
//  WindTouchAppDelegate.m
//  WindTouch
//
//  Created by Marcel Weiher on 15.11.09.
//  Copyright Marcel Weiher 2009. All rights reserved.
//

#import "WindTouchAppDelegate.h"
#import "WindTouchViewController.h"
#import "WeatherStationController.h"

@implementation WindTouchAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    // Override point for customization after app launch  
	[viewController setWeatherStation:[[[WeatherStationController alloc] initWithStationId:@"KCADALYC1"] autorelease]];

//    [window addSubview:viewController.view];
    [window setRootViewController:viewController];
	[viewController performSelector:@selector(updateWeather) withObject:nil afterDelay:0];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

- (NSUInteger)application_disabled:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    NSUInteger orientations = UIInterfaceOrientationMaskAll;
    
    if (self.window.rootViewController) {
        UIViewController* presented = [[(UINavigationController *)self.window.rootViewController viewControllers] lastObject];
        orientations = [presented supportedInterfaceOrientations];
    }
    return orientations;
}

@end
