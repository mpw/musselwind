//
//  LargeImageViewController.m
//  MusselWind
//
//  Created by Marcel Weiher on 1/9/10.
//  Copyright 2010 Marcel Weiher. All rights reserved.
//

#import "LargeImageViewController.h"
#import "AccessorMacros.h"

@implementation LargeImageViewController

objectAccessor(UIImageView, imageView, setImageView)
objectAccessor(UIImage, image, setImage)

-(UIScrollView*)scrollView
{
    return (UIScrollView*)[self view];
}

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
    [[self imageView] setImage:[self image]];
    [[self scrollView] addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)] autorelease]];
//	[[self view] setUserInteractionEnabled:YES];
//    [[self scrollView] setMaximumZoomScale:4.0];
//    [[self scrollView] setMinimumZoomScale:1.0];
}

-viewForZoomingInScrollView:aScrollView
{
    return [self imageView];
}

-(void)didTap:(UITapGestureRecognizer*)recognizer
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    NSLog(@"shouldAutorotateToInterfaceOrientation: %d",interfaceOrientation);
    return YES; // (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    NSLog(@"ImageViewController shouldAutorotate");
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"ImageViewController supportedInterfaceOrientations");
    return UIInterfaceOrientationMaskAll;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)newOrientation duration:(NSTimeInterval)timeToRotate
{
    NSLog(@"will rotate to %d in %g s",newOrientation,timeToRotate);
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [[self scrollView] setNeedsLayout];
    [[self scrollView] setNeedsDisplay];
    NSLog(@"did rotate from %d",fromInterfaceOrientation);
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
