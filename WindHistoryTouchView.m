//
//  WindHistoryTouchView.m
//  MusselWind
//
//  Created by Marcel Weiher on 11/15/09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import "WindHistoryTouchView.h"
//#import <CoreGraphics/CoreGraphics.h>
#import "WindObservation.h"
#import "WindSampleListDrawing.h"

@implementation WindHistoryTouchView




- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self setNumSubdivisions:8];
    }
    return self;
}

-(void)awakeFromNib
{
	[self setNumSubdivisions:8];
}

intAccessor( numSubdivisions, setNumSubdivisions )
objectAccessor( WindSampleList, history, _setHistory )
objectAccessor( WindSampleList, forecast, _setForecast )
objectAccessor( NSArray, labels, _setLabels )


-(void)setLabels:(NSArray *)newVar
{
	[self _setLabels:newVar];
	[self setNumSubdivisions:[newVar count]];
}

-(void)setForecast:(WindSampleList *)newVar
{
	[self _setForecast:newVar];
	[self setNeedsDisplay];
}


-(void)setHistory:(WindSampleList *)newVar
{
	[self _setHistory:newVar];
	[self setNeedsDisplay];
}

-(float)xScale
{
	return 1;
}


-(float)yScale
{
	return 2;
}


-(int)maxPlottableObservations
{
	return [self bounds].size.width / [self xScale];
}


-(void)drawRect:(NSRect)rect onContext:(id <MPWDrawingContext>)context {
	
	[WindSampleList drawBackgroundInRect:[self bounds] dirtyRect:rect context:context numSubdivisions:[self numSubdivisions]];
	NSRect clipRect=CGRectInset([self bounds], 1, 1);
	
	[[context nsrect:clipRect] clip];
	[context setFillColorGray:0 alpha:1];
	if ( [self labels] ) {
		UIFont *labelFont = [UIFont systemFontOfSize:8];
		[[context gsave] scale:1 :-1];
		for (int i=1;i<[labels count]-1; i++ ) {
			float xBaseOffset = ([self bounds].size.width / ([labels count]-1)) * i;
			NSString *label = [labels objectAtIndex:i];
			NSSize labelSize = [label sizeWithFont:labelFont];
			NSPoint offset = CGPointMake(  round(xBaseOffset+1 - labelSize.width/2), round(-([self bounds].size.height+1)));
			
			[context setFillColorGray:1.0 alpha:0.5];
			[context fillRect:NSMakeRect(offset.x, offset.y+1, labelSize.width, labelSize.height-2)];
			[context setFillColorGray:0 alpha:1];
			[label drawAtPoint:offset withFont:labelFont] ;
			
		}
		[context grestore];
	}
//	NSLog(@"will draw observations with %d elements",[[self history] count]);
	[[self history] drawInRect:[self bounds] dirtyRect:rect context:context];
//	NSLog(@"did draw observations with %d elements",[[self history] count]);
	NSArray *lengths=@[ @5.0, @2.0 ];
	[[context setdashpattern:lengths  phase:0] setlinewidth:2];
	[[self forecast] drawInRect:[self bounds] dirtyRect:rect context:context labelSamples:YES ];
	
}

- (void)dealloc {
    [super dealloc];
}


@end
