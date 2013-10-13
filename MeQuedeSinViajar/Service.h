//
//  Service.h
//  MeQuedeSinViajar
//
//  Created by Marcos Jesús Vivar on 10/12/13.
//  Copyright (c) 2013 m4rk1ch. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBJson.h"

typedef void (^ServiceCompletionBlock)(id returnedObject, NSError *error);

@interface Service : NSObject

+ (Service *)sharedService;

@end
