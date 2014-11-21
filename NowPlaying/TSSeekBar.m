//
//  TSSeekBar.m
//  Meeper
//
//  Created by Tristan Seifert on 11/21/14.
//  Copyright (c) 2014 Tristan Seifert. All rights reserved.
//

#import "TSiTunesController.h"

#import "TSSeekBar.h"

#define kBarFillColour [NSColor colorWithCalibratedRed:(112/255.0f) green:(112/255.0f) blue:(112/255.0f) alpha:1.0]
#define kBarBackgroundColour [NSColor colorWithCalibratedRed:(200/255.0f) green:(200/255.0f) blue:(200/255.0f) alpha:1.0]
#define kBarHeadColour [NSColor colorWithCalibratedRed:(16/255.0f) green:(16/255.0f) blue:(16/255.0f) alpha:1.0]

@interface TSSeekBar ()

- (void) calculateDrag:(NSEvent *) evt;

@end

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
	_currentTime = 0.5f;
	_endTime = 1.f;
	
	_isDragging = NO;
	
	// KVO
	[self addObserver:self forKeyPath:@"currentTime"
			  options:0 context:nil];
	[self addObserver:self forKeyPath:@"endTime"
			  options:0 context:nil];
}

#pragma mark - Drawing
/**
 * Renders the view. This ignores the dirty rect and always draws the entire
 * rect.
 */
- (void) drawRect:(NSRect) dirtyRect {
	// clear view
	[[NSColor clearColor] set];
	NSRectFill(self.bounds);
	
	// fill background
	[kBarBackgroundColour set];
	NSRectFill(NSMakeRect(0, 0, self.bounds.size.width, self.bounds.size.height / 2));
	
	// fill the bar to the appropriate point
	CGFloat widthFilled = (_currentTimeToDraw / _endTime) * self.bounds.size.width;
	NSRect rect = NSMakeRect(0, 0, widthFilled, self.bounds.size.height / 2);
	
	[kBarFillColour set];
	NSRectFill(rect);
	
	// draw the bar: two pixels wide
	rect = NSMakeRect(widthFilled - 1, 0, 2, self.bounds.size.height);
	
	[kBarHeadColour set];
	NSRectFill(rect);
}

#pragma mark - KVO
/**
 * Changed values call this.
 */
- (void) observeValueForKeyPath:(NSString *) keyPath ofObject:(id) object
						 change:(NSDictionary *) change
						context:(void *) context {
	// ignore changes when dragging
	if(_isDragging) return;
	
	// otherwise, take the KVO data
	_currentTimeToDraw = _currentTime;
	
	[self setNeedsDisplay:YES];
}

#pragma mark - Dragging
/**
 * Allow us to receive the mouse events
 */
- (BOOL) acceptsFirstMouse:(NSEvent *) theEvent {
	return YES;
}

/**
 * Mouse down marks the start of dragging.
 */
- (void) mouseDown:(NSEvent *) theEvent {
	_isDragging = YES;
	[self calculateDrag:theEvent];
}

/**
 * Mouse has been dragged; compute the correct positon.
 */
- (void) mouseDragged:(NSEvent *) theEvent {
	[self calculateDrag:theEvent];
}

/**
 * Mouse up marks the end of dragging.
 */
- (void) mouseUp:(NSEvent *) theEvent {
	// update the actual seek position
	_currentTime = _currentTimeToDraw;
	_iTunes.currentPosition = _currentTime;
	
	_isDragging = NO;
}

/**
 * Calculates the new value for currentTime, given the mouse event.
 */
- (void) calculateDrag:(NSEvent *) evt {
	// convert to our coordinate system, and make it in bounds
	NSPoint point = [self.superview convertPoint:evt.locationInWindow
										fromView:nil];
	
	// offset for cursor hotspot
	NSPoint hotSpot = [NSCursor currentCursor].hotSpot;
	CGFloat hotSpotX = hotSpot.x;
	
	point.x -= hotSpotX;
	point.x -= 5;
	
	point.x = MAX(point.x, 0);
	point.x = MIN(point.x, self.bounds.size.width);
	
	// calculate the new time
	CGFloat newTime = point.x / self.bounds.size.width;
	_currentTimeToDraw = newTime * _endTime;
	
	// send a notification to update seeking
	_iTunes.currentPosition = _currentTimeToDraw;
	
	// redraw
	[self setNeedsDisplay:YES];
}

@end
