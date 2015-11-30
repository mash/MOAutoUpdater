//
//  ILVersionChecker.m
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/01/30.
//  Copyright (c) 2014年 Masakazu Ohtsuka. All rights reserved.
//

#import "MOGithubReleaseFetcher.h"
#import <AFNetworking/AFNetworking.h>
#import "MOLog.h"
#import "MOUpdateChecker.h"
#import "MOUpdater.h" // for kMOReleaseInformation keys
#import "EDSemver.h"

NSString * const MOReleaseCheckerErrorDomain = @"MOReleaseCheckerErrorDomain";

@interface MOGithubReleaseFetcher ()

@end

@implementation MOGithubReleaseFetcher

- (instancetype) initWithUserName:(NSString*)userName repositoryName:(NSString*)repositoryName {
    self = [super init];
    if (!self) { return nil; }

    _userName       = userName;
    _repositoryName = repositoryName;

    return self;
}

- (void)fetchArchiveNewerThanVersion:(NSString*)currentVersion
                   downloadDirectory:(NSURL*)downloadDirectory
            fetchedNewerArchiveBlock:(void (^)(NSDictionary *releaseInformation, NSURL *downloadedArchive, NSError *error))completion {
    MOLOG( @"currentVersion: %@", currentVersion );

    [self getNewestRelease:^(NSDictionary *release) {
        // Example release:
        //   {
        //     "url": "https://api.github.com/repos/mash/-----------------/releases/401829",
        //     "assets_url": "https://api.github.com/repos/mash/-----------------/releases/401829/assets",
        //     "upload_url": "https://uploads.github.com/repos/mash/-----------------/releases/401829/assets{?name}",
        //     "html_url": "https://github.com/mash/-----------------/releases/tag/v1.0.0",
        //     "id": 401829,
        //     "tag_name": "v1.0.0",
        //     "target_commitish": "master",
        //     "name": "test release",
        //     "draft": false,
        //     "author": {
        //       "login": "mash",
        //       ...
        //     },
        //     "prerelease": false,
        //     "created_at": "2012-08-31T14:05:01Z",
        //     "published_at": "2014-06-30T06:09:35Z",
        //     "assets": [
        //       {
        //         "url": "https://api.github.com/repos/mash/-----------------/releases/assets/171238",
        //         "id": 171238,
        //         "name": "IRLauncher.app.zip",
        //         "label": null,
        //         "uploader": {
        //           "login": "mash",
        //           ...
        //         },
        //         "content_type": "application/zip",
        //         "state": "uploaded",
        //         "size": 673609,
        //         "download_count": 0,
        //         "created_at": "2014-06-30T06:09:28Z",
        //         "updated_at": "2014-06-30T06:09:31Z"
        //       }
        //     ],
        //     "tarball_url": "https://api.github.com/repos/mash/-----------------/tarball/v1.0.0",
        //     "zipball_url": "https://api.github.com/repos/mash/-----------------/zipball/v1.0.0",
        //     "body": "hoge"
        //   }
        MOLOG( @"release: %@", release );

        NSString *newestVersion  = release[ @"tag_name" ];
        NSNumber *assetID        = release[ @"assets" ][ 0 ][ @"id" ];
        NSURL *downloadFileURL   = [downloadDirectory URLByAppendingPathComponent: assetID.stringValue];

        NSDictionary *releaseInformation = @{
            kMOReleaseInformationNewVersionKey: newestVersion,
            kMOReleaseInformationBodyTextKey:   release[@"body"],
            kMOReleaseInformationURLKey:        release[@"html_url"],
        };

        // only download and call foundNewerVersionBlock if we found a newer version
        if (![MOGithubReleaseFetcher version: newestVersion isNewerThanVersion: currentVersion]) {
            completion( nil, nil, [NSError errorWithDomain: MOReleaseCheckerErrorDomain
                                                      code: MOReleaseCheckerErrorNewerVersionNotFound
                                                  userInfo: @{ kMOReleaseInformationNewVersionKey: newestVersion }]);
            return;
        }

        NSError *createDirectoryError;
        [[NSFileManager defaultManager] createDirectoryAtURL: downloadDirectory
                                 withIntermediateDirectories: YES
                                                  attributes: nil
                                                       error: &createDirectoryError];
        if (createDirectoryError) {
            completion( nil, nil, createDirectoryError );
            return;
        }

        // only download if not downloaded yet
        unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath: downloadFileURL.path
                                                                                        error: nil] fileSize];
        NSNumber *expectedSize = release[ @"assets" ][ 0 ][ @"size" ];
        if (fileSize == expectedSize.unsignedLongLongValue) {
            // downloaded
            completion( releaseInformation, downloadFileURL, nil );
            return;
        }

        // remove existing file before downloading
        [[NSFileManager defaultManager] removeItemAtURL: downloadFileURL error: NULL];

        [self downloadRelease: release toURL: downloadFileURL completion:^(NSURL *filePath, NSError *error) {
                MOLOG( @"filePath: %@, error: %@", filePath, error );

                if (error) {
                    completion( nil, nil, error );
                    return;
                }

                completion( releaseInformation, downloadFileURL, nil );
            }];
    } failure:^(NSError *error) {
        MOLOG( @"error: %@", error );
        completion( nil, nil, error );
    }];
}

#pragma mark - AFNetworking Impl

- (void) getNewestRelease: (void (^)(NSDictionary *release))success failure: (void (^)(NSError *error)) failure {
    NSString *endpoint            = [NSString stringWithFormat: @"https://api.github.com/repos/%@/%@/releases", _userName, _repositoryName];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLSessionDataTask *getTask = [manager GET: endpoint
                                      parameters: nil
                                         success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *release = ((NSArray*)responseObject)[ 0 ];
        success( release );
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MOLOG(@"error: %@", error);
        failure( error );
    }];
    [getTask resume];
}

- (void) downloadRelease: (NSDictionary *)release toURL:(NSURL*)targetPath completion:(void (^)(NSURL *filePath, NSError *error))completion {
    NSString *assetURLString     = release[ @"assets" ][ 0 ][ @"url" ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: assetURLString]
                                                           cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval: 30.];
    // set header to download release binary
    [request setValue: @"application/octet-stream" forHTTPHeaderField: @"Accept"];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager             = [[AFURLSessionManager alloc] initWithSessionConfiguration: configuration];
    NSURLSessionDownloadTask *downloadTask   = [manager downloadTaskWithRequest: request
                                                                       progress: nil
                                                                    destination:^NSURL *(NSURL *tmpPath, NSURLResponse *response) {
        MOLOG( @"targetPath: %@, response: %@ -> tmpPath: %@", targetPath, response, tmpPath );
        return targetPath;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        MOLOG( @"response: %@, filePath: %@, error: %@", response, filePath, error );
        dispatch_async(dispatch_get_main_queue(), ^{
                completion( targetPath, error );
            });
    }];
    [downloadTask resume];
}

#pragma mark - Private

+ (BOOL) version:(NSString*) version1_ isNewerThanVersion: (NSString*)version2_ {
    MOLOG( @"version1: %@ version2: %@", version1_, version2_);
    return [[EDSemver semverWithString:version1_] isGreaterThan:[EDSemver semverWithString:version2_]];
}

@end
