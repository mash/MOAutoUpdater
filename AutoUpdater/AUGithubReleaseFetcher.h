//
//  ILVersionChecker.h
//  IRLauncher
//
//  Created by Masakazu Ohtsuka on 2014/01/30.
//  Copyright (c) 2014年 Masakazu Ohtsuka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AUArchiveFetcher.h"

extern NSString * const AUReleaseCheckerErrorDomain;
typedef NS_ENUM ( NSInteger, AUReleaseCheckerError ) {
    AUReleaseCheckerErrorNewerVersionNotFound
};

/// Check github release for a new update
@interface AUGithubReleaseFetcher : NSObject<AUArchiveFetcher>

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *repositoryName;

- (instancetype) initWithUserName:(NSString*)userName repositoryName:(NSString*)repositoryName;

@end
