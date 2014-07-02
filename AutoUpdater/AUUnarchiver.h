//
//  AUUnarchiver.h
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/01.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const AUUnarchiverErrorDomain;

@protocol AUUnarchiver <NSObject>

- (void)unarchiveFile:(NSURL *)filePath completion:(void (^)(NSURL *unarchivedDirectoryPath,NSError* error))completion;

@end

@interface AUUnarchiver : NSObject

+ (NSURL*) unarchiveDestinationDirectory;

@end