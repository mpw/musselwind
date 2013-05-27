//
//  WindObservation.h
//  MusselWind
//
//  Created by Marcel Weiher on 11/5/09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccessorMacros.h"

@interface WindObservation : NSObject {
	float speed,gust;
	int	  direction;
	NSDate	*date;
}

floatAccessor_h( speed , setSpeed )
floatAccessor_h( gust , setGust )
intAccessor_h( direction , setDirection )
objectAccessor_h( NSDate, date, setDate )

-(BOOL)isGood;
-(float)hue;


@end
