//
//  MOUpdater.h
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/01.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import <Foundation/Foundation.h>

// These are used in MOAutoUpdater.app
extern NSString * const kMOUpdaterArgumentsBundlePath;
extern NSString * const kMOUpdaterArgumentsBundleIdentifier;
extern NSString * const kMOUpdaterArgumentsSource;
extern NSString * const kMOUpdaterArgumentsRelaunchArguments;

// These are passed to host application,
// thus prefix not to conflict when you use NSUserDefaults in host app.
// Put these here to save one line in host app's AppDelegate.m
extern NSString * const kMOReleaseInformationUpdatedFlagKey;
extern NSString * const kMOReleaseInformationNewVersionKey;
extern NSString * const kMOReleaseInformationBodyTextKey;
extern NSString * const kMOReleaseInformationURLKey;

@interface MOUpdater : NSObject

- (instancetype) initWithSourcePath:(NSURL*)source;
- (void) runWithArgumentsForRelaunchedApplication:(NSDictionary*)relaunchArguments;

+ (BOOL) didRelaunch;
+ (NSDictionary*) releaseInformation;

@end
