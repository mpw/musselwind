//
//  WindObservationDrawing.h
//  MusselWind
//
//  Created by Marcel Weiher on 2/17/10.
//  Copyright 2010 Marcel Weiher. All rights reserved.
//

#import "WindObservation.h"
#import "CocoaUIKit.h"

@interface WindObservation(drawing)


-(void)setHueWithAlpha:(float)alpha;
-(float)radiansForDrawing;

@end
