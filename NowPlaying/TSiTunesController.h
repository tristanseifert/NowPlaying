//
//  TSiTunesController.h
//  Meeper
//
//  Created by Tristan Seifert on 11/20/14.
//  Copyright (c) 2014 Tristan Seifert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ScriptingBridge/ScriptingBridge.h>

@class iTunesApplication;


@interface TSiTunesController : NSObject {
	iTunesApplication *_iTunes;
	
	NSTimer *_timer;
}

@property (nonatomic, readonly) NSString *songTitle;
@property (nonatomic, readonly) NSString *songArtist;
@property (nonatomic, readonly) NSString *songAlbum;

@property (nonatomic, readonly) NSImage *songCoverArt;

@property (nonatomic, readonly) NSImage *playPauseIcon;

@property (nonatomic, readonly) BOOL iTunesActive;

@property (nonatomic, readonly) CGFloat songLength;
@property (nonatomic, readwrite) CGFloat currentPosition;

@property (nonatomic, readwrite) CGFloat volume;

- (void) enableNotifications;
- (void) disableNotifications;

- (void) updateiTunesState;

// UI Actions
- (IBAction) actionPrev:(id) sender;
- (IBAction) actionNext:(id) sender;
- (IBAction) actionPlayPause:(id) sender;

@end
