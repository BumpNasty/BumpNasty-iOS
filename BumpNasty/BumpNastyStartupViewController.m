//
//  BumpNastyViewController.m
//  BumpNasty
//
//  Created by Tim Flapper on 24-04-13.
//  Copyright (c) 2013 Tim Flapper. All rights reserved.
//

#import "BumpNastyAppDelegate.h"
#import "BumpNastyStartupViewController.h"

@interface BumpNastyStartupViewController ()
- (IBAction)facebookLogin:(id)sender;
@property (nonatomic,retain) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong, nonatomic) IBOutlet UIImageView *loadingBackground;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) IBOutlet UIImageView *startupBackground;
@property (strong, nonatomic) IBOutlet UIImageView *pictureBackground;

@end

@implementation BumpNastyStartupViewController

@synthesize facebookButton, profilePicture, loadingBackground, loadingImage, startupBackground, pictureBackground;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.profilePicture setHidden:YES];
    [self.loadingBackground setHidden:YES];
    [self.pictureBackground setHidden:YES];
    [self.loadingImage setHidden:YES];
    
    BumpNastyAppDelegate* appDelegate = (BumpNastyAppDelegate *)[UIApplication sharedApplication].delegate;

    [appDelegate firstViewLoaded];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoading
{
    NSLog(@"LOADING");
    
    [startupBackground setHidden:YES];
    [loadingBackground setHidden:NO];
    [loadingImage setHidden:NO];
    [facebookButton setHidden:YES];
}

- (void)showFacebookLoginButton
{
    NSLog(@"showFacebookLoginButton");
    
    [loadingImage setHidden:YES];
    [facebookButton setHidden:NO];
    [startupBackground setHidden:NO];
    [loadingBackground setHidden:YES];

}

- (IBAction)facebookLogin:(id)sender {
    NSLog(@"facebookLogin");

    [startupBackground setHidden:YES];
    [loadingBackground setHidden:NO];
    
    [facebookButton setHidden:YES];
    [loadingImage setHidden:NO];
    
    BumpNastyAppDelegate* appDelegate = (BumpNastyAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appDelegate openSession];
}

- (void)showPicture {
    
    [pictureBackground setHidden:NO];
    [startupBackground setHidden:YES];
    [loadingBackground setHidden:YES];
    
    [loadingImage setHidden:YES];
    [self.profilePicture setHidden:NO];
    
    BumpNastyAppDelegate* appDelegate = (BumpNastyAppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.profilePicture.profileID = appDelegate.fbUser.userID;
    self.profilePicture.pictureCropping = FBProfilePictureCroppingSquare;
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self gotoBumpView];
    });
}

- (void)gotoBumpView {
    
    [self performSegueWithIdentifier:@"showBumpView" sender: self];
}

@end
