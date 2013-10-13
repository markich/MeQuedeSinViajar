//
//  MQSVRequest.h
//  MeQuedeSinViajar
//
//  Created by Marcos Jesús Vivar on 10/12/13.
//  Copyright (c) 2013 m4rk1ch. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBJson.h"
#import "MQSVAppConfiguration.h"

@class MQSVRequest;

typedef enum
{
    HTTPStatusCodeOK = 200,
    HTTPStatusCodeCreated = 201,
    HTTPStatusCodeNoContent = 204,
    HTTPStatusCodeUnprocessableEntity = 422,
    HTTPStatusCodeServerError = 500
} HTTPStatusCode;

typedef void (^MQSVRequestCompletionBlock)(MQSVRequest *request, NSInteger httpStatusCode, id parsedJSONResponse);

@interface MQSVRequest : NSObject

@property (nonatomic, readonly, copy) NSString *path;
@property (nonatomic, readonly, copy) NSString *httpMethod;
@property (nonatomic, readonly, copy) NSString *requestType;

@property (nonatomic, readonly, copy) NSHTTPURLResponse *httpURLResponse;
@property (nonatomic, readonly) NSInteger statusCode;

+ (id)performRequestWithPath:(NSString *)path method:(NSString *)httpMethod completionBlock:(MQSVRequestCompletionBlock)completion;
+ (id)requestWithPath:(NSString *)path method:(NSString *)httpMethod;
- (id)initWithPath:(NSString *)path method:(NSString *)httpMethod;

- (void)startWithCompletionBlock:(MQSVRequestCompletionBlock)completionBlock;
- (void)stop;
- (void)setFormParameters:(NSDictionary *)params;
- (BOOL)statusCodeIndicatesSuccess;

@end
