//
//  MOUpdateChecker.m
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/02.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import "MOUpdateChecker.h"
#import "MOLog.h"
#import "MOValidator.h"

@interface MOUpdateChecker ()

@property (nonatomic) id<MOArchiveFetcher> fetcher;
@property (nonatomic) id<MOUnarchiver> unarchiver;
@property (nonatomic) NSArray *validators;

@end

@implementation MOUpdateChecker

- (instancetype) initWithFetcher:(id<MOArchiveFetcher>)fetcher
                      unarchiver:(id<MOUnarchiver>)unarchiver
                      validators:(NSArray*)validators {
    self = [super init];
    if (!self) { return nil; }

    _fetcher        = fetcher;
    _unarchiver     = unarchiver;
    _validators     = validators;
    _cacheDirectory = [MOArchiveFetcher archiveCacheDirectory];

    return self;
}

- (void)checkForVersionNewerThanVersion:(NSString*)currentVersion
                 foundNewerVersionBlock:(void (^)(NSDictionary *releaseInformation, NSURL *unarchivedPath, NSError *error))completion {

    [_fetcher fetchArchiveNewerThanVersion: currentVersion
                         downloadDirectory: _cacheDirectory
                  fetchedNewerArchiveBlock:^(NSDictionary *releaseInformation, NSURL *downloadedArchive, NSError *error) {

        MOLOG( @"releaseInformation: %@, downloadedArchive: %@, error: %@", releaseInformation, downloadedArchive, error );

        if (error) {
            completion( nil, nil, error );
            return;
        }

        [_unarchiver unarchiveFile: downloadedArchive completion:^(NSURL *unarchivedBundlePath, NSError *error) {
                MOLOG( @"unarchivedBundlePath: %@, error: %@", unarchivedBundlePath, error );

                if (error) {
                    completion( nil, nil, error );
                    return;
                }

                for (int i=0; i<_validators.count; i++) {
                    id<MOValidator> validator = _validators[ i ];
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
