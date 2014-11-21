//
//  TSSeekBar.m
//  Meeper
//
//  Created by Tristan Seifert on 11/21/14.
//  Copyright (c) 2014 Tristan Seifert. All rights reserved.
//

#import "TSSeekBar.h"

@implementation TSSeekBar

/// When initialised from code
- (id) initWithFrame:(NSRect) frameRect {
	if(self = [super initWithFrame: frameRect]) {
		[self commonInit];
	}
	
	return self;
}

/// When initialised through a NIB
- (id) initWithCoder:(NSCoder *)coder {
	if(self = [super initWithCoder:coder]) {
		[self commonInit];
	}
	
	return self;
}

/**
 * Initialises the view, by loading some resources and initialising state.
 */
- (void) commonInit {
	_currentTime = 0.5;
	_endTime = 1.f;
	
	// load images
	_imageLeftFill = [NSImage imageNamed:@"SliderFilled"];
	NSAssert(_imageLeftFill, @"Couldn't load left fill image");
	
	_imageKnob = [NSImage imageNamed:@"SliderHead"];
	NSAssert(_imageKnob, @"Couldn't load knob image");
	
	_imageRightFill = [NSImage imageNamed:@"SliderEmpty"];
	NSAssert(_imageRightFill, @"Couldn't load right fill image");
}

/**
 * Renders the view.
 */
- (void) drawRect:(NSRect) dirtyRect {
	
}

#pragma mark - KVO
/**
 * Changed values call this.
 */
- (void) didChangeValueForKey:(NSString *) key {
	NSLog(@"%f %f", _currentTime, _endTime);
	[self setNeedsDisplay:YES];
}

@end
