//
//  APIService.m
//  MeQuedeSinViajar
//
//  Created by Marcos Jesús Vivar on 10/12/13.
//  Copyright (c) 2013 m4rk1ch. All rights reserved.
//

#import "APIService.h"

@interface APIService ()

@property (nonatomic, strong) NSOperationQueue *backgroundOperationQueue;

@end

@implementation APIService

@synthesize backgroundOperationQueue = _backgroundOperationQueue;

#pragma -
#pragma mark Instantiation Methods

+ (APIService *)sharedService
{
    static dispatch_once_t pred;
    static APIService *sharedInstance = nil;
    
    dispatch_once(&pred, ^{ sharedInstance = [[APIService alloc] init]; });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (!self)
    {
        return nil;
    }
    
    _backgroundOperationQueue = [[NSOperationQueue alloc] init];
    
    return self;
}

#pragma -
#pragma mark Public Methods

- (void)sendNotificationWith:(MQSVNotification *)notification andCompletionBlock:(APIServiceCompletionBlock)block
{
    MQSVRequest *request = [MQSVRequest requestWithPath:nil method:HTTP_POST_METHOD];
    
    NSDictionary *params = [notification getDictionaryForRequest];
    
    [request setFormParameters:params];
    
    [request startWithCompletionBlock:^(MQSVRequest *request, NSInteger httpStatusCode, id JSONResponse)
     {
         NSNumber *completionStatus = nil;
         NSError *error = nil;
         if (httpStatusCode == HTTPStatusCodeOK)
         {
             NSLog(@"HTTP Status '200' OK");
             
             completionStatus = [NSNumber numberWithBool:YES];
             block(completionStatus, error);
         }
         else
         {
             NSString *serverErrorMessage = [JSONResponse objectForKey:@"error"];
             
             error = [NSError errorWithDomain:@"MSQV_DOMAIN_ERROR"
                                                  code:httpStatusCode
                                              userInfo:[NSDictionary dictionaryWithObject:serverErrorMessage forKey:NSLocalizedDescriptionKey]];
             
             completionStatus = [NSNumber numberWithBool:NO];
             block(completionStatus, error);
         }
         
         block(completionStatus, error);
     }];
}

@end
