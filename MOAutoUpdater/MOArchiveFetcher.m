//
//  MOFetcher.m
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/02.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import "MOArchiveFetcher.h"

@implementation MOArchiveFetcher

+ (NSURL*)archiveCacheDirectory {
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory: NSCachesDirectory inDomains: NSUserDomainMask];
    NSURL *ret    = urls[ 0 ];

    return [[ret URLByAppendingPathComponent: [NSBundle mainBundle].bundleIdentifier]
            URLByAppendingPathComponent: @"AutoUpdater"];
}

@end
