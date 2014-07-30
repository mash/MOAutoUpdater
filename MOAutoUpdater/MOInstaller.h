//
//  MOInstaller.h
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/01.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOInstaller : NSObject

- (instancetype) initWithDestinationPath:(NSString*)destinationPath
                              sourcePath:(NSString*)sourcePath;

// completion called in main thread
- (void) installWithCompletion: (void (^)(NSError *error))completion;

@end
