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
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *fbIndicator;
- (IBAction)facebookLogin:(id)sender;
@property (nonatomic,retain) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;

@end

@implementation BumpNastyStartupViewController

@synthesize fbIndicator,
            facebookButton;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.profilePicture setHidden:YES];
    
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
    
    [fbIndicator startAnimating];
    [facebookButton setHidden:YES];
}

- (void)showFacebookLoginButton
{
    NSLog(@"showFacebookLoginButton");
    
    [fbIndicator stopAnimating];
    [facebookButton setHidden:NO];

}

- (IBAction)facebookLogin:(id)sender {
    NSLog(@"facebookLogin");
    
    [facebookButton setHidden:YES];
    [fbIndicator startAnimating];
    
    BumpNastyAppDelegate* appDelegate = (BumpNastyAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appDelegate openSession];
}

- (void)showPicture {
    [fbIndicator stopAnimating];
    [self.profilePicture setHidden:NO];
    
    BumpNastyAppDelegate* appDelegate = (BumpNastyAppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.profilePicture.profileID = appDelegate.fbUser.userID;
    
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
