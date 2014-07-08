//
//  ILVersionChecker.h
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/01/30.
//  Copyright (c) 2014年 Masakazu Ohtsuka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOArchiveFetcher.h"

extern NSString * const MOReleaseCheckerErrorDomain;
typedef NS_ENUM ( NSInteger, MOReleaseCheckerError ) {
    MOReleaseCheckerErrorNewerVersionNotFound
};

/// Check github release for a new update
@interface MOGithubReleaseFetcher : NSObject<MOArchiveFetcher>

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *repositoryName;

- (instancetype) initWithUserName:(NSString*)userName repositoryName:(NSString*)repositoryName;

@end
