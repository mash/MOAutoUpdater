//
//  AUUpdateChecker.m
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/02.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import "AUUpdateChecker.h"
#import "AULog.h"
#import "AUValidator.h"

@interface AUUpdateChecker ()

@property (nonatomic) id<AUArchiveFetcher> fetcher;
@property (nonatomic) id<AUUnarchiver> unarchiver;
@property (nonatomic) NSArray *validators;

@end

@implementation AUUpdateChecker

- (instancetype) initWithFetcher:(id<AUArchiveFetcher>)fetcher
                      unarchiver:(id<AUUnarchiver>)unarchiver
                      validators:(NSArray*)validators {
    self = [super init];
    if (!self) { return nil; }

    _fetcher        = fetcher;
    _unarchiver     = unarchiver;
    _validators     = validators;
    _cacheDirectory = [AUArchiveFetcher archiveCacheDirectory];

    return self;
}

- (void)checkForVersionNewerThanVersion:(NSString*)currentVersion
                 foundNewerVersionBlock:(void (^)(NSDictionary *releaseInformation, NSURL *unarchivedPath, NSError *error))completion {

    [_fetcher fetchArchiveNewerThanVersion: currentVersion
                         downloadDirectory: _cacheDirectory
                  fetchedNewerArchiveBlock:^(NSDictionary *releaseInformation, NSURL *downloadedArchive, NSError *error) {

        AULOG( @"releaseInformation: %@, downloadedArchive: %@, error: %@", releaseInformation, downloadedArchive, error );

        if (error) {
            completion( nil, nil, error );
            return;
        }

        [_unarchiver unarchiveFile: downloadedArchive completion:^(NSURL *unarchivedBundlePath, NSError *error) {
                AULOG( @"unarchivedBundlePath: %@, error: %@", unarchivedBundlePath, error );

                if (error) {
                    completion( nil, nil, error );
                    return;
                }

                for (int i=0; i<_validators.count; i++) {
                    id<AUValidator> validator = _validators[ i ];
                    NSError *validationError = nil;
                    if (![validator bundleIsValidAtPath: unarchivedBundlePath.path error: &validationError]) {
                        completion( nil, nil, validationError );
                        return;
                    }
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                        completion( releaseInformation, unarchivedBundlePath, error );
                    });
            }];
    }];
}

@end
