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
#import <QuartzCore/QuartzCore.h>

@interface BumpNastyFinalViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *hotelMap;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *hotelName;
@property (strong, nonatomic) IBOutlet UILabel *locationInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceInfoLabel;

@end

@implementation BumpNastyFinalViewController

@synthesize hotelMap, distanceLabel, locationLabel, hotelName, distanceInfoLabel, locationInfoLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CLLocationCoordinate2D annotationCoord;
    
    BumpNastyAppDelegate* appDelegate = (BumpNastyAppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIFont *missionScriptFontHotel = [UIFont fontWithName:@"Mission Script" size: 28.0];
    UIFont *missionScriptFontLabels = [UIFont fontWithName:@"Mission Script" size: 18.0];
    
    [hotelName setFont: missionScriptFontHotel];
    [distanceLabel setFont: missionScriptFontLabels];
    [locationLabel setFont: missionScriptFontLabels];

    [distanceInfoLabel setFont: missionScriptFontLabels];
    [locationInfoLabel setFont: missionScriptFontLabels];

    NSDictionary *hotelData = appDelegate.hotel.data;
    
    NSDictionary *singleHotel = [hotelData objectForKey: @"hotel"];
    
    annotationCoord.latitude = appDelegate.latitude;
    annotationCoord.longitude = appDelegate.longitude;

    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;

    [hotelMap addAnnotation:annotationPoint];
    hotelMap.centerCoordinate = annotationCoord;

    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay

        MKCoordinateRegion region;
        region.center=annotationCoord;
        MKCoordinateSpan span;
        span.latitudeDelta=0.01;
        span.longitudeDelta=0.01;
        region.span=span;
        [self.hotelMap setRegion:region animated:YES];
        
    });

    
    NSString *street = [[NSString alloc] initWithFormat:@"%@", [singleHotel valueForKey:@"address1"]];
    NSString *postalcode = [[NSString alloc] initWithFormat:@"%@", [singleHotel valueForKey:@"postalCode"]];
    NSString *city = [[NSString alloc] initWithFormat:@"%@", [singleHotel valueForKey:@"city"]];
    
    NSNumber *proximity = [singleHotel valueForKey:@"proximityDistance"];
    
    NSString *proxMeasure = @"Kilometers";
    
    if ([proximity doubleValue] < 1.0) {
        proxMeasure = @"Meters";
        
        proximity = [[NSNumber alloc] initWithDouble: ([proximity doubleValue] * 1000)];
    }
    
    distanceLabel.text = [[NSString alloc] initWithFormat:@"%d %@", [proximity intValue], proxMeasure];

    locationLabel.text = [[NSString alloc] initWithFormat:@"%@\n%@ %@", street, postalcode, city];
    
    hotelName.text = [[NSString alloc] initWithFormat:@"%@", [singleHotel valueForKey:@"name"]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
