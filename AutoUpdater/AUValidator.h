//
//  AUValidator.h
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/02.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const AUValidatorErrorDomain;
typedef NS_ENUM ( NSInteger, AUValidationErrorKey ) {
    AUValidatorErrorCodeSignInvalid
};

@protocol AUValidator <NSObject>

- (BOOL)bundleIsValidAtPath:(NSString *)destinationPath error:(NSError **)error;

@end

@interface AUValidator : NSObject

@end
