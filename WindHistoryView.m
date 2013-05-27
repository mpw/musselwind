//
//  WindHistoryView.m
//  MusselWind
//
//  Created by Marcel Weiher on 11/5/09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import "WindHistoryView.h"
#import "WindObservation.h"
#import "WindSampleListDrawing.h"

@implementation WindHistoryView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}
objectAccessor( WindSampleList, history, _setHistory )
objectAccessor( WindSampleList, forecast, _setForecast )

-(void)setHistory:(WindSampleList *)newVar
{
	[self _setHistory:newVar];
	[self setNeedsDisplay:YES];
}

-(void)setForecast:(WindSampleList *)newVar
{
	NSLog(@"set forecast: %@",[newVar samples]);
	[self _setForecast:newVar];
	[self setNeedsDisplay:YES];
}

-(float)plotScale
{
	return 2;
}


-(int)maxPlottableObservations
{
	return [self bounds].size.width / [self plotScale];
}

-(void)drawRect:(NSRect)dirtyRect onContext:(id <MPWDrawingContext>)context {
	[WindSampleList drawBackgroundInRect:[self bounds] dirtyRect:dirtyRect context:context numSubdivisions:8];
	NSLog(@"will draw observations with %d elements",[[self history] count]);
	[[self history] drawInRect:[self bounds] dirtyRect:dirtyRect context:context ];
	CGFloat lengths[]={ 5.0,2.0 };
	[context setdashpattern:lengths length:2 phase:0];
	[[self forecast] drawInRect:[self bounds] dirtyRect:dirtyRect context:context ];
}



@end
