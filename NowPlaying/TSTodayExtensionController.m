//
//  TodayViewController.m
//  NowPlaying
//
//  Created by Tristan Seifert on 11/20/14.
//  Copyright (c) 2014 Tristan Seifert. All rights reserved.
//

#import "TSTodayExtensionController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TSTodayExtensionController () <NCWidgetProviding>

@end

@implementation TSTodayExtensionController

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    // Update your data and prepare for a snapshot. Call completion handler when you are done
    // with NoData if nothing has changed or NewData if there is new data since the last
    // time we called you
    completionHandler(NCUpdateResultNoData);
}

/**
 * Returns the edge insets for the view. We use a value of zero, to give us
 * absolute control over any and all insets.
 */
- (NSEdgeInsets) widgetMarginInsetsForProposedMarginInsets:(NSEdgeInsets) defaultMarginInset {
	return NSEdgeInsetsZero;
}

@end

