//
//  TodayViewController.h
//  NowPlaying
//
//  Created by Tristan Seifert on 11/20/14.
//  Copyright (c) 2014 Tristan Seifert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TSiTunesController;
@interface TSTodayExtensionController : NSViewController {
	IBOutlet NSVisualEffectView *_containerMetadata;
	IBOutlet NSVisualEffectView *_containerControls;

	IBOutlet TSiTunesController *_itunesController;
	
	NSTrackingArea *_trackingArea;
}

@end
