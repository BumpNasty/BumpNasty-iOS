//
//  BumpNastyBumpViewController.m
//  BumpNasty
//
//  Created by Tim Flapper on 24-04-13.
//  Copyright (c) 2013 Tim Flapper. All rights reserved.
//

#import "BumpNastyBumpViewController.h"
#import "BumpNastyAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

static const NSTimeInterval accelerometerMin = 0.01;

@interface BumpNastyBumpViewController ()
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *minPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *minStarsLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxStarsLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *starsInfoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *loadingBackground;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;

@end

@implementation BumpNastyBumpViewController

@synthesize locationManager, loadingBackground, minPriceLabel, maxPriceLabel, distanceLabel, minStarsLabel, maxStarsLabel, priceInfoLabel, distanceInfoLabel, starsInfoLabel, loadingImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    loadingImage.animationImages = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"loading0.png"],
                                    [UIImage imageNamed:@"loading1.png"],
                                    [UIImage imageNamed:@"loading2.png"],
                                    [UIImage imageNamed:@"loading3.png"],
                                    [UIImage imageNamed:@"loading4.png"],
                                    [UIImage imageNamed:@"loading5.png"],
                                    [UIImage imageNamed:@"loading6.png"],
                                    [UIImage imageNamed:@"loading7.png"],
                                    [UIImage imageNamed:@"loading8.png"],
                                    [UIImage imageNamed:@"loading9.png"]
                                    , nil];
    
    loadingImage.animationDuration = 1.0;
    loadingImage.animationRepeatCount = 0;
    
    
    UIFont *missionScriptFont = [UIFont fontWithName:@"Mission Script" size: 24.0];
        
    [priceInfoLabel setFont: missionScriptFont];
    [distanceInfoLabel setFont: missionScriptFont];
    [starsInfoLabel setFont: missionScriptFont];
    
    [loadingBackground setHidden:YES];
    [loadingImage setHidden:YES];

//NSLog(@"%@", appDelegate.fbUser.userID);
  
    [self configureSliders];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
    [self checkBumping];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureSliders
{
    self.priceSlider.minimumValue = 0;
    self.priceSlider.maximumValue = 1000;
    
    self.priceSlider.lowerValue = 0;
    self.priceSlider.upperValue = 1000;
    
    self.priceSlider.stepValue = 50;
    self.priceSlider.stepValueContinuously = YES;
    
    
    self.starSlider.minimumValue = 0;
    self.starSlider.maximumValue = 5;
    
    self.starSlider.lowerValue = 0;
    self.starSlider.upperValue = 5;
    self.starSlider.stepValue = 1;
    self.starSlider.stepValueContinuously = YES;
}

-(void) checkBumping
{
    NSTimeInterval delta = 0.005;
    NSTimeInterval updateInterval = accelerometerMin + delta * 0.5;
    
    CMMotionManager *mManager = [(BumpNastyAppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];
    
    if ([mManager isAccelerometerAvailable] == YES) {
        [mManager setAccelerometerUpdateInterval:updateInterval];
        [mManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            //NSLog(@"%0f %0f %0f", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z);
            
            if (accelerometerData.acceleration.x < -0.8) { // && accelerometerData.acceleration.y < -0.5 && accelerometerData.acceleration.z > 0.75
                [self bumped];
//                self.label.text = @"BUMPED!";
            }
        }];
    }
}

- (void)bumped
{
   CMMotionManager *mManager = [(BumpNastyAppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];
    
    if ([mManager isAccelerometerActive]) {
        [mManager stopAccelerometerUpdates];
        
        [loadingBackground setHidden:NO];
        [loadingImage startAnimating];
        [loadingImage setHidden:NO];
        [self getHotel];
    }
    
   // NSLog(@"BUMPED!!");
}

- (void)getHotel
{
    //BumpNastyAppDelegate* appDelegate = (BumpNastyAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSLog(@"getHotel");
    
    self.view.backgroundColor = [UIColor colorWithRed: 1.0 green:0.0 blue:0.0 alpha:1.0];
    
    BumpNastyAppDelegate* appDelegate = (BumpNastyAppDelegate *)[UIApplication sharedApplication].delegate;
    
    float latitude = appDelegate.latitude;
    float longitude = appDelegate.longitude;
    
//    FacebookUserObject *fbUser = ;
    
    NSString *userID = [appDelegate fbUser].userID;
        
    NSString *url = [[NSString alloc] initWithFormat: @"http://bump-nasty.herokuapp.com/handshake?latitude=%6f&longitude=%6f&id=%@&minRate=%d&maxRate=%d&minStarRating=%d&maxStarRating=%d&maxRadius=%d", latitude, longitude, userID, (int)round(self.priceSlider.lowerValue), (int)round(self.priceSlider.upperValue), (int)round(self.starSlider.lowerValue), (int)round(self.starSlider.upperValue), (int)round(self.distanceSlider.value)];
    
    NSLog(@"%@", url);
    
    [self receiveDataFromServer:url];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    
    BumpNastyAppDelegate* appDelegate = (BumpNastyAppDelegate *)[UIApplication sharedApplication].delegate;
    
//    NSMutableData *received = appDelegate.received;
    
    [appDelegate.received setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.

    BumpNastyAppDelegate* appDelegate = (BumpNastyAppDelegate *)[UIApplication sharedApplication].delegate;
    
//    NSMutableData *received = appDelegate.received;
    
    [appDelegate.received appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    BumpNastyAppDelegate* appDelegate = (BumpNastyAppDelegate *)[UIApplication sharedApplication].delegate;
    
    //NSMutableData *received = appDelegate.received;

    
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[appDelegate.received length]);
    
    //self.label.text = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    
    NSError *jsonError = nil;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:appDelegate.received options:NSJSONReadingMutableLeaves error:&jsonError];
    
    if (json) {
//        self.label.text = ;
        
        NSString *error = [[NSString alloc] initWithFormat:@"%@", [json valueForKey:@"error"]];
        
        if ([error isEqual: @"timeout"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bump failed" message:@"We did not register both bumps. Please try again" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            // optional - add more buttons:
            [alert addButtonWithTitle:@"Close"];
            [alert show];
            
            [loadingBackground setHidden:YES];
            [loadingImage stopAnimating];
            [loadingImage setHidden:YES];

            
            [self checkBumping];
        } else {
            appDelegate.hotel = [[HotelObject alloc] initWithData:json];
            
            [self gotoHotelView];
        }
        //NSLog(@"%@", json);
    }
    
    // release the connection, and the data object
}

- (void)receiveDataFromServer:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:60.0];

//    NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:url2]
//                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
//                                         timeoutInterval:60.0];
    
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate: self];
    
//    NSURLConnection *connect2 = [[NSURLConnection alloc] initWithRequest:request2 delegate: nil];
    
    BumpNastyAppDelegate* appDelegate = (BumpNastyAppDelegate *)[UIApplication sharedApplication].delegate;
    
    //NSMutableData *received = appDelegate.received;
    
    if (connect) {
        appDelegate.received = [NSMutableData data];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        
//        NSString *loc = [[NSString alloc] initWithFormat:@"Latitude %+.6f\nLongitude %+.6f\n",
//                         location.coordinate.latitude,
//                         location.coordinate.longitude];
        
        BumpNastyAppDelegate* appDelegate = (BumpNastyAppDelegate *)[UIApplication sharedApplication].delegate;
        
        appDelegate.latitude = (double)location.coordinate.latitude;
        appDelegate.longitude = (double)location.coordinate.longitude;
        
        NSLog(@"%6f %6f", appDelegate.latitude, appDelegate.longitude);
        
        [manager stopUpdatingLocation];
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        // This error indicates that the user has denied the application's request to use location services.
        [manager stopUpdatingLocation];
    }
}

- (IBAction)distanceSliderChanged:(id)sender {
    int sliderValue;
    sliderValue = lroundf(self.distanceSlider.value);
    [self.distanceSlider setValue:sliderValue animated:YES];

    self.distanceLabel.text = [[NSString alloc] initWithFormat:@"%d km", sliderValue];
}

- (IBAction)priceSliderChanged:(id)sender {
    
    int lowerValue, upperValue;
    lowerValue = lroundf(self.priceSlider.lowerValue);
    upperValue = lroundf(self.priceSlider.upperValue);
    
    self.minPriceLabel.text = [[NSString alloc] initWithFormat:@"€ %d", lowerValue];

    self.maxPriceLabel.text = [[NSString alloc] initWithFormat:@"€ %d", upperValue];

}

- (IBAction)starSliderChanged:(id)sender {
    
    int lowerValue, upperValue;
    lowerValue = lroundf(self.starSlider.lowerValue);
    upperValue = lroundf(self.starSlider.upperValue);
    
    self.minStarsLabel.text = [[NSString alloc] initWithFormat:@"%d stars", lowerValue];
    
    self.maxStarsLabel.text = [[NSString alloc] initWithFormat:@"%d stars", upperValue];

    
    //    NSLog(@"STAR %f - %f", self.starSlider.lowerValue, self.starSlider.upperValue);
}

- (void)gotoHotelView {
    
    [self performSegueWithIdentifier:@"showHotelView" sender: self];
}

@end
