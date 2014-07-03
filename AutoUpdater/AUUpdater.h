//
//  AutoUpdater.h
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/01.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import <Foundation/Foundation.h>

// These are used in AUAutoUpdater.app
extern NSString * const kAUUpdaterArgumentsBundlePath;
extern NSString * const kAUUpdaterArgumentsBundleIdentifier;
extern NSString * const kAUUpdaterArgumentsSource;
extern NSString * const kAUUpdaterArgumentsRelaunchArguments;

// These are passed to host application,
// thus prefix not to conflict when you use NSUserDefaults in host app.
// Put these here to save one line in host app's AppDelegate.m
extern NSString * const kAUReleaseInformationUpdatedFlagKey;
extern NSString * const kAUReleaseInformationNewVersionKey;
extern NSString * const kAUReleaseInformationBodyTextKey;
extern NSString * const kAUReleaseInformationURLKey;

@interface AUUpdater : NSObject

- (instancetype) initWithSourcePath:(NSURL*)source;
- (void) runWithArgumentsForRelaunchedApplication:(NSDictionary*)relaunchArguments;

+ (BOOL) didRelaunch;
+ (NSDictionary*) releaseInformation;

@end
