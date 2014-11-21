//
//  TodayViewController.m
//  NowPlaying
//
//  Created by Tristan Seifert on 11/20/14.
//  Copyright (c) 2014 Tristan Seifert. All rights reserved.
//

#import "TSiTunesController.h"

#import "TSSeekBar.h"
#import "TSMouseTrackingView.h"
#import "TSTodaySettings.h"
#import "TSTodayExtensionController.h"

#import <QuartzCore/QuartzCore.h>
#import <NotificationCenter/NotificationCenter.h>

@interface TSTodayExtensionController () <NCWidgetProviding>

- (void) mouseClicked:(NSNotification *) n;

- (void) uiFadeIn;
- (void) uiFadeOut;

@end

@implementation TSTodayExtensionController

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    // Update your data and prepare for a snapshot. Call completion handler when you are done
    // with NoData if nothing has changed or NewData if there is new data since the last
    // time we called you
    completionHandler(NCUpdateResultNewData);
}

#pragma mark - NSViewController Notifications
/**
 * Performs some additional view initialisation, once loaded.
 */
- (void) viewDidLoad {
	[super viewDidLoad];
	
	_controlsVisible = YES;
	
	// Subscribe to the appropriate notifications for mouse click
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(mouseClicked:)
												 name:TSMouseTrackingViewMouseDown
											   object:self.view];
	
	// set up bindings manually for the seek bar
	[_seekBar bind:@"endTime" toObject:_itunesController
	   withKeyPath:@"songLength" options:nil];
	[_seekBar bind:@"currentTime" toObject:_itunesController
	   withKeyPath:@"currentPosition" options:nil];
}

/**
 * Performs some cleanup once the view is deallocated.
 */
- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 * Initialises some interface when the view is about to appear.
 */
- (void) viewWillAppear {
	[super viewWillAppear];
	
	[_itunesController enableNotifications];
}

/**
 * Cleans up some structures when the view has gone off-screen.
 */
- (void) viewDidDisappear {
	[super viewDidDisappear];
	
	[_itunesController disableNotifications];
}

#pragma mark - UI
/**
 * Called when the mouse has been clicked.
 */
- (void) mouseClicked:(NSNotification *) n {
	_controlsVisible = !_controlsVisible;
	
	if(_controlsVisible) {
		[self uiFadeIn];
	} else {
		[self uiFadeOut];
	}
}

#pragma mark - Editing
/**
 * Editing begins: show the editing view controller.
 */
- (IBAction) showSettings:(id) sender {
	if(!_settingsController) {
		_settingsController = [[TSTodaySettings alloc] initWithNibName:@"TSTodaySettings"
																bundle:[NSBundle bundleForClass:self.class]];
	}
	
	[self presentViewControllerInWidget:_settingsController];
}

#pragma mark - Mouse Events
/**
 * Fades the UI in.
 */
- (void) uiFadeIn {
	// ensure the views are "visible"
	_containerMetadata.hidden = NO;
	_containerControls.hidden = NO;
	
	[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
		context.duration = 0.5;
		
		// fade them in
		_containerMetadata.animator.alphaValue = 1.f;
		_containerControls.animator.alphaValue = 1.f;
	} completionHandler:^{
		
	}];
}

/**
 * Fades the UI out.
 */
- (void) uiFadeOut {
	[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
		context.duration = 0.5;
		context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		
		// fade them in
		_containerMetadata.animator.alphaValue = 0.f;
		_containerControls.animator.alphaValue = 0.f;
	} completionHandler:^{
		// hide the views so they're not processed
		_containerMetadata.hidden = YES;
		_containerControls.hidden = YES;
	}];
}

/**
 * Returns the edge insets for the view. We use a value of zero, to give us
 * absolute control over any and all insets.
 */
- (NSEdgeInsets) widgetMarginInsetsForProposedMarginInsets:(NSEdgeInsets) defaultMarginInset {
	return NSEdgeInsetsZero;
}

@end

