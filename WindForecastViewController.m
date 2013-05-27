//
//  WindForecastViewController.m
//  MusselWind
//
//  Created by Marcel Weiher on 3/7/10.
//  Copyright 2010 Marcel Weiher. All rights reserved.
//

#import "WindForecastViewController.h"
#import "WindRoseView.h"
#import "WindHistoryTouchView.h"
#import "WindSampleList.h"
#import "WindObservation.h"

@implementation WindForecastViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"view: %@ with subviews: %@",[self view],[[self view] subviews]);
	NSLog(@"rose: %@ superview %@",sampleWindRose,[sampleWindRose superview]);
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"rose: %@",sampleWindRose);
}


-(void)setForecastData:(NSArray*)forecastDays
{
	//	NSLog(@"set forecast %@ rose %@",data,sampleWindRose);
	for (int j=0; j<[forecastDays count];j++) {
		WindSampleList *data=[forecastDays objectAtIndex:j];
		if ( [data count] ) {
			NSDate *day=[[data minDate] dateByAddingTimeInterval:3700];
			BOOL isGood=NO;
			for ( WindObservation *sample in [data samples] ) {
				if ( [sample isGood] ) {
					isGood=YES; break;
				}
			}
			NSDateFormatter *formatter = [[[NSDateFormatter alloc] init]  autorelease]; 
			[formatter setDateFormat:@"EEEE"];
			float verticalOffset = j*90+26;
			float height = 60;
			
			CGRect graphRect=CGRectMake( 10, verticalOffset , 240, height );
			WindHistoryTouchView* newGraph=[[[WindHistoryTouchView alloc] initWithFrame:graphRect] autorelease];
			[newGraph setBackgroundColor:[UIColor whiteColor]];
			[newGraph setLabels:[NSArray arrayWithObjects:@"0",@"3",@"6",@"9",@"12",@"15",@"18",@"21",@"24",nil]];
			[[self view] addSubview: newGraph];
			[newGraph setForecast:data];
			CGRect windRoseRect=CGRectMake( 256, verticalOffset , height, height );
			WindRoseView* newRose=[[[WindRoseView alloc] initWithFrame:windRoseRect] autorelease];
			[newRose setBackgroundColor:[UIColor whiteColor]];
			[newRose setObservations:data];
			[newRose setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0]];
			[newRose setDrawBackground:NO];
			[[self view] addSubview: newRose];
			
			CGRect textRect = CGRectMake( 10, verticalOffset-18 ,90, 16 );
			UILabel *newLabel=[[[UILabel alloc] initWithFrame:textRect] autorelease];
			
			[newLabel setText:[formatter stringFromDate:day]];
			[newLabel setTextColor:[UIColor blackColor]];
			[newLabel setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0]];
			[newLabel setFont:isGood ? [UIFont boldSystemFontOfSize:14] : [UIFont systemFontOfSize:14] ];
			[newRose setDrawBackground:NO];
			
			[newLabel setTextAlignment:UITextAlignmentLeft];
			//			NSLog(@"newLabel: %@",newLabel);
			[[self view] addSubview: newLabel];
		}
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self dismissModalViewControllerAnimated:YES];
}


- (void)dealloc {
    [super dealloc];
}


@end
