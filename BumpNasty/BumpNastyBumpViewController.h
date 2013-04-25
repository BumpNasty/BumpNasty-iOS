//
//  BumpNastyBumpViewController.h
//  BumpNasty
//
//  Created by Tim Flapper on 24-04-13.
//  Copyright (c) 2013 Tim Flapper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@interface BumpNastyBumpViewController : UIViewController <CLLocationManagerDelegate> {
    
    CLLocationManager *locationManager;
    
}
    @property (weak, nonatomic) IBOutlet NMRangeSlider *priceSlider;
    @property (weak, nonatomic) IBOutlet NMRangeSlider *starSlider;
    @property (weak, nonatomic) IBOutlet UISlider *distanceSlider;

- (IBAction)distanceSliderChanged:(id)sender;
- (IBAction)priceSliderChanged:(id)sender;
- (IBAction)starSliderChanged:(id)sender;

    @property (nonatomic, retain) CLLocationManager *locationManager;
@end
