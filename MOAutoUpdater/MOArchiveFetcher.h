//
//  MOFetcher.h
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/02.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MOArchiveFetcher <NSObject>

/// foundNewerVersionBlock is called only when we found a version newer than currentVersion,
/// and will be called in background.
- (void)fetchArchiveNewerThanVersion:(NSString*)currentVersion
                   downloadDirectory:(NSURL*)downloadDirectory
            fetchedNewerArchiveBlock:(void (^)(NSDictionary *releaseInformation, NSURL *downloadedArchive, NSError *error))completion;

@end

@interface MOArchiveFetcher : NSObject

+ (NSURL*)archiveCacheDirectory;

@end
