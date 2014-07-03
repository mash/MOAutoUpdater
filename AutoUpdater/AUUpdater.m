//
//  AutoUpdater.m
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/01.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import "AUUpdater.h"

NSString * const kAUUpdaterArgumentsBundlePath        = @"bundlePath";
NSString * const kAUUpdaterArgumentsBundleIdentifier  = @"bundleIdentifier";
NSString * const kAUUpdaterArgumentsSource            = @"source";
NSString * const kAUUpdaterArgumentsRelaunchArguments = @"arguments";

NSString * const kAUReleaseInformationUpdatedFlagKey = @"au.updated";
NSString * const kAUReleaseInformationNewVersionKey  = @"au.newVersion";
NSString * const kAUReleaseInformationBodyTextKey    = @"au.body";
NSString * const kAUReleaseInformationURLKey         = @"au.url";

@interface AUUpdater ()

@property (nonatomic) NSURL *sourcePath;

@end

@implementation AUUpdater

- (instancetype) initWithSourcePath:(NSURL*)source {
    self = [super init];
    if (!self) { return nil; }

    _sourcePath = source;

    return self;
}

- (void) runWithArgumentsForRelaunchedApplication:(NSDictionary*)relaunchArguments_ {

    NSBundle *bundle                       = [NSBundle mainBundle];
    NSString *updaterApp                   = [NSString pathWithComponents: @[ bundle.bundlePath, @"/Contents/Resources/AutoUpdater.app" ]];
    NSMutableDictionary *relaunchArguments = [NSMutableDictionary dictionaryWithDictionary: relaunchArguments_];
    relaunchArguments[ kAUReleaseInformationUpdatedFlagKey ] = @YES;
    NSDictionary *plistArg = @{
        kAUUpdaterArgumentsBundlePath        : bundle.bundlePath,
        kAUUpdaterArgumentsBundleIdentifier  : bundle.bundleIdentifier,
        kAUUpdaterArgumentsSource            : _sourcePath.path,
        kAUUpdaterArgumentsRelaunchArguments : relaunchArguments, // passed over to host application
    };
    [NSTask launchedTaskWithLaunchPath: updaterApp
                             arguments: @[ @"-plistArg", plistArg.description ]];
}

#pragma mark - Class methods

+ (BOOL) didRelaunch {
    NSDictionary *relaunchArguments = [[NSUserDefaults standardUserDefaults] volatileDomainForName: NSArgumentDomain];
    return ((NSNumber*)relaunchArguments[ kAUReleaseInformationUpdatedFlagKey ]).boolValue;
}

+ (NSDictionary*) releaseInformation {
    return [[NSUserDefaults standardUserDefaults] volatileDomainForName: NSArgumentDomain];
}

@end
