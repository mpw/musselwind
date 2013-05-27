//
//  MPWDrawingContext.h
//  MusselWind
//
//  Created by Marcel Weiher on 11/18/10.
//  Copyright 2010 Marcel Weiher. All rights reserved.
//

#import "PhoneGeometry.h"


@protocol MPWDrawingContext <NSObject>


-(id <MPWDrawingContext>)translate:(float)x :(float)y;
-(id <MPWDrawingContext>)scale:(float)x :(float)y;
-(id <MPWDrawingContext>)rotate:(float)degrees;

-(id <MPWDrawingContext>)gsave;
-(id <MPWDrawingContext>)grestore;
-(id <MPWDrawingContext>)setdashpattern:(float*)array length:(int)arrayLength phase:(float)phase;
-(id <MPWDrawingContext>)setlinewidth:(float)width;

-(id <MPWDrawingContext>)setFillColorGray:(float)gray alpha:(float)alpha;
-(id <MPWDrawingContext>)setStrokeColorGray:(float)gray alpha:(float)alpha;

-(id <MPWDrawingContext>)setFillColorRed:(float)r green:(float)g blue:(float)b alpha:(float)alpha;
-(id <MPWDrawingContext>)setStrokeColorRed:(float)r green:(float)g blue:(float)b alpha:(float)alpha;



-(void)clip;
-(void)fill;
-(void)fillAndStroke;
-(void)fillRect:(NSRect)r;
-(void)stroke;
-(id <MPWDrawingContext>)rect:(NSRect)r;
-(id <MPWDrawingContext>)moveto:(float)x :(float)y;
-(id <MPWDrawingContext>)lineto:(float)x :(float)y;
-(id <MPWDrawingContext>)closepath;
-(id <MPWDrawingContext>)arcWithCenter:(NSPoint)center radius:(float)radius radiansStart:(float)start radiansStop:(float)stop  clockwise:(BOOL)clockwise;

-(id <MPWDrawingContext>)drawImage:anImage;

-(id <MPWDrawingContext>)setFont:aFont;
-(id <MPWDrawingContext>)show:(id)someText;     //  NSString or NSAttributedString
-(id <MPWDrawingContext>)setTextPosition:(NSPoint)p;
-(id <MPWDrawingContext>)setFontName:(NSString*)name size:(float)size;


@end
