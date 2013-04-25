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

@synthesize hotelMap;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CLLocationCoordinate2D annotationCoord;
    
    BumpNastyAppDelegate* appDelegate = (BumpNastyAppDelegate *)[UIApplication sharedApplication].delegate;
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
