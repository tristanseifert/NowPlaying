//
//  TodayViewController.m
//  NowPlaying
//
//  Created by Tristan Seifert on 11/20/14.
//  Copyright (c) 2014 Tristan Seifert. All rights reserved.
//

#import "TSiTunesController.h"

#import "TSTodaySettings.h"
#import "TSTodayExtensionController.h"

#import <NotificationCenter/NotificationCenter.h>

@interface TSTodayExtensionController () <NCWidgetProviding>

- (void) setUpTrackingRect;
- (void) destroyTrackingRect;

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
}

/**
 * Initialises some interface when the view is about to appear.
 */
- (void) viewWillAppear {
	[super viewWillAppear];
	
	[_itunesController enableNotifications];
}

/**
 * Sets up the tracking area, directly after the view appeared.
 */
- (void) viewDidAppear {
	[super viewDidAppear];
	
	[self setUpTrackingRect];
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
 * Sets up a tracking rect on the view. When the mouse enters the view, fade in
 * the controls and metadata: otherwise, fade out.
 */
- (void) setUpTrackingRect {
	_trackingArea = [[NSTrackingArea alloc] initWithRect:self.view.bounds
												 options:NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect
												   owner:self
												userInfo:nil];
	
	// add to this view
	[self.view addTrackingArea:_trackingArea];
}

/**
 * Cleans up the tracking rect.
 */
- (void) destroyTrackingRect {
	[self.view removeTrackingArea:_trackingArea];
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
		context.duration = 0.33;
		
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
		context.duration = 0.33;
		
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

