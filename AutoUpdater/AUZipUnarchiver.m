//
//  AUZipUnarchiver.m
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/01.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import "AUZipUnarchiver.h"

@interface AUZipUnarchiver ()

@property (nonatomic) NSString *pathToBundle;

@end

@implementation AUZipUnarchiver

- (instancetype) init {
    return [self initWithPathToBundle: [NSBundle mainBundle].bundlePath.lastPathComponent];
}

- (instancetype) initWithPathToBundle: (NSString*) pathToBundle {
    self = [super init];
    if (!self) { return nil; }

    _pathToBundle = pathToBundle;

    return self;
}

- (void)unarchiveFile:(NSURL *)filePath completion:(void (^)(NSURL *unarchivedBundlePath,NSError* error))completion {
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
                NSURL *bundlePath = [destinationDirectory URLByAppendingPathComponent: _pathToBundle];

                if (![[NSFileManager defaultManager] fileExistsAtPath: bundlePath.path]) {
                    completion( nil, [NSError errorWithDomain: AUUnarchiverErrorDomain code: AUUnarchiverErrorBundleNotFound userInfo: nil] );
                    return;
                }

                if (status == EXIT_SUCCESS) {
                    completion( bundlePath, nil );
                }
                else {
                    // zip command's exit status code is documented to be 0-19
                    completion( nil, [NSError errorWithDomain: AUUnarchiverErrorDomain code: status userInfo: nil] );
                }
            });
    });
}

@end
