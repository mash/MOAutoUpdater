//
//  AUZipUnarchiver.m
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/01.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import "AUZipUnarchiver.h"

@implementation AUZipUnarchiver

- (void)unarchiveFile:(NSURL *)filePath completion:(void (^)(NSURL *unarchivedDirectoryPath,NSError* error))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *destinationDirectory = [AUUnarchiver unarchiveDestinationDirectory];

        NSTask *task = [NSTask launchedTaskWithLaunchPath: @"/usr/bin/unzip"
                                                arguments: @[
                                                             @"-n", // never overwrite
                                                             @"-q", // quiet
                                                             [filePath path],
                                                             @"-d", // destination
                                                             destinationDirectory
                        ]];
        [task waitUntilExit];
        int status = [task terminationStatus];

        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (status == EXIT_SUCCESS) {
                    completion( destinationDirectory, nil );
                }
                else {
                    completion( nil, [NSError errorWithDomain: AUUnarchiverErrorDomain code: status userInfo: nil] );
                }
            });
    });
}

@end
