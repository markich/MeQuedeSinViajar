//
//  MQSVNotification.h
//  MeQuedeSinViajar
//
//  Created by Marcos Jesús Vivar on 10/13/13.
//  Copyright (c) 2013 m4rk1ch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQSVNotification : NSObject

@property (strong, nonatomic) NSNumber *notificationLatitude;
@property (strong, nonatomic) NSNumber *notificationLongitude;
@property (strong, nonatomic) NSString *notificationCompany;
@property (assign, nonatomic) BOOL notificationCarPooling;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (id)notificationWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)getDictionaryForRequest;

@end
