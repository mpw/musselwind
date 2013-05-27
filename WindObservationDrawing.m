//
//  WindObservationDrawing.m
//  MusselWind
//
//  Created by Marcel Weiher on 2/17/10.
//  Copyright 2010 Marcel Weiher. All rights reserved.
//

#import "WindObservationDrawing.h"


@implementation WindObservation(Drawing)


+colorClass
{
	return NSClassFromString(@"NSColor") ?: NSClassFromString(@"UIColor");
}




-(void)setHueWithAlpha:(float)alpha
{
	float hue=[self hue];
	
#if TARGET_OS_IPHONE
	id color = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:alpha];
#else
	id color = [NSColor colorWithDeviceHue:hue saturation:1.0 brightness:1.0 alpha:alpha];
#endif
	[color setStroke];
	[color setFill];
}

-(float)radiansForDrawing
{
	return	(90-[self direction]) * M_PI / 180;
}


@end
