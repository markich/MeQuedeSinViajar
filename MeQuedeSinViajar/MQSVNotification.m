//
//  MQSVNotification.m
//  MeQuedeSinViajar
//
//  Created by Marcos Jesús Vivar on 10/13/13.
//  Copyright (c) 2013 m4rk1ch. All rights reserved.
//

#import "MQSVNotification.h"

@interface MQSVNotification ()

- (BOOL)setAttributesFromDictionary:(NSDictionary *)dictionary;

@end

@implementation MQSVNotification

@synthesize notificationLatitude;
@synthesize notificationLongitude;
@synthesize notificationCompany;
@synthesize notificationCarPooling;

#pragma mark -
#pragma mark Instantiation

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    BOOL didPopulateSuccessfully = [self setAttributesFromDictionary:dictionary];
    if (!didPopulateSuccessfully)
    {
        return nil;
    }
    
    return self;
}

+ (id)notificationWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

- (id)init
{
	if(self = [super init])
    {
        self.notificationLatitude = nil;
        self.notificationLongitude = nil;
		self.notificationCompany = nil;
        self.notificationCarPooling = nil;
	}
    
	return self;
}

#pragma mark -
#pragma mark Encoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.notificationLatitude forKey:@"Latitude"];
    [encoder encodeObject:self.notificationLongitude forKey:@"Longitude"];
    [encoder encodeObject:self.notificationCompany forKey:@"Company"];
    [encoder encodeObject:self.notificationCarPooling forKey:@"CarPooling"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if( self != nil )
    {
        self.notificationLatitude = [decoder decodeObjectForKey:@"Latitude"];
        self.notificationLongitude = [decoder decodeObjectForKey:@"Longitude"];
        self.notificationCompany = [decoder decodeObjectForKey:@"Company"];
        self.notificationCarPooling = [decoder decodeObjectForKey:@"CarPooling"];
    }
    
    return self;
}

#pragma mark -
#pragma mark Private Methods

- (BOOL)setAttributesFromDictionary:(NSDictionary *)dictionary
{
    if( dictionary != nil )
    {
        self.notificationLatitude = [dictionary objectForKey:@"latitude"];
        self.notificationLongitude = [dictionary objectForKey:@"longitude"];
		self.notificationCompany = [dictionary objectForKey:@"company"];
        self.notificationCarPooling = [dictionary objectForKey:@"car_pooling"];
    }
    
    BOOL countryIsValid = (self.notificationCompany  && self.notificationCarPooling);
    
    return countryIsValid;
}

#pragma mark -
#pragma mark Public Methods

- (NSDictionary *)getDictionaryForRequest
{
    NSMutableDictionary *morphedDictionary = [[NSMutableDictionary alloc] init];
    
    if (self.notificationLatitude != nil)
    {
        [morphedDictionary setObject:self.notificationLatitude forKey:@"latitude"];
    }
    
    if (self.notificationLongitude != nil)
    {
        [morphedDictionary setObject:self.notificationLongitude forKey:@"longitude"];
    }
    
    if (self.notificationCompany != nil)
    {
        [morphedDictionary setObject:self.notificationCompany forKey:@"company"];
    }
    
    if (self.notificationCarPooling)
    {
        [morphedDictionary setObject:self.notificationCarPooling forKey:@"car_pooling"];
    }
    
    if ([[morphedDictionary allKeys] count] == 0)
    {
        [morphedDictionary setObject:self.notificationLatitude forKey:@"latitude"];
        [morphedDictionary setObject:self.notificationLongitude forKey:@"longitude"];
        [morphedDictionary setObject:self.notificationCompany forKey:@"company"];
        [morphedDictionary setObject:self.notificationCarPooling forKey:@"car_pooling"];
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary *)morphedDictionary];
    
    return dictionary;
}

@end
