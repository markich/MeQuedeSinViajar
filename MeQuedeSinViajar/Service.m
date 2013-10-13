//
//  Service.m
//  MeQuedeSinViajar
//
//  Created by Marcos Jesús Vivar on 10/12/13.
//  Copyright (c) 2013 m4rk1ch. All rights reserved.
//

#import "Service.h"

@implementation Service

#pragma -
#pragma mark Instantiation Methods

+ (Service *)sharedService
{
    static dispatch_once_t pred;
    static Service *sharedInstance = nil;
    
    dispatch_once(&pred, ^{ sharedInstance = [[Service alloc] init]; });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (!self)
    {
        return nil;
    }
    
    return self;
}

#pragma -
#pragma mark Public Methods



@end
