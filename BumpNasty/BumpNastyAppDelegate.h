//
//  BumpNastyAppDelegate.h
//  BumpNasty
//
//  Created by Tim Flapper on 24-04-13.
//  Copyright (c) 2013 Tim Flapper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreMotion/CoreMotion.h>

#import "FacebookUserObject.h"

@interface BumpNastyAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate> {
    CMMotionManager *motionmanager;
    NSMutableData *received;
}

@property (strong, nonatomic, readonly) CMMotionManager *sharedManager;

-(void)openSession;
-(void)firstViewLoaded;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UIStoryboard *storyBoard;
@property (strong, nonatomic) FacebookUserObject *fbUser;

@property double latitude;
@property double longitude;

@property (strong, nonatomic) NSMutableData *received;

@property bool loggedIn;

@end
