//
//  LargeImageViewController.m
//  MusselWind
//
//  Created by Marcel Weiher on 1/9/10.
//  Copyright 2010 Marcel Weiher. All rights reserved.
//

#import "LargeImageViewController.h"


@implementation LargeImageViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[self view] setUserInteractionEnabled:YES];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES; // (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self dismissModalViewControllerAnimated:YES];

}


-(void)setImage:(UIImage*) anImage
{
	CALayer *layer=[[self view] layer];
	[layer setContents:[(id)[anImage CGImage] autorelease]];
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


- (void)dealloc {
    [super dealloc];
}


@end
