//
//  AUCodeSignValidator.m
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/02.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import "AUCodeSignValidator.h"
#import "SUCodeSigningVerifier.h"

@implementation AUCodeSignValidator

- (BOOL)bundleIsValidAtPath:(NSString *)destinationPath error:(NSError **)error {
    return [SUCodeSigningVerifier codeSignatureIsValidAtPath: destinationPath error: error];
}

@end