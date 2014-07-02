//
//  AUZipUnarchiver.h
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/01.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AUUnarchiver.h"

/// AUZipUnarchiver unzips archive and passes it's child directory
/// named `pathToBundle` as `unarchivedBundlePath` argument to
/// completion callback.
///
/// If you zip AppName.app and upload AppName.app.zip to github,
/// You can provide `[[AUZipUnarchiver alloc] init]` to `AUUpdateChecker`
@interface AUZipUnarchiver : NSObject<AUUnarchiver>

- (instancetype) initWithPathToBundle: (NSString*) pathToBundle;

@end
