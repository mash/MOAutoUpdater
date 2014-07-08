//
//  MOUpdateChecker.h
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/02.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOArchiveFetcher.h"
#import "MOUnarchiver.h"

@interface MOUpdateChecker : NSObject

@property (nonatomic) NSURL *cacheDirectory;

- (instancetype) initWithFetcher:(id<MOArchiveFetcher>)fetcher
                      unarchiver:(id<MOUnarchiver>)unarchiver
                      validators:(NSArray*)validators;

- (void)checkForVersionNewerThanVersion:(NSString*)currentVersion
                 foundNewerVersionBlock:(void (^)(NSDictionary *releaseInformation, NSURL *unarchivedPath, NSError *error))completion;

@end
