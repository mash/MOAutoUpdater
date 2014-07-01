//
//  ILVersionChecker.h
//  IRLauncher
//
//  Created by Masakazu Ohtsuka on 2014/01/30.
//  Copyright (c) 2014年 Masakazu Ohtsuka. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Check github release for a new update
@interface AUGithubReleaseChecker : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *repositoryName;

- (instancetype) initWithUserName:(NSString*)userName repositoryName:(NSString*)repositoryName;

/// foundNewerVersionBlock is called only when we found a version newer than currentVersion
- (void)checkForVersionNewerThanVersion:(NSString*)currentVersion
                      downloadDirectory:(NSString*)downloadDirectory
                 foundNewerVersionBlock:(void (^)(NSString *newVersion, NSString *releaseInformation, NSURL *downloadedArchive, NSError *error))completion;

@end
