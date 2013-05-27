//
//  WindRoseView.m
//  MusselWind
//
//  Created by Marcel Weiher on 21.11.09.
//  Copyright 2009 Marcel Weiher. All rights reserved.
//

#import "WindRoseView.h"
#import "WindObservation.h"
#import "WindSampleListDrawing.h"

@implementation WindRoseView

objectAccessor( WindSampleList, observations, _setObservations )
boolAccessor( drawBackground, setDrawBackground )
objectAccessor( NSTimer, timer, setTimer )
boolAccessor( animating, setAnimating )
intAccessor( currentObservation, _setCurrentObservation )


static id kStopWindRoseAnimations=@"stopWindRoseAnimations";

-(void)setObservations:(WindSampleList *)newVar
{
	[self _setObservations:newVar];
	[self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self setOpaque:YES];
		[self setDrawBackground:YES];
		UITapGestureRecognizer* tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)] autorelease];
		[tap setNumberOfTapsRequired:1];
		[self addGestureRecognizer:tap];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimation) name:kStopWindRoseAnimations object:nil];
    }
    return self;
}

-(void)stopAnimationTimer
{
	[[self timer] invalidate];
	[self setTimer:nil];
}
-(void)stopAnimation
{
	NSLog(@"stopAnimation");
	[self stopAnimationTimer];
	[self setAnimating:NO]; 
}

-(void)setCurrentObservation:(int)newObservation
{
	if ( newObservation >= [[self observations] count] ) {
		newObservation=0;
	}
	[self _setCurrentObservation:newObservation];
}

-(void)stopAllWindroses
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kStopWindRoseAnimations object:nil];
}

-(void)startAnimationTimer
{
	if ( animating ) {
		[self setTimer:[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateRose) userInfo:nil repeats:YES]];
	}
}

-(void)startAnimation
{
	[self stopAllWindroses];
	[self setAnimating:YES];
	[self setCurrentObservation:0];
	[self startAnimationTimer];
}

-(void)pauseAnimationForSeconds:(NSTimeInterval)secondsToPause
{
	[self stopAnimationTimer];
	[self performSelector:@selector(startAnimationTimer) withObject:nil afterDelay:secondsToPause];
}

-(void)animateRose
{
	int newObservation=[self currentObservation]+1;
	[self setCurrentObservation:newObservation];
	if ( newObservation >= [[self observations] count] ) {
		[self pauseAnimationForSeconds:1.0];
	} else {
		[self setNeedsDisplay];	
	}
}

-(void)startOrStopAnimation
{
	if ( animating ) {
		[self stopAnimation]; 
	} else {
		[self startAnimation];
	}
}

-(void)singleTap:(UITapGestureRecognizer*)recognizer
{
	NSLog(@"single tap");
	[self startOrStopAnimation];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	[self singleTap:nil];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {}



-(void)awakeFromNib
{
	[self setBackgroundColor:[[self superview] backgroundColor]];
	[self setDrawBackground:YES];
}


-(void)drawRect:(NSRect)rect onContext:(id <MPWDrawingContext>)context {
	if ( [self drawBackground] ) {
		[WindSampleList drawWindRoseBackgroundInRect:[self bounds]  context:context];
	} else {
		[WindSampleList drawWindRoseBackgroundInRect:[self bounds]  context:context minCircle:2 maxCircle:3];
		
	}
	if ( [self animating] ) {
		[[self observations] drawWindRoseInRect:[self bounds]  context:context highlight:[self currentObservation]];
	} else {
		[[self observations] drawWindRoseInRect:[self bounds]  context:context];
	}
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self stopAnimation];
	[observations release];
	[timer release];
    [super dealloc];
}


@end
