//
//  WindSampleListDrawing.m
//  MusselWind
//
//  Created by Marcel Weiher on 2/28/10.
//  Copyright 2010 Marcel Weiher. All rights reserved.
//

#import "WindSampleListDrawing.h"
#import "WindObservationDrawing.h"
#import <DrawingContext/MPWDrawingContext.h>
#import <CoreText/CoreText.h>

@implementation WindSampleList(Drawing)

-(float)xCoordOfSampleAtIndex:(int)i
{
	float xCoord = [self relativeDateOffsetOfSamplePercent:[self objectAtIndex:i]];
//	NSLog(@"x[%d]=%g",i,xCoord);
//	NSLog(@"win: %g max: %g current: %g",[[self minDate] timeIntervalSinceReferenceDate],[[self minDate] timeIntervalSinceReferenceDate],
//		  [[[self objectAtIndex:i] date] timeIntervalSinceReferenceDate]);
	return xCoord;
}

+(void)drawBackgroundInRect:(NSRect)totalRect dirtyRect:(NSRect)rect  context:(id <MPWDrawingContext>)context minRing:(int)start maxRing:(int)stop verts:(int)verticalSegments
{	
	int numHorizontalSegments =5;
	float segmentHeight = rect.size.height/numHorizontalSegments;
	[[[context setFillColorGray:1.0 alpha:0.2] nsrect:rect] fill];
	
    [context setFillColor:[context colorRed:1.0 green:1.0 blue:0.9 alpha:0.2]];
	[[context nsrect:NSMakeRect(0, 20+0.5, totalRect.size.width, segmentHeight)] fill];

	[context setFillColorGray:0 alpha:1];
	for (int i=start; i< stop; i++ ) {		
		[[context nsrect:NSMakeRect(0, round(i*segmentHeight)+0.5, totalRect.size.width, 0.5)] fill];
	}	
	[context setFillColorGray:0.2 alpha:0.4];
	verticalSegments--;
	for (int i=1; i< verticalSegments; i++ ) {
		[[context nsrect:NSMakeRect(round(i*totalRect.size.width/verticalSegments)  ,0,0.3, totalRect.size.height )] fill];
	}
	[context setFillColorGray:0 alpha:1];
	[context nsrect:rect];
	[context stroke];
}

+(void)drawBackgroundInRect:(NSRect)totalRect dirtyRect:(NSRect)rect  context:(id <MPWDrawingContext>)context  numSubdivisions:(int)numSubdivisions
{
	[self drawBackgroundInRect:totalRect dirtyRect:rect  context:context minRing:1 maxRing:5 verts:numSubdivisions];
}

-(void)drawInRect:(NSRect)totalRect dirtyRect:(NSRect)rect  context:(id <MPWDrawingContext>)context labelSamples:(BOOL)labelSamples
{
	int maxSpeed=25;
	float yScale = rect.size.height/maxSpeed;
	
	NSPoint points[ [self  count] ];
	float x=0;
	
	x=0;
	for (int i=0;i<[self  count]; i++) {
		points[i].x=[self xCoordOfSampleAtIndex:i] * rect.size.width / 100.0;
		points[i].y=round([[self objectAtIndex:i] speed]*yScale)+0.5;
	}
	
    [context setFillColor:[context colorRed:0 green:0 blue:1 alpha:1]];
	
	[context moveto:points[0].x :points[0].y];
	for (int i=0;i<[self  count]; i++ ) {
		[context lineto:points[i].x :points[i].y ];
		WindObservation* observation = [self  objectAtIndex:i];
		float alpha;
		if ( [observation isGood] || (i>0 && [[self  objectAtIndex:i-1] isGood]) ) {
			alpha=1.0;
		} else {
			alpha=0.5;
		}
		[observation setHueWithAlpha:alpha];
		//		NSLog(@"hue[%d]=%g %d %@",i,hue,[[arrayOfObservations  objectAtIndex:i] direction],[arrayOfObservations  objectAtIndex:i]);
		[context stroke];
		[context moveto:points[i].x  :points[i].y ];
	}

#if TARGET_OS_IPHONE
    [context setFillColor:[context colorRed:0 green:0 blue:0 alpha:1]];
	if ( labelSamples ) 
	{
		UIFont *labelFont=[UIFont systemFontOfSize:9];
        [context setFont:[context fontWithName:[labelFont fontName] size:[labelFont pointSize]]];
        CTFontRef font=CTFontCreateWithName((CFStringRef)labelFont.fontName, 
                                            labelFont.pointSize, 
                                            NULL);
//        NSLog(@"font: %@/%@",labelFont,(id)font);
        [context resetTextMatrix];
		for ( int i=0; i< [self count] ; i++ ){
			WindObservation *obs=[self objectAtIndex:i];
			[context gsave];
            NSPoint offset=NSMakePoint(points[i].x- 8, round(points[i].y )+4 );
			NSString *speedLabel=[NSString stringWithFormat:@"%d/%d",(int)[obs speed],[obs direction]];
			NSSize labelSize = [speedLabel sizeWithFont:labelFont];
			[context setFillColorGray:1.0 alpha:0.7];
			[context fillRect:NSInsetRect(NSMakeRect(offset.x,offset.y-4, labelSize.width, labelSize.height), 1, 1)];
			[obs setHueWithAlpha:1.0];
            NSDictionary *attrs=[NSDictionary dictionaryWithObjectsAndKeys:(id)font,kCTFontAttributeName, nil];
            NSAttributedString *label=[[[NSAttributedString alloc] initWithString:speedLabel attributes:attrs] autorelease];
			[context setFillColorGray:0 alpha:1];
            [context setTextPosition:offset];
            [context show:label];
			[context grestore];
		}
	}
#endif	
}

-(void)drawInRect:(NSRect)totalRect dirtyRect:(NSRect)rect  context:(id <MPWDrawingContext>)context
{
	[self drawInRect:totalRect dirtyRect:rect  context:context labelSamples:NO];
}

+(void)drawWindRoseBackgroundInRect:(NSRect)bounds context:(id <MPWDrawingContext>)context minCircle:(int)start maxCircle:(int)stop
{
	NSPoint center=bounds.origin;
	NSSize  size=bounds.size;
	double maxRadius = MIN( size.width /2 , size.height / 2 );
	center.x+=size.width/2;
	center.y+=size.height/2;
	maxRadius *= 0.95;
	//	NSLog(@"+drawWindRoseInRect");
	[context setFillColorGray:0 alpha:1];

	[context arcWithCenter:center radius:maxRadius startDegrees:0 endDegrees:360  clockwise:NO];
	[context clip];
	[context arcWithCenter:center radius:maxRadius startDegrees:0 endDegrees:360 clockwise:NO];
	[context fill];
	[context setlinewidth:1];
    [context setStrokeColor:[context colorRed:0.2 green:0.9 blue:0.4 alpha:1.0]];
	
	center.x+=0.5;
	center.y+=0.5;
	for ( int i=start; i <= stop;i ++ ) {
		[context arcWithCenter:center radius:i*maxRadius/4 startDegrees:0 endDegrees:360 clockwise:NO];
		[context stroke];
	}
}

+(void)drawWindRoseBackgroundInRect:(NSRect)bounds context:(id <MPWDrawingContext>)context
{
	[self drawWindRoseBackgroundInRect:bounds context:context minCircle:1 maxCircle:4];
}

-(void)drawObservation:observation inWindRoseAt:(NSPoint)center radius:(float)maxRadius context:(id <MPWDrawingContext>)context
{
	[context moveto:center.x :center.y];
	[context arcWithCenter:center radius:[observation speed] * maxRadius / 20
			  startDegrees:[observation radiansForDrawing] + 0.1
			   endDegrees:[observation radiansForDrawing] - 0.1 clockwise:YES];
	[observation setHueWithAlpha:.9];
	[[context closepath] fill];
}


-(void)drawWindRoseInRect:(NSRect)bounds context:(id <MPWDrawingContext>)context highlight:(int)highlightIndex
{
	NSPoint center=bounds.origin;
	NSSize  size=bounds.size;
	double maxRadius = MIN( size.width /2 , size.height / 2 );
	center.x+=size.width/2;
	center.y+=size.height/2;
	maxRadius *= 0.95;

	[[context gsave] setlinewidth:4];

	//	NSLog(@"did draw background");
	
	for ( int i =0 ; i< MIN(highlightIndex+1,[self count]); i++) {
		WindObservation *observation =[self objectAtIndex:i];
		[context arcWithCenter:center radius: MIN([observation speed],25) * maxRadius / 20
				  startDegrees:[observation radiansForDrawing] + 0.06 endDegrees:[observation radiansForDrawing] - 0.06
					 clockwise:YES];
        [context setStrokeColor:[context colorRed:0.2 green:0.3 blue:0.9 alpha:.2 + ((float)i)/[self count] * .4]];
		[observation setHueWithAlpha:.2 + ((float)i)/[self count] * .7];
		[context stroke];
	}
		
	[context grestore];
	[context setStrokeColor:[context colorRed:1.0 green:0.3 blue:0.2 alpha:0.6]];
	if ( highlightIndex >= 0 && highlightIndex < [self count] ) {
		[self drawObservation:[self objectAtIndex:highlightIndex] inWindRoseAt:center radius:maxRadius context:context];
	}
}

-(void)drawWindRoseInRect:(NSRect)bounds context:(id <MPWDrawingContext>)context
{
	[self drawWindRoseInRect:bounds context:context highlight:MAX([self count]-1,0)];
}

@end
