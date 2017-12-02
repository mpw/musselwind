//
//  WeatherStationController.m
//  MusselWind
//
//  Created by Marcel Weiher on 15.11.09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import "WeatherStationController.h"
#import "WindObservation.h"
//#import "WindHistoryView.h"
#import "StationDataParser.h"
#import "HistoryDataParser.h"
#import "ForecastParser.h"
#import "WindSampleList.h"
#import <MPWFoundation/MPWFoundation.h>

@implementation WeatherStationController

idAccessor( imageView, setImageView )
idAccessor( windCurrent, setWindCurrent )
idAccessor( windHistory, setWindHistory )
idAccessor( windForecast, setWindForecast )
idAccessor( speed, setSpeed )
idAccessor( gust, setGust )
idAccessor( direction, setDirection )
idAccessor( windRoseView, setWindRoseView )


objectAccessor( StationDataParser, observationParser, setObservationParser )
objectAccessor( HistoryDataParser, historyParser, setHistoryParser )
objectAccessor( ForecastParser, forecastParser , setForecastParser )
objectAccessor( WindSampleList,observations , setObservations )
objectAccessor( WindSampleList,history, setHistory )
objectAccessor( WindSampleList,forecast , setForecast )

-initWithStationId:(NSString*)newStationId
{
	self=[super init];
#if WINDOWS
	ObjectiveXMLLoad();
#endif
	
	[self setHistory:[[[WindSampleList alloc] init] autorelease]];
	[self setObservations:[[[WindSampleList alloc] init] autorelease]];
	[self setObservationParser:[[[StationDataParser alloc] initWithStationId:newStationId] autorelease]];
	[self setHistoryParser:[[[HistoryDataParser alloc] initWithStationId:newStationId] autorelease]];
	[self setForecastParser:[[[ForecastParser alloc] initWithStationId:newStationId] autorelease]];
	[[self historyParser] setDelegate:self];
	return self;
}

-(int)maxPlottableObservations
{
	return [windHistory maxPlottableObservations]; 
}

-imageURL
{
	id url=nil; // [observationParser webcamURL];
	if ( !url ) {
		NSLog(@"observation parser did not give us a URL!");
		url=@"http://icons.wunderground.com/webcamramdisk/b/a/barenjager/2/current.jpg";
	}
	return url;
}

-(Class)imageClass
{
#if WINDOWS
	return [NSImage class];
#else	
	Class imageClass = NSClassFromString(@"NSImage");
	if (!imageClass ) {
		imageClass=NSClassFromString(@"UIImage");
	}
	return imageClass;
#endif	
}

-(void)updateImageWithImageData:(NSData*)webcamImageData
{
#if TARGET_OS_IPHONE
	id image=[[[UIImage alloc] initWithData:webcamImageData] autorelease];
#else
	id bitmap=[[[NSBitmapImageRep alloc] initWithData:webcamImageData] autorelease];
	NSLog(@"bitmap: %@",bitmap);
	id image=[[[[self imageClass] alloc] init] autorelease];
	[image addRepresentation:bitmap];
	NSLog(@"got image: %@",image);
#endif	
    [[imageView onMainThread] setImage:image];
}

-(void)updateImage
{
	NSAutoreleasePool *pool=[NSAutoreleasePool new];
	if ( [self imageURL] ) {
		NSData *webcamImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self imageURL]]];
		[self updateImageWithImageData:webcamImageData];
//		[imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
	}
	[pool release];
}

-(void)updateImageInBackground
{
	[self performSelectorInBackground:@selector(updateImage) withObject:nil];
}

-(WindSampleList*)totalHistory
{
	WindSampleList *totalHistory=[[[self history] copy] autorelease];
	[totalHistory addSamplesFromSampleList:[self observations]];
	return totalHistory;
}

-(WindSampleList*)filteredTotalHistory
{
	WindSampleList *totalHistory=[[[WindSampleList alloc] init] autorelease];
	[totalHistory setMinDate:[[self observations] minDate]];
	[totalHistory setMaxDate:[NSDate date]];
	[totalHistory addSamplesFromSampleList:[self history]];
	[totalHistory addSamplesFromSampleList:[self observations]];
	return totalHistory;
}

-(int)numObservationsInWindRose
{
	return 30;
}

-(void)showHistoryInWindRose:aHistory
{
	int historyCount = (int)[aHistory count];
	if ( historyCount > 3 ) {
		int historyStart=MAX(0,historyCount-[self numObservationsInWindRose]);
//		NSLog(@"update windRose");
		[windRoseView setObservations:[aHistory sublistWithRange:NSMakeRange(historyStart, historyCount-historyStart)]];
//		[[windRoseView window] display];
//#if !WINDOWS	
//#endif		
	}

}

-(void)refreshHistoryIfNecessary
{
//	NSLog(@"update history at count %d",[[self history] count]);
	//		NSLog(@"did cancel previous");
	if ( haveNewSamples )  {
		haveNewSamples=NO;
		[windHistory performSelectorOnMainThread:@selector(setHistory:) withObject:[[[self history] copy] autorelease] waitUntilDone:YES];
		[self performSelectorOnMainThread:@selector(showHistoryInWindRose:) withObject:[[[self totalHistory] copy] autorelease] waitUntilDone:YES];
	}
}

-(int)historyChunkSize
{
#if WINDOWS
	return 10;
#else
	return 1;
#endif	
}

-(void)addWindObservation:anObservation
{
//	NSLog(@"add wind observation: %@",anObservation);
	[[self history] addSample:anObservation];
	haveNewSamples=YES;
}


-(void)loadHistory
{
    @try {
        NSAutoreleasePool *pool=[NSAutoreleasePool new];
        NSTimer* refreshTimer= [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(refreshHistoryIfNecessary) userInfo:nil repeats:YES];
        //	NSLog(@"start loadhistory");
        [self setHistory:[[[WindSampleList alloc] init] autorelease]];
        [[self history] setMinDate:[[[self history] class] startOfDayFromDate:[NSDate date]] ];
        [[self history] setMaxDate:[[[self history] minDate] addTimeInterval:24*3600] ];
        //	NSLog(@"historyParser: %@",historyParser);
        [historyParser parseWeatherDataInBackground];
        //	[windHistory setHistory:[self history]];
        haveNewSamples=YES;
        //	[self refreshHistoryIfNecessary];
        //	[refreshTimer invalidate];
        //	NSLog(@"finish loadhistory");
        //	[windHistory performSelectorOnMainThread:@selector(setHistory:) withObject:hist waitUntilDone:NO];
        //	NSLog(@"history: %@",hist);
        [pool release];
    }
    @catch (NSException *exception) {
        NSLog(@"exception loading history: %@",exception);
    }
}

-(WindSampleList*)loadForecastForDaysFromNow:(int)relativeDay
{
	NSDate *sometimeToday=[NSDate date];
	NSDate *forecastStart=[WindSampleList startOfDayFromDate:sometimeToday];
	[forecastParser setStartDay:forecastStart numDays:relativeDay];
	WindSampleList *forecastData = [forecastParser getWeatherData];
//	NSLog(@"got forecast: %@",[forecastData samples]);
	[forecastData setMinDate:forecastStart ];
	[forecastData setMaxDate:[[self history] maxDate] ];
	return forecastData;
}

-(WindSampleList*)forecastForDayFromNow:(int)relativeDay
{
	NSDate *sometimeToday=[NSDate date];
	NSDate *forecastDay=[[WindSampleList startOfDayFromDate:sometimeToday] addTimeInterval:24*3600*relativeDay];
	NSDate *forecastDayEnd = [forecastDay addTimeInterval:24*3600];
	WindSampleList *forecastForDay = [[[WindSampleList alloc] initWithArray:[[self forecast] samples] minDate:forecastDay maxDate:forecastDayEnd] autorelease];

	return forecastForDay;
}

-(void)loadForecast
{
	id pool=[NSAutoreleasePool new];
	[self setForecast:[self loadForecastForDaysFromNow:7]];
	[windHistory performSelectorOnMainThread:@selector(setForecast:) withObject:[self forecastForDayFromNow:0] waitUntilDone:NO];
	[pool release];
}

-(void)loadHistoryInBackground
{
	[self performSelectorInBackground:@selector(loadHistory) withObject:nil];
}


-(void)loadForecastInBackground
{
	[self performSelectorInBackground:@selector(loadForecast) withObject:nil];
}

-(void)updateUIWithWeatherData:(WindObservation *)weatherData
{
    [windCurrent setHistory:[self filteredTotalHistory]];
    [self showHistoryInWindRose:[self totalHistory]];
    [direction setIntValue:[weatherData direction]];
    [speed setIntValue:(int)[weatherData speed]];
    [gust setIntValue:(int)[weatherData gust]];
}

-(void)loadMostRecentWeatherData
{
//	NSLog(@"loadMostRecentWeatherData");
	id pool=[NSAutoreleasePool new];
	[[self observations] setMaxDate:[NSDate dateWithTimeIntervalSinceNow:600]];
	[[self observations] setMinDate:[NSDate dateWithTimeIntervalSinceNow:-10*60]];
	WindObservation *weatherData = [[[self observationParser] getWeatherData] lastObject];
	if ( !weatherData ) {
		weatherData=[observations lastObject];
	}
//	NSLog(@"weatherData: %@",weatherData);
	if ( weatherData ) {
		[[self observations] setMaxDate:[weatherData date]];
		[[self observations] addSample:weatherData];
        [[self onMainThread] updateUIWithWeatherData:weatherData];
	} else {
	}
	
	[pool release];
}

-(void)loadMostRecentWeatherDataInBackground
{
	[self performSelectorInBackground:@selector(loadMostRecentWeatherData) withObject:nil];
}


- (void)loadWeatherData {
	[windRoseView setObservations:nil];
	[windCurrent setHistory:nil];
	[windHistory setHistory:nil];
	[self loadMostRecentWeatherData];
	[self updateImageInBackground];
	[self loadHistory];
	[self loadForecastInBackground];
	[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadMostRecentWeatherDataInBackground) userInfo:nil repeats:YES];
	[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateImageInBackground) userInfo:nil repeats:YES];
	[NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(loadHistory) userInfo:nil repeats:YES];
	[NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(loadForecastInBackground) userInfo:nil repeats:YES];
}


@end
