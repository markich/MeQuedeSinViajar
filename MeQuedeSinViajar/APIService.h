//
//  APIService.h
//  MeQuedeSinViajar
//
//  Created by Marcos Jesús Vivar on 10/12/13.
//  Copyright (c) 2013 m4rk1ch. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MQSVRequest.h"
#import "MQSVNotification.h"
#import "SBJson.h"

typedef void (^APIServiceCompletionBlock)(id returnedObject, NSError *error);

@interface APIService : NSObject

+ (APIService *)sharedService;

- (void)sendNotificationWith:(MQSVNotification *)notification CompletionBlock:(APIServiceCompletionBlock)block;

@end
