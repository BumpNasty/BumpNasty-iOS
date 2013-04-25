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
@property (strong, nonatomic) IBOutlet UILabel *hotelName;

@end

@implementation BumpNastyFinalViewController

@synthesize hotelMap, distanceLabel, locationLabel, hotelName;

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
    hotelMap.centerCoordinate = annotationCoord;
    
//    MKCoordinateSpan span;
//    MKCoordinateRegion region;
    
//    span.latitudeDelta = 1;
//    span.longitudeDelta = 1;
//    region.center = annotationCoord;
//    
//    [hotelMap setRegion:region animated:YES];
    
    NSString *street = [[NSString alloc] initWithFormat:@"%@", [singleHotel valueForKey:@"address1"]];
    NSString *postalcode = [[NSString alloc] initWithFormat:@"%@", [singleHotel valueForKey:@"postalCode"]];
    NSString *city = [[NSString alloc] initWithFormat:@"%@", [singleHotel valueForKey:@"city"]];
    NSString *country = [[NSString alloc] initWithFormat:@"%@", [singleHotel valueForKey:@"countryCode"]];
    
    NSNumber *proximity = [singleHotel valueForKey:@"proximityDistance"];
    
    distanceLabel.text = [[NSString alloc] initWithFormat:@"%d km", [proximity intValue]];
    locationLabel.text = [[NSString alloc] initWithFormat:@"%@ %@\n%@, %@", street, postalcode, city, country];
    
    hotelName.text = [[NSString alloc] initWithFormat:@"%@", [singleHotel valueForKey:@"name"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
