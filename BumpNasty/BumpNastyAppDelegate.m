//
//  BumpNastyAppDelegate.m
//  BumpNasty
//
//  Created by Tim Flapper on 24-04-13.
//  Copyright (c) 2013 Tim Flapper. All rights reserved.
//

#import "BumpNastyAppDelegate.h"
#import "BumpNastyStartupViewController.h"
#import "BumpNastyBumpViewController.h"

#import <FacebookSDK/FacebookSDK.h>
#import "TestFlight.h"

@implementation BumpNastyAppDelegate

@synthesize navigationController, storyBoard, fbUser, received, loggedIn, hotel;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:@"a792a3f4-4ffa-4b45-b800-da82a20ca0b2"];
    
    [FBProfilePictureView class];
    
    navigationController = (UINavigationController *)self.window.rootViewController;
    storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BumpNastyStartupViewController*) getStartupViewController {
    BumpNastyStartupViewController *newController = nil;
    
    UIViewController *topViewController = [navigationController visibleViewController];
    
    if ([topViewController isKindOfClass:[BumpNastyStartupViewController class]]) {
        
        newController = (BumpNastyStartupViewController*)topViewController;
    } else {
        
        newController = [storyBoard instantiateViewControllerWithIdentifier:@"startupViewController"];
    }
    
    return newController;
}

- (void)showFacebookLoading
{
    BumpNastyStartupViewController *controller = [self getStartupViewController];
    
    [controller showLoading];
    
}

- (void)showFacebookLogin
{
    BumpNastyStartupViewController *controller = [self getStartupViewController];
    
    [controller showFacebookLoginButton];
}

- (void)showBumpScreen
{
    BumpNastyStartupViewController *controller = [self getStartupViewController];
    
    [controller gotoBumpView];
    
}

- (void)showPicture
{
    BumpNastyStartupViewController *controller = [self getStartupViewController];
    
    [controller showPicture];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            
            NSLog(@"OPEN");
            
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection,
               NSDictionary<FBGraphUser> *user,
               NSError *error) {
                 
                NSLog(@"REQUEST");
                 
                 if (!error) {
                     
                    NSLog(@"GOOD");
                     
                     self.fbUser = [[FacebookUserObject alloc] initWithUser:user];
                     
                     NSLog(@"%@", fbUser.userID);
                     
                     if (loggedIn) {
                         [self showBumpScreen];
                     } else {
                         [self showPicture];
                     }
                 } else {
                     
                     NSLog(@"BAD");
                     
                     [FBSession.activeSession closeAndClearTokenInformation];
                     
                     loggedIn = NO;
                     
                     [self showFacebookLogin];
                 }
             }];
        }
        break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showFacebookLogin];
        break;
        default:
        break;
    }
    
    if (error) {
        
        [FBSession.activeSession closeAndClearTokenInformation];
        
        loggedIn = NO;
        
        [self showFacebookLogin];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (void)firstViewLoaded
{
    loggedIn = false;
    
    // See if we have a valid token for the current state.
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        loggedIn = true;
        [self showFacebookLoading];
        [self openSession];
    } else {
        [self showFacebookLogin];
    }

}

- (CMMotionManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        motionmanager = [[CMMotionManager alloc] init];
    });
    
    return motionmanager;
}

@end
