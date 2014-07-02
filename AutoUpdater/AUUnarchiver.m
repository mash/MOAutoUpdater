//
//  AUUnarchiver.m
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/01.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import "AUUnarchiver.h"

NSString * const AUUnarchiverErrorDomain = @"AUUnarchiverErrorDomain";

@implementation AUUnarchiver

+ (NSURL*) unarchiveDestinationDirectory {
    NSString *uniqueString = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *path         = [NSTemporaryDirectory() stringByAppendingPathComponent: uniqueString];
    if (![[NSFileManager defaultManager] createDirectoryAtPath: path
                                   withIntermediateDirectories: NO
                                                    attributes: nil
                                                         error: nil]) {
        return nil;
    }
    return [NSURL fileURLWithPath: path];
}

@end