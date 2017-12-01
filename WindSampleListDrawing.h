//
//  WindSampleListDrawing.h
//  MusselWind
//
//  Created by Marcel Weiher on 2/28/10.
//  Copyright 2010 Marcel Weiher. All rights reserved.
//

#import "WindSampleList.h"
#import <DrawingContext/MPWDrawingContext.h>



@interface WindSampleList(Drawing)

-(void)drawInRect:(NSRect)totalRect dirtyRect:(NSRect)rect context:(id <MPWDrawingContext>)context;
-(void)drawInRect:(NSRect)totalRect dirtyRect:(NSRect)rect  context:(id <MPWDrawingContext>)context labelSamples:(BOOL)labelSamples;
-(void)drawWindRoseInRect:(NSRect)bounds  context:(id <MPWDrawingContext>)context;
-(void)drawWindRoseInRect:(NSRect)bounds context:(id <MPWDrawingContext>)context highlight:(int)highlightIndex;

+(void)drawWindRoseBackgroundInRect:(NSRect)bounds context:(id <MPWDrawingContext>)context minCircle:(int)start maxCircle:(int)stop;
+(void)drawWindRoseBackgroundInRect:(NSRect)bounds context:(id <MPWDrawingContext>)context;

+(void)drawBackgroundInRect:(NSRect)totalRect dirtyRect:(NSRect)rect  context:(id <MPWDrawingContext>)context minRing:(int)start maxRing:(int)stop verts:(int)verticalSegments;
+(void)drawBackgroundInRect:(NSRect)totalRect dirtyRect:(NSRect)rect  context:(id <MPWDrawingContext>)context;


@end
