//
//  HotelObject.h
//  BumpNasty
//
//  Created by Tim Flapper on 25-04-13.
//  Copyright (c) 2013 Tim Flapper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelObject : NSObject
-(id)initWithData:(NSDictionary *)inData;
-(NSDictionary *)data;
@end
