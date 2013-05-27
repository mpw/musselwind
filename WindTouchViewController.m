//
//  WindTouchViewController.m
//  WindTouch
//
//  Created by Marcel Weiher on 15.11.09.
//  Copyright Marcel Weiher 2009. All rights reserved.
//

#import "WindTouchViewController.h"
#import "AccessorMacros.h"
#import "WeatherStationController.h"
#import "LargeImageViewController.h"
#import "WindForecastViewController.h"

@implementation WindTouchViewController

objectAccessor( WeatherStationController , weatherStation, _setWeatherStation )



-(void)setWeatherStation:station 
{
	[self _setWeatherStation:station];
	NSLog(@"will setImageView %@",imageView);

}
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
       // Custom initialization
    }
    return self;
}

-(void)updateWeather
{
	[weatherStation setImageView:imageView];
	[weatherStation setWindCurrent:current];
	[weatherStation setWindHistory:history];
	[weatherStation setWindRoseView:windRose];
	[weatherStation setDirection:directionText];
	[weatherStation setSpeed:speedText];
	[weatherStation loadWeatherData];
//	[weatherStation loadMostRecentWeatherData];
//	[weatherStation loadHistory];
//	NSLog(@"did load most recent weather data ");
//	[weatherStation updateImage];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[imageView setUserInteractionEnabled:YES];
	[history setLabels:[NSArray arrayWithObjects:@"0",@"3",@"6",@"9",@"12",@"15",@"18",@"21",@"24",nil]];
	[current setLabels:[NSArray arrayWithObjects:@"10",@"8",@"6",@"4",@"2",@"0",nil]];
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)showFullSizeImage
{
	LargeImageViewController *largeImage = [[[LargeImageViewController alloc]
									 initWithNibName:@"LargeImageViewController" bundle:nil] autorelease];
	[largeImage setImage:[imageView image]];
    
    
    [self presentViewController:largeImage animated:YES completion:NULL] ;
	
//    [self presentModalViewController:largeImage animated:YES];
}

-(void)didTapOnImage
{
	[self showFullSizeImage];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([[event touchesForView:imageView] count] ) {
		[self didTapOnImage];
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-viewControllers
{
    return @[];
}

-(IBAction)showForecast:sender
{
	NSLog(@"show forecast");
	WindForecastViewController *forecast = [[[WindForecastViewController alloc]
											 initWithNibName:@"WindForecastViewController" bundle:nil] autorelease];
	[forecast loadView];
	NSMutableArray *forecastDays=[NSMutableArray array];
	for (int i=1;i<6;i++) {
		[forecastDays addObject:[weatherStation forecastForDayFromNow:i]];
	}
	NSLog(@"forecasts: %@",forecastDays);
	[forecast setForecastData:forecastDays];
	[self presentModalViewController:forecast animated:YES];
}

- (void)dealloc {
    [super dealloc];
}


-(BOOL)shouldAutorotate
{
    NSLog(@"WindTouchViewController shouldAutorotate");
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"WindTouchViewController supportedInterfaceOrientations");
    return UIInterfaceOrientationMaskPortrait;
}



@end

@implementation UILabel(setValue)

-(void)setIntValue:(int)newValue
{
	[self setText:[NSString stringWithFormat:@"%d",newValue]];
}

-(void)setFloatValue:(double)newValue
{
	[self setText: [NSString stringWithFormat:@"%g",newValue]];
}

@end

