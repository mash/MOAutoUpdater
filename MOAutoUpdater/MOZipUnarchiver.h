//
//  MOZipUnarchiver.h
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/01.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOUnarchiver.h"

/// MOZipUnarchiver unzips archive and passes it's child directory
/// named `pathToBundle` as `unarchivedBundlePath` argument to
/// completion callback.
///
/// If you zip AppName.app and upload AppName.app.zip to github,
/// You can provide `[[MOZipUnarchiver alloc] init]` to `MOUpdateChecker`
@interface MOZipUnarchiver : NSObject<MOUnarchiver>

- (instancetype) initWithPathToBundle: (NSString*) pathToBundle;

@end
