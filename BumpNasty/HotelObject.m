//
//  HotelObject.m
//  BumpNasty
//
//  Created by Tim Flapper on 25-04-13.
//  Copyright (c) 2013 Tim Flapper. All rights reserved.
//

#import "HotelObject.h"

@interface HotelObject ()
@property (strong, nonatomic) NSDictionary *data;
@end

@implementation HotelObject

@synthesize data = _data;

-(id)initWithData:(NSDictionary *)inData {
    self = [super init];
    if (! self) return nil;
    
    _data = inData;
    
    return self;
    
}

-(NSDictionary *)data {
    
    return _data;
}

@end
