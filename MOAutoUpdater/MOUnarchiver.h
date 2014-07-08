//
//  MOUnarchiver.h
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/01.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const MOUnarchiverErrorDomain;

// zip command's exit status code is documented to be 0-19
// Use negative values for our custom errors
typedef NS_ENUM ( NSInteger, MOUnarchiverErrorKey ) {
    MOUnarchiverErrorBundleNotFound = -1,
};

@protocol MOUnarchiver <NSObject>

- (void)unarchiveFile:(NSURL *)filePath completion:(void (^)(NSURL *unarchivedBundlePath,NSError* error))completion;

@end

@interface MOUnarchiver : NSObject

+ (NSURL*) unarchiveDestinationDirectory;

@end
