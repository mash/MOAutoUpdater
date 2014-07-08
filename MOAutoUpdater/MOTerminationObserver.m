//
//  MOTerminationListener.m
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/01.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import "MOTerminationObserver.h"

NSString * const MOErrorDomain = @"MOErrorDomain";

static const NSTimeInterval kMOTerminationPollingInterval = 0.5;

@interface MOTerminationObserver ()

@property (nonatomic) NSTimer *timeoutTimer;
@property (nonatomic) NSTimer *pollingTimer;

@property (nonatomic) NSString *bundleIdentifier;
@property (nonatomic, copy) void (^completion)(NSError* error);

@end

@implementation MOTerminationObserver

- (void) observeTerminationOfBundleIdentifier:(NSString*)bundleIdentifier
                                   completion:(void (^)(NSError *))completion {
    _bundleIdentifier = bundleIdentifier;
    _completion       = completion;

    if (_timeoutTimer) {
        [_timeoutTimer invalidate];
    }
    if (_pollingTimer) {
        [_pollingTimer invalidate];
    }

    _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval: _timeout
                                                     target: self
                                                   selector: @selector(timeoutTimerFired:)
                                                   userInfo: nil
                                                    repeats: NO];
    _pollingTimer = [NSTimer scheduledTimerWithTimeInterval: kMOTerminationPollingInterval
                                                     target: self
                                                   selector: @selector(pollingTimerFired:)
                                                   userInfo: nil
                                                    repeats: YES];
    [_pollingTimer fire];
}

- (void) dealloc {
    _completion = nil;
    [self invalidateTimers];
}

- (void) invalidateTimers {
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;
    [_pollingTimer invalidate];
    _pollingTimer = nil;
}

#pragma mark - Timers

- (void) timeoutTimerFired:(NSTimer*)timer {
    [self invalidateTimers];
    _completion( [NSError errorWithDomain: MOErrorDomain code: MOErrorCodeTimeout userInfo: nil] );
    _completion = nil;
}

- (void) pollingTimerFired:(NSTimer*)timer {
    NSArray *processes = [NSRunningApplication runningApplicationsWithBundleIdentifier: _bundleIdentifier];
    if (processes.count == 0) {
        [self invalidateTimers];
        _completion( nil );
        _completion = nil;
    }
}

@end
