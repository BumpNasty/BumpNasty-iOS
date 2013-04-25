//
//  BumpNastyHotelViewController.m
//  BumpNasty
//
//  Created by Tim Flapper on 25-04-13.
//  Copyright (c) 2013 Tim Flapper. All rights reserved.
//

#import "BumpNastyHotelViewController.h"
#import "BumpNastyAppDelegate.h"

@interface BumpNastyHotelViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *hotelImage;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation BumpNastyHotelViewController

@synthesize hotelImage, profilePicture, priceLabel, distanceLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    BumpNastyAppDelegate* appDelegate = (BumpNastyAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSLog(@"%@", appDelegate.hotel.data);
    
    NSDictionary *hotelData = appDelegate.hotel.data;
    
    NSDictionary *singleHotel = [hotelData objectForKey: @"hotel"];

    NSString *imgPath = [[NSString alloc] initWithFormat:@"http://images.travelnow.com/%@", [singleHotel objectForKey: @"thumbNailUrl"]];
    
    NSLog(@"%@", imgPath);
    
    NSURL *url = [NSURL URLWithString: imgPath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    hotelImage.contentMode = UIViewContentModeScaleAspectFill;

    hotelImage.clipsToBounds = YES;
    
    hotelImage.image = img;
    
    profilePicture.profileID = [(NSDictionary *)[hotelData objectForKey:@"other"] objectForKey:@"id"];
    
    NSNumber *distanceNumber = [hotelData objectForKey:@"proximityDistance"];
    
    int distanceInt = distanceNumber.intValue;
    
    NSString *price = [hotelData objectForKey:@"lowRate"];
    NSString *distance = [[NSString alloc] initWithFormat:@"%d", distanceInt];
    
    priceLabel.text = price;
    distanceLabel.text = distance;
    
//    CGSize size = img.size;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end