//
//  main.m
//  AutoUpdater
//
//  Created by Masakazu Ohtsuka on 2014/07/01.
//  Copyright (c) 2014年 maaash.jp. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MOTerminationObserver.h"
#import "MOInstaller.h"
#import "MOUpdater.h"

void showModalAlertWithMessage(NSString *message);

/// Use MOUpdater class to run
int main(int argc, const char * argv[]){
    if (argc <= 2) {
        // we need at least 3:
        // Updater -plistArg ...
        return EXIT_FAILURE;
    }

    @autoreleasepool {
        NSDictionary *arguments = [[[NSUserDefaults standardUserDefaults] volatileDomainForName: NSArgumentDomain] objectForKey: @"plistArg"];

        NSString *bundleIdentifier  = arguments[ kMOUpdaterArgumentsBundleIdentifier ];
        NSString *destination       = arguments[ kMOUpdaterArgumentsBundlePath ];
        NSString *source            = arguments[ kMOUpdaterArgumentsSource ];
        NSString *relaunchArguments = arguments[ kMOUpdaterArgumentsRelaunchArguments ];
        NSString *appname           = [destination lastPathComponent];

        NSLog( @"%@ updater is updating destination: %@ from source: %@ and relaunching: %@", appname, destination, source, bundleIdentifier );

        MOTerminationObserver *observer = [[MOTerminationObserver alloc] init];
        observer.timeout = 10.;
        [observer observeTerminationOfBundleIdentifier: bundleIdentifier completion:^(NSError* error) {
            if (error) {
                NSString *message = [NSString stringWithFormat: @"Failed to terminate %@, error: %@", appname, error];
                NSLog( @"%@", message );
                showModalAlertWithMessage(message);
                exit(EXIT_FAILURE);
            }
            MOInstaller *installer = [[MOInstaller alloc] initWithDestinationPath: destination
                                                                       sourcePath: source];
            [installer installWithCompletion:^(NSError* error) {
                    if (error) {
                        NSString *message = [NSString stringWithFormat: @"Failed to install update of %@, error: %@", appname, error];
                        NSLog( @"%@", message );
                        showModalAlertWithMessage(message);
                        exit(EXIT_FAILURE);
                    }
                    NSError *launchError = nil;
                    NSArray *arguments = @[ @"-plistArg", relaunchArguments.description ];
                    NSRunningApplication *app = [[NSWorkspace sharedWorkspace] launchApplicationAtURL: [NSURL fileURLWithPath: destination]
                                                                                              options: NSWorkspaceLaunchDefault
                                                                                        configuration: @{ NSWorkspaceLaunchConfigurationArguments: arguments }
                                                                                                error: &launchError];
                    if (!app || launchError) {
                        NSString *message = [NSString stringWithFormat: @"Failed to relaunch %@, error: %@", appname, launchError];
                        NSLog( @"%@", message );
                        showModalAlertWithMessage(message);
                        exit(EXIT_FAILURE);
                    }

                    // should we wait for a while to confirm that app is really successfully launched?

                    NSLog( @"%@ updater successfully finished!", appname );
                    exit(EXIT_SUCCESS);
                }];
        }];
        [[NSApplication sharedApplication] run];
    }

    return EXIT_SUCCESS;
}

void showModalAlertWithMessage(NSString *message) {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle: @"OK"];
    [alert setMessageText: message];
    [alert setAlertStyle: NSWarningAlertStyle];
    [[NSRunningApplication currentApplication] activateWithOptions: NSApplicationActivateIgnoringOtherApps];
    [alert runModal];
}
