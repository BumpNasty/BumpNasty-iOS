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
@property (strong, nonatomic) IBOutlet UILabel *starLabel;
@property (strong, nonatomic) IBOutlet UILabel *hotelName;

- (IBAction)acceptHotel:(id)sender;

@end

@implementation BumpNastyHotelViewController

@synthesize hotelImage, profilePicture, priceLabel, distanceLabel, starLabel;

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
    
//    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
//    [f setNumberStyle:NSNumberFormatterDecimalStyle];
//    [f setGeneratesDecimalNumbers:NO];
    
//    NSNumber *proximity = [f numberFromString:[singleHotel valueForKey:@"proximityDistance"]];
  
    NSNumber *proximity = [singleHotel valueForKey:@"proximityDistance"];
    
    NSLog(@"%@", [singleHotel valueForKey:@"proximityDistance"]);
    distanceLabel.text = [[NSString alloc] initWithFormat:@"%d", [proximity intValue]];
    
    starLabel.text = [[NSString alloc] initWithFormat:@"%@", [singleHotel valueForKey:@"hotelRating"]];
    NSLog(@"%@", [singleHotel valueForKey:@"hotelRating"]);

    priceLabel.text = [[NSString alloc] initWithFormat:@"%@", [singleHotel valueForKey:@"lowRate"]];
    NSLog(@"%@", [singleHotel valueForKey:@"lowRate"]);
    
 //   int distanceInt = [[singleHotel valueForKey:@"proximityDistance"] intValue];
    
//    NSString *price = [[NSString alloc] initWithFormat: @"%@",[singleHotel valueForKey:@"lowRate"]];
//    NSString *distance = [[NSString alloc] initWithFormat:@"%d", distanceInt];
    
 //   NSString *star = [singleHotel valueForKey:@"hotelRating"];
    
//    priceLabel.text = price;
//    distanceLabel.text = [singleHotel valueForKey:@"proximityDistance"];
//    starLabel.text = star;
    
//    CGSize size = img.size;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)acceptHotel:(id)sender {
}
@end