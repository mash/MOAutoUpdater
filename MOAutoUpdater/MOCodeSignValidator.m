//
//  MOCodeSignValidator.m
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/02.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import "MOCodeSignValidator.h"
#import "SUCodeSigningVerifier.h"

@implementation MOCodeSignValidator

- (BOOL)bundleIsValidAtPath:(NSString *)destinationPath error:(NSError **)error {
    BOOL ret = [SUCodeSigningVerifier codeSignatureIsValidAtPath: destinationPath error: error];
    if (!ret && !*error) {
        *error = [NSError errorWithDomain: MOValidatorErrorDomain code: MOValidatorErrorCodeSignInvalid userInfo: nil];
    }
    return ret;
}

@end
