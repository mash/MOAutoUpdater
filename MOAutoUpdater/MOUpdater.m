//
//  MOUpdater.m
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/01.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import "MOUpdater.h"

NSString * const kMOUpdaterArgumentsBundlePath        = @"bundlePath";
NSString * const kMOUpdaterArgumentsBundleIdentifier  = @"bundleIdentifier";
NSString * const kMOUpdaterArgumentsSource            = @"source";
NSString * const kMOUpdaterArgumentsRelaunchArguments = @"arguments";

NSString * const kMOReleaseInformationUpdatedFlagKey = @"au.updated";
NSString * const kMOReleaseInformationNewVersionKey  = @"au.newVersion";
NSString * const kMOReleaseInformationBodyTextKey    = @"au.body";
NSString * const kMOReleaseInformationURLKey         = @"au.url";

@interface MOUpdater ()

@property (nonatomic) NSURL *sourcePath;

@end

@implementation MOUpdater

- (instancetype) initWithSourcePath:(NSURL*)source {
    self = [super init];
    if (!self) { return nil; }

    _sourcePath = source;

    return self;
}

- (void) runWithArgumentsForRelaunchedApplication:(NSDictionary*)relaunchArguments_ {
    NSBundle *bundle                       = [NSBundle mainBundle];
    NSString *updaterApp                   = [[NSBundle bundleWithPath: [bundle pathForResource: @"Updater" ofType: @"app"]] executablePath];
    NSMutableDictionary *relaunchArguments = [NSMutableDictionary dictionaryWithDictionary: relaunchArguments_];
    relaunchArguments[ kMOReleaseInformationUpdatedFlagKey ] = @YES;
    NSDictionary *plistArg = @{
        kMOUpdaterArgumentsBundlePath        : bundle.bundlePath,
        kMOUpdaterArgumentsBundleIdentifier  : bundle.bundleIdentifier,
        kMOUpdaterArgumentsSource            : _sourcePath.path,
        kMOUpdaterArgumentsRelaunchArguments : relaunchArguments, // passed over to host application
    };
    [NSTask launchedTaskWithLaunchPath: updaterApp
                             arguments: @[ @"-plistArg", plistArg.description ]];
}

#pragma mark - Class methods

+ (BOOL) didRelaunch {
    NSDictionary *relaunchArguments = [[NSUserDefaults standardUserDefaults] volatileDomainForName: NSArgumentDomain];
    return ((NSNumber*)relaunchArguments[ kMOReleaseInformationUpdatedFlagKey ]).boolValue;
}

+ (NSDictionary*) releaseInformation {
    return [[NSUserDefaults standardUserDefaults] volatileDomainForName: NSArgumentDomain];
}

@end
