//
//  AUUpdateChecker.h
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/02.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AUArchiveFetcher.h"
#import "AUUnarchiver.h"

extern NSString * const kAUReleaseInformationNewVersionKey;
extern NSString * const kAUReleaseInformationBodyTextKey;

@interface AUUpdateChecker : NSObject

- (instancetype) initWithFetcher:(id<AUArchiveFetcher>)fetcher
                      unarchiver:(id<AUUnarchiver>)unarchiver
                      validators:(NSArray*)validators;

- (void)checkForVersionNewerThanVersion:(NSString*)currentVersion
                 foundNewerVersionBlock:(void (^)(NSDictionary *releaseInformation, NSURL *unarchivedPath, NSError *error))completion;

@end