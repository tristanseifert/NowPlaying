//
//  TSiTunesController.m
//  Meeper
//
//  Created by Tristan Seifert on 11/20/14.
//  Copyright (c) 2014 Tristan Seifert. All rights reserved.
//

#import "iTunes.h"

#import "TSiTunesController.h"

@interface TSiTunesController ()

- (void) registerNotifications;
- (void) configureScriptingBridge;

- (void) playbackStateChanged:(NSNotification *) n;
- (void) updateiTunesState;

@end

@implementation TSiTunesController

/**
 * Initialises the iTunes controller. Establishes the scripting bridge, but does
 * note set up a timer for communications yet.
 */
- (id) init {
	if(self = [super init]) {
		_iTunesActive = NO;
		
		_playPauseIcon = [NSImage imageNamed:@"IconPlay"];
		
		[self registerNotifications];
		[self configureScriptingBridge];
	}
	
	return self;
}

/**
 * Signs up for all requested notifications, then suspends the center. Configure
 * notifications so that they are queued until the suspension is lifted.
 */
- (void) registerNotifications {
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self
														selector:@selector(playbackStateChanged:)
															name:@"com.apple.iTunes.playerInfo"
														  object:nil
											  suspensionBehavior:NSNotificationSuspensionBehaviorCoalesce];
	
	[self disableNotifications];
}

/**
 * Cleans up internal state by removing us from the dispatch table. Avoids nasty
 * crashes later.
 */
- (void) dealloc {
	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

/**
 * Attempts to get scripting bridge representations for iTunes.
 */
- (void) configureScriptingBridge {
	_iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
}

#pragma mark - iTunes Notifications
/**
 * Responds to an iTunes distributed notification on playback state change.
 */
- (void) playbackStateChanged:(NSNotification *) n {
	[self updateiTunesState];
}

/**
 * Updates the internal state, in response to a notification, or something of
 * the sort.
 */
- (void) updateiTunesState {
	// KVO
	[self willChangeValueForKey:@"songTitle"];
	[self willChangeValueForKey:@"songArtist"];
	[self willChangeValueForKey:@"songAlbum"];
	[self willChangeValueForKey:@"songCoverArt"];
	[self willChangeValueForKey:@"iTunesActive"];
	[self willChangeValueForKey:@"playPauseIcon"];
	
	_iTunesActive = _iTunes.isRunning;
	
	// check if iTunes is running
	if(_iTunesActive) {
		iTunesTrack *track = [[_iTunes currentTrack] get];
		
		// is this track existent?
		if(track.exists) {
			// general metadata
			_songTitle = track.name;
			_songArtist = track.artist;
			_songAlbum = track.album;
			
			// is there any artwork available?
			SBElementArray *artworks = track.artworks;
			if(artworks.count) {
				// if so, pick the first piece of artwork.
				iTunesArtwork *cover = [artworks[0] get];
				
				// hack alert: we could use .data, but that works only sometimes.
				NSData *data = [((iTunesArtwork *) [cover get]) rawData];
				NSImage *image = [[NSImage alloc] initWithData:data];
				
				_songCoverArt = image;
			} else {
				_songCoverArt = [NSImage imageNamed:@"DefaultCover"];
			}
		} else {
			_songTitle = nil;
			_songArtist = nil;
			_songAlbum = nil;
			_songCoverArt = [NSImage imageNamed:@"DefaultCover"];
			
			_iTunesActive = NO;
			
			NSLog(@"Cannot get track (not playing?)");
		}
	} else {
		_songTitle = nil;
		_songArtist = nil;
		_songAlbum = nil;
		_songCoverArt = [NSImage imageNamed:@"DefaultCover"];
	}
	
	// Update play button image
	if(_iTunes.playerState == iTunesEPlSPlaying) {
		_playPauseIcon = [NSImage imageNamed:@"IconPause"];
	} else if(_iTunes.playerState == iTunesEPlSPaused) {
		_playPauseIcon = [NSImage imageNamed:@"IconPlay"];
	}
	
	// KVO
	[self didChangeValueForKey:@"songTitle"];
	[self didChangeValueForKey:@"songArtist"];
	[self didChangeValueForKey:@"songAlbum"];
	[self didChangeValueForKey:@"songCoverArt"];
	[self didChangeValueForKey:@"iTunesActive"];
	[self didChangeValueForKey:@"playPauseIcon"];
}

#pragma mark - External Calls
/**
 * Begin registering notifications. This forces an update with new state, when
 * called, and begins listening for certain kinds of notifications.
 */
- (void) enableNotifications {
	[NSDistributedNotificationCenter defaultCenter].suspended = NO;
	NSLog(@"Enabled notifications");
	
	[self updateiTunesState];
}

/**
 * De-registers for notifications.
 */
- (void) disableNotifications {
	[NSDistributedNotificationCenter defaultCenter].suspended = YES;
	NSLog(@"Disabled notifications");
}

#pragma mark - UI Actions
/**
 * Goes to the previous track.
 */
- (IBAction) actionPrev:(id) sender {
	if(_iTunes.isRunning) {
		[_iTunes previousTrack];
	}
}

/**
 * Goes to the next track.
 */
- (IBAction) actionNext:(id) sender {
	if(_iTunes.isRunning) {
		[_iTunes nextTrack];
	}
}

/**
 * Plays or pauses the current track, depending on its state. Also updates the
 * button.
 */
- (IBAction) actionPlayPause:(id) sender {
	if(_iTunes.playerState == iTunesEPlSPaused) {
		[_iTunes resume];
	} else if(_iTunes.playerState == iTunesEPlSPlaying) {
		[_iTunes pause];
	}
	
	// force updating of state
}

@end
