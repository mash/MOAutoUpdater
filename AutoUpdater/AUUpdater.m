//
//  AutoUpdater.m
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/01.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import "AUUpdater.h"

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

- (void) run {
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    NSString *updaterApp = [NSString pathWithComponents: @[ bundlePath, @"/Contents/Resources/AutoUpdater.app" ]];
    [NSTask launchedTaskWithLaunchPath: updaterApp
                             arguments: @[ [NSBundle mainBundle].bundleIdentifier,
                                          bundlePath,
                                          [_sourcePath path] ]];
}

@end
