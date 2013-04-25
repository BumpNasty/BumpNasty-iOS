//
//  BumpNastyFinalViewController.m
//  BumpNasty
//
//  Created by Tim Flapper on 25-04-13.
//  Copyright (c) 2013 Tim Flapper. All rights reserved.
//

#import "BumpNastyFinalViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BumpNastyAppDelegate.h"

@interface BumpNastyFinalViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *hotelMap;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation BumpNastyFinalViewController

@synthesize hotelMap, distanceLabel, locationLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CLLocationCoordinate2D annotationCoord;
    
    BumpNastyAppDelegate* appDelegate = (BumpNastyAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSDictionary *hotelData = appDelegate.hotel.data;
    
    NSDictionary *singleHotel = [hotelData objectForKey: @"hotel"];
    
    annotationCoord.latitude = appDelegate.latitude;
    annotationCoord.longitude = appDelegate.longitude;

    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;

    [hotelMap addAnnotation:annotationPoint];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(annotationCoord, 25000, 25000);
    MKCoordinateRegion adjustedRegion = [hotelMap regionThatFits:viewRegion];
    
    hotelMap.centerCoordinate = annotationCoord;
    [hotelMap setRegion:adjustedRegion animated:NO];
    hotelMap.showsUserLocation = YES;
    
    NSString *street = @"";
    NSString *postalcode = @"";
    NSString *city = @"";
    NSString *country = @"";
    
    distanceLabel.text = [[NSString alloc] initWithFormat:@"%d km", [proximity intValue]];
    locationLabel.text =[[NSString alloc] initWithFormat:@"%@ %@\n%@, %@", street, postalcode, city, country];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
