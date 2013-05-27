//
//  MPWView.m
//  MusselWind
//
//  Created by Marcel Weiher on 11/19/10.
//  Copyright 2010 Marcel Weiher. All rights reserved.
//

#import "MPWView.h"
#import "MPWCGDrawingContext.h"

@implementation MPWView

-(void)drawRect:(NSRect)rect onContext:(id <MPWDrawingContext>)context
{
    if ([self respondsToSelector:@selector(drawOnContext:)] ) {
        [self drawOnContext:context];
    }
}

-(void)drawRect:(NSRect)rect
{
	NSLog(@"-[%@ drawRect:%@]",[self class],NSStringFromRect(rect));
	MPWCGDrawingContext *context = [MPWCGDrawingContext currentContext];
#if TARGET_OS_IPHONE
	[context translate:0  :[self bounds].size.height];
	[[context scale:1  :-1] setlinewidth:1];
#endif
	[self drawRect:rect onContext:context];
}


@end
