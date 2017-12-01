//
//  MPWView.h
//  MusselWind
//
//  Created by Marcel Weiher on 11/19/10.
//  Copyright 2010 Marcel Weiher. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define VIEW_SUPERCLASS  UIView
#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
#define VIEW_SUPERCLASS  NSView 
#else
#error unsupported platform 
#endif

#import <DrawingContext/MPWDrawingContext.h>


@interface MPWView : VIEW_SUPERCLASS {
//	id <MPWDrawingContext> context;
}

@end
