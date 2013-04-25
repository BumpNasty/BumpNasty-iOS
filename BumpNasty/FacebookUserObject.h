//
//  FacebookUserObject.h
//  BumpNasty
//
//  Created by Tim Flapper on 24-04-13.
//  Copyright (c) 2013 Tim Flapper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookUserObject : NSObject
-(id)initWithUser:(NSDictionary<FBGraphUser> *)user;
-(NSString *)userID;
@end
