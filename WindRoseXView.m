//
//  WindRoseXView.m
//  MusselWind
//
//  Created by Marcel Weiher on 27.11.09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import "WindRoseXView.h"
#import "WindObservation.h"
#import "WindSampleListDrawing.h"
#import "AccessorMacros.h"


@implementation WindRoseXView


objectAccessor( NSArray, observations, _setObservations )

-(void)setObservations:(NSArray *)newVar
{
	[self _setObservations:newVar];
	[self setNeedsDisplay:YES];
}


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)drawRect:(NSRect)rect onContext:(id <MPWDrawingContext>)context {
	[[[self observations] class] drawWindRoseBackgroundInRect:[self bounds]  context:context];
	[[self observations] drawWindRoseInRect:[self bounds]  context:context];
}

@end
