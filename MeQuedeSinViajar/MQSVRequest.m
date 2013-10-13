//
//  MQSVRequest.m
//  MeQuedeSinViajar
//
//  Created by Marcos Jesús Vivar on 10/12/13.
//  Copyright (c) 2013 m4rk1ch. All rights reserved.
//

#import "MQSVRequest.h"

@interface MQSVRequest ()

@property (nonatomic, strong) NSMutableData *downloadedData;
@property (nonatomic, copy) MQSVRequestCompletionBlock completionBlock;
@property (nonatomic, readwrite, copy) NSString *path;
@property (nonatomic, readwrite, copy) NSString *httpMethod;
@property (nonatomic, readwrite, copy) NSString *requestType;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, readwrite, copy) NSHTTPURLResponse *httpURLResponse;
@property (nonatomic, copy) NSData *formParameterString;

- (NSURL *)requestURLWithPath:(NSString *)path;
- (void)performCompletionBlockOnMainThreadWithJSON:(id)jsonObject;

@end

@implementation MQSVRequest

@synthesize path = _path;
@synthesize httpMethod = _httpMethod;
@synthesize requestType = _requestType;
@synthesize downloadedData = _downloadedData;
@synthesize completionBlock = _completionBlock;
@synthesize connection = _connection;
@synthesize httpURLResponse = _httpURLResponse;
@synthesize formParameterString = _formParameterString;

#pragma mark - Instantiation

+ (id)requestWithPath:(NSString *)path method:(NSString *)httpMethod
{
    return [[self alloc] initWithPath:path method:httpMethod];
}

- (id)initWithPath:(NSString *)path method:(NSString *)method
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    _path = [path copy];
    _httpMethod = [method copy];
    
    return self;
}

+ (id)performRequestWithPath:(NSString *)path method:(NSString *)httpMethod completionBlock:(MQSVRequestCompletionBlock)completion
{
    MQSVRequest *request = [self requestWithPath:path method:httpMethod];
    [request startWithCompletionBlock:completion];
    
    return request;
}

#pragma mark - Completion Block

- (void)startWithCompletionBlock:(MQSVRequestCompletionBlock)completionBlock
{
    if (self.connection)
    {
        [self stop];
    }
    
    self.completionBlock = completionBlock;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self requestURLWithPath:self.path]];
    [request setHTTPMethod:self.httpMethod];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    BOOL shouldEmbedParameters = [self.formParameterString length] > 0 && ([self.httpMethod isEqualToString:@"POST"] || [self.httpMethod isEqualToString:@"PUT"]);
    if (shouldEmbedParameters)
    {
        [request setHTTPBody:self.formParameterString];
    }
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)stop
{
    [self.connection cancel];
    self.connection = nil;
    
    self.downloadedData = nil;
    self.completionBlock = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        self.httpURLResponse = httpResponse;
        
        NSDictionary *header = [httpResponse allHeaderFields];
        NSString *contentLength = [header valueForKey:@"Content-Length"];
        self.downloadedData = [NSMutableData dataWithCapacity:[contentLength integerValue]];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downloadedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Web service request failed, Path: %@", self.path);
    
    self.completionBlock(self, NO, nil);
    
    self.connection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    BOOL dataDidDownload = ([self.downloadedData length] > 0);
    BOOL noContent = (self.statusCode == HTTPStatusCodeNoContent);
    
    if (dataDidDownload || noContent)
    {
        dispatch_queue_t globalConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalConcurrentQueue, ^{
            NSString *response = [[NSString alloc] initWithData:self.downloadedData encoding:NSUTF8StringEncoding];
            
            SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
            id parsedJSON = [jsonParser objectWithString:response];
            
            [self performCompletionBlockOnMainThreadWithJSON:parsedJSON];
        });
    }
    
    self.connection = nil;
}

- (void)performCompletionBlockOnMainThreadWithJSON:(id)jsonObject
{
    if (!self.completionBlock)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.completionBlock(self, self.statusCode, jsonObject);
    });
}

#pragma mark - URL Constructor

- (NSURL *)requestURLWithPath:(NSString *)path
{
    if ([path hasPrefix:@"http"])
    {
        return [NSURL URLWithString:path];
    }
    
    NSString *baseURL = MQSV_BASE_API_URL;
    
    NSString *urlString = nil;
    BOOL shouldAppendFormParameters = (([self.formParameterString length] > 0) && [self.httpMethod isEqualToString:@"GET"]);
    if (shouldAppendFormParameters)
    {
        urlString = baseURL;
    }
    else
    {
        urlString = baseURL;
    }
    
    NSLog(@"URL Request: %@",urlString);
    
    return [NSURL URLWithString:urlString];
}

- (NSInteger)statusCode
{
    return [self.httpURLResponse statusCode];
}

- (BOOL)statusCodeIndicatesSuccess
{
    switch (self.statusCode)
    {
        case HTTPStatusCodeOK:
        case HTTPStatusCodeCreated:
        case HTTPStatusCodeNoContent:
            return YES;
    }
    
    return NO;
}

- (void)setFormParameters:(NSDictionary *)params
{
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    
    NSLog(@"JSON PAYLOAD: %@",[jsonWriter stringWithObject:params]);
    NSData *requestData = [[jsonWriter stringWithObject:params] dataUsingEncoding:NSUTF8StringEncoding];
    
    self.formParameterString = requestData;
}

@end
