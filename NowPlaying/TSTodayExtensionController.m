//
//  TodayViewController.m
//  NowPlaying
//
//  Created by Tristan Seifert on 11/20/14.
//  Copyright (c) 2014 Tristan Seifert. All rights reserved.
//

#import "TSFloatToTimeIntervalTransformer.h"
#import "TSUserDefaults.h"
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

/**
 * Registers the value transformers.
 */
+ (void) load {
	// create an autoreleased instance of our value transformer
	TSFloatToTimeIntervalTransformer *t = [[TSFloatToTimeIntervalTransformer alloc] init];
 
	// register it with the name that we refer to it with
	[NSValueTransformer setValueTransformer:t
									forName:@"TSFloatToTimeIntervalTransformer"];
}

/**
 * Ask for new iTunes information, so our preview is updated appropriately.
 */
- (void) widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
	[_itunesController updateiTunesState];
	
    completionHandler(NCUpdateResultNewData);
}

/**
 * Returns the edge insets for the view. We use a value of zero, to give us
 * absolute control over any and all insets.
 */
- (NSEdgeInsets) widgetMarginInsetsForProposedMarginInsets:(NSEdgeInsets) defaultMarginInset {
	return NSEdgeInsetsZero;
}

#pragma mark - NSViewController Notifications
/**
 * Performs some additional view initialisation, once loaded.
 */
- (void) viewDidLoad {
	[super viewDidLoad];
	
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
	
	// Restore UI state
	NSUserDefaults *d = [TSUserDefaults sharedUserDefaults];
	_controlsVisible = [d boolForKey:TSPreferenceOverlayState];
	
	if(!_controlsVisible) {
		// hide the main controls
		_containerMetadata.alphaValue = 0.f;
		_containerControls.alphaValue = 0.f;
		_containerMetadata.hidden = YES;
		_containerControls.hidden = YES;
	}
	
	_volumeUIShown = [d boolForKey:TSPreferenceVolumeState];
	if(!_volumeUIShown) {
		// show volume UI
		_containerVolume.alphaValue = 0.f;
		_containerVolume.hidden = YES;
	}
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
	NSUserDefaults *d = [TSUserDefaults sharedUserDefaults];
	
	// should the UI toggle when clicked?
	BOOL shouldChange = [d boolForKey:TSPreferenceHideOverlay];
	
	if(shouldChange) {
		_controlsVisible = !_controlsVisible;
		
		if(_controlsVisible) {
			[self uiFadeIn];
		} else {
			[self uiFadeOut];
		}
	} else {
		// ensure controls are visible
		if(!_controlsVisible) {
			[self uiFadeIn];
		}
		
		NSLog(@"Ignoring click: control toggling is off");
		
		_controlsVisible = YES;
	}
	
	// save the state of the controls
	[d setBool:_controlsVisible forKey:TSPreferenceOverlayState];
	[d synchronize];
}

#pragma mark - Editing
/**
 * Load the settings controller, and present it modally in the widget.
 */
- (IBAction) showSettings:(id) sender {
	if(!_settingsController) {
		_settingsController = [[TSTodaySettings alloc] initWithNibName:@"TSTodaySettings"
																bundle:[NSBundle bundleForClass:self.class]];
	}
	
	[self presentViewControllerInWidget:_settingsController];
}

/**
 * Shows or hides the volume/EQ user interface.
 */
- (IBAction) showVolumeEQ:(id) sender {
	// Is the volume UI shown?
	if(_volumeUIShown) {
		_containerVolume.alphaValue = 1.f;
		
		[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
			context.duration = 0.5;
			context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
			
			_containerVolume.animator.alphaValue = 0.f;
		} completionHandler:^{
			_containerVolume.hidden = YES;
		}];
	} else {
		// Show the volume control for the first time.
		_containerVolume.alphaValue = 0.f;
		_containerVolume.hidden = NO;
		
		[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
			context.duration = 0.5;
			context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
			
			_containerVolume.animator.alphaValue = 1.f;
		} completionHandler:NULL];
	}
	
	// save volume UI shown state
	_volumeUIShown = !_volumeUIShown;
	
	NSUserDefaults *d = [TSUserDefaults sharedUserDefaults];
	[d setBool:_volumeUIShown forKey:TSPreferenceVolumeState];
	[d synchronize];
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
	} completionHandler:NULL];
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
		
		// if the volume UI is visible, fade it out, too
		if(_volumeUIShown) {
			_containerVolume.animator.alphaValue = 0.f;
		}
	} completionHandler:^{
		// hide the views so they're not processed
		_containerMetadata.hidden = YES;
		_containerControls.hidden = YES;
		
		if(_volumeUIShown) {
			_containerVolume.hidden = YES;
		}
	}];
}

@end

