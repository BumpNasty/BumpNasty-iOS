//
//  FacebookUserObject.m
//  BumpNasty
//
//  Created by Tim Flapper on 24-04-13.
//  Copyright (c) 2013 Tim Flapper. All rights reserved.
//

#import "FacebookUserObject.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookUserObject ()
    @property (strong, nonatomic) NSString *userName;
    @property (strong, nonatomic) NSString *userID;
@end

@implementation FacebookUserObject

@synthesize userID = _userID,
            userName = _userName;

-(id)initWithUser:(NSDictionary<FBGraphUser> *)user {
    
    self = [super init];
    if (! self) return nil;
    
    _userID = user.id;
    _userName = user.username;
    
    return self;
}

-(NSString *)userID {
    return _userID;
}

@end
