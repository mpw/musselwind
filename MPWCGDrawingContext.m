//
//  MPWCGDrawingStream.m
//  MusselWind
//
//  Created by Marcel Weiher on 8.12.09.
//  Copyright 2009-2010 Marcel Weiher. All rights reserved.
//

#import "MPWCGDrawingContext.h"

#if TARGET_OS_IPHONE
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>
#else
#import <ApplicationServices/ApplicationServices.h>
#import <Cocoa/Cocoa.h>
#endif


@implementation MPWCGDrawingContext

scalarAccessor( CGContextRef , context ,setContext )

+(CGContextRef)currentCGContext
{
#if TARGET_OS_IPHONE
	return UIGraphicsGetCurrentContext();
#else
	return [[NSGraphicsContext currentContext] graphicsPort];
#endif
}

+contextWithCGContext:(CGContextRef)c
{
    return [[[self alloc] initWithContext:c] autorelease];
}

+currentContext
{
	return [self contextWithCGContext:[self currentCGContext]];
}


-initWithContext:(CGContextRef)newContext;
{
	self=[super init];
	[self setContext:newContext];
    [self resetTextMatrix]; 

	return self;
}

-initBitmapContextWithSize:(NSSize)size colorSpace:(CGColorSpaceRef)colorspace
{
    CGContextRef c=CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorspace,   
                                         (CGColorSpaceGetNumberOfComponents(colorspace) == 4 ? kCGImageAlphaNone : kCGImageAlphaPremultipliedLast)  | kCGBitmapByteOrderDefault );
    return [self initWithContext:c];

}

+rgbBitmapContext:(NSSize)size
{
    return [[[self alloc] initBitmapContextWithSize:size colorSpace:CGColorSpaceCreateDeviceRGB()] autorelease];
}

+cmykBitmapContext:(NSSize)size
{
    return [[[self alloc] initBitmapContextWithSize:size colorSpace:CGColorSpaceCreateDeviceCMYK()] autorelease];
}

-(CGImageRef)cgImage
{
    return CGBitmapContextCreateImage( context );
}

#if TARGET_OS_IPHONE   
#define IMAGECLASS  UIImage
#else
#define IMAGECLASS  NSBitmapImageRep
#endif



-(Class)imageClass
{
    return [IMAGECLASS class];
}

-image
{
    return [[[[self imageClass] alloc]  initWithCGImage:[self cgImage]] autorelease];
}


-(void)dealloc
{
	[super dealloc];
}

-translate:(float)x :(float)y {
	CGContextTranslateCTM(context, x, y);
	return self;
}

-scale:(float)x :(float)y {
	CGContextScaleCTM(context, x, y);
	return self;
}

-rotate:(float)degrees {
	CGContextRotateCTM(context, degrees * (M_PI/180.0));
	return self;
}


-gsave
{
	CGContextSaveGState(context);
	return self;
}

-grestore
{
	CGContextRestoreGState(context);
	return self;
}

-setdashpattern:(float*)array length:(int)arrayLength phase:(float)phase
{
	CGFloat cgArray[ arrayLength ];
	for (int i=0;i<arrayLength; i++) {
		cgArray[i]=array[i];
	}
	CGContextSetLineDash(context, phase, cgArray, arrayLength);
	return self;
}

-setlinewidth:(float)width
{
	CGContextSetLineWidth(context, width);
	return self;
}

-setFillColorGray:(float)gray alpha:(float)alpha
{
	CGContextSetGrayFillColor(context,gray, alpha);
	return self;
}

-setStrokeColorGray:(float)gray alpha:(float)alpha
{
	CGContextSetGrayStrokeColor(context,gray, alpha);
	return self;
}

-setFillColorRed:(float)r green:(float)g blue:(float)b alpha:(float)alpha
{
	CGContextSetRGBFillColor(context, r, g, b, alpha);
	return self;
}

-setStrokeColorRed:(float)r green:(float)g blue:(float)b alpha:(float)alpha
{
	CGContextSetRGBStrokeColor(context, r, g, b, alpha);
	return self;
}

-rect:(NSRect)r
{
	CGContextAddRect( context, CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height) );
	return self;
}

-(void)fill
{
	CGContextFillPath( context );
}

-(void)fillDarken
{
    [self gsave];
    CGContextSetBlendMode(context, kCGBlendModeDarken);
    [self fill];
    [self grestore];    
}

-(void)clip
{
	CGContextClip( context );
}

-(void)fillRect:(NSRect)r;
{
	CGContextFillRect(context, CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height) );
}

-(void)stroke
{
	CGContextStrokePath( context );
}

-moveto:(float)x :(float)y
{
	CGContextMoveToPoint(context, x, y );	
	return self;
}

-lineto:(float)x :(float)y
{
	CGContextAddLineToPoint(context, x, y );	
	return self;
}

-arcWithCenter:(NSPoint)center radius:(float)radius radiansStart:(float)start radiansStop:(float)stop  clockwise:(BOOL)clockwise
{
	CGContextAddArc(context, center.x,center.y, radius , start, stop, clockwise);
	return self;
}

-closepath;
{
	CGContextClosePath(context);
	return self;
}

#if !TARGET_OS_IPHONE
-concatNSAffineTransform:(NSAffineTransform*)transform
{
    if ( transform ) {
        NSAffineTransformStruct s=[transform transformStruct];
        CGContextConcatCTM(context, CGAffineTransformMake(s.m11, s.m12, s.m21, s.m22, s.tX, s.tY));
    }
     return self; 
}
#endif
//	NSLog(@"will draw background, first arc");
-(id <MPWDrawingContext>)drawImage:(id)anImage
{
    IMAGECLASS *image=(IMAGECLASS*)anImage;
    NSSize s=[image size];
    CGRect r={ CGPointZero, s.width, s.height };
    CGContextDrawImage(context, r, [anImage CGImage]);
    return self;
}

-(void)resetTextMatrix
{
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
}

-(id <MPWDrawingContext>)setTextPosition:(NSPoint)p
{
    CGContextSetTextPosition(context, p.x,p.y);
    return self;
}

-(id <MPWDrawingContext>)drawTextLine:(CTLineRef)line
{
    CTLineDraw(line, context);
    return self;
}

-(id <MPWDrawingContext>)show:(NSAttributedString*)someText 
{
    if ( [someText isKindOfClass:[NSString class]]) {
        someText=[[[NSAttributedString alloc] initWithString:(NSString*)someText] autorelease];
    }
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef) someText);
    [self drawTextLine:line];
    CFRelease(line);
    return self;
}

-(id <MPWDrawingContext>)setFontName:(NSString*)name size:(float)size
{
    CGContextSelectFont(context, [name UTF8String], size, kCGEncodingMacRoman);
    return self;
}


@end
