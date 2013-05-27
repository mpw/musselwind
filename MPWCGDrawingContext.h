//
//  MPWCGDrawingStream.h
//  MusselWind
//
//  Created by Marcel Weiher on 8.12.09.
//  Copyright 2009-2010 Marcel Weiher. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <CoreGraphics/CoreGraphics.h>
#else
#import <ApplicationServices/ApplicationServices.h>
#endif
#import "PhoneGeometry.h"


#import "AccessorMacros.h"

#import "MPWDrawingContext.h"

@interface MPWCGDrawingContext: NSObject <MPWDrawingContext> {
	CGContextRef context;
}

scalarAccessor_h( CGContextRef, context, setContext )
-initWithContext:(CGContextRef)newContext;
-initBitmapContextWithSize:(NSSize)size colorSpace:(CGColorSpaceRef)colorspace;

+rgbBitmapContext:(NSSize)size;
+cmykBitmapContext:(NSSize)size;
+contextWithCGContext:(CGContextRef)c;
+currentContext;

-(void)resetTextMatrix;

-image;

#if !TARGET_OS_IPHONE
-concatNSAffineTransform:(NSAffineTransform*)transform;
#endif

@end
