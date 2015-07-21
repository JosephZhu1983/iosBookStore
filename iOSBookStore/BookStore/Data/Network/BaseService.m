//
//  BaseService.m
//  BookStore
//
//  Created by Ye Zhu on 8/25/12.
//
//

#import "BaseService.h"
#import "AFJSONRequestOperation.h"
#import "AFHttpClient.h"
#import "AFHTTPRequestOperation.h"
#import "NetworkConsts.h"
#import "Blocks.h"
#import "NotificationConsts.h"

static NSOperationQueue *operationQueue = nil;

@implementation BaseService

- (id)init
{
    self = [super init];
    if (self) {
        operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

-(NSURL*)getUrl
{
    NSURL *url = [NSURL URLWithString:kNetworkConsts_RemoteServiceUrl];
    return url;
}

-(void)sendRequestToController:(NSString*)controller andAction:(NSString*)action withParms:(NSDictionary*)params whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed andEnableNotification:(BOOL)b
{
    [self sendRequestToPath:[NSString stringWithFormat:@"%@/%@", controller, action] withParms:params whenSuccess:success andFailed:failed andEnableNotification:b];
}

-(void)sendRequestToPath:(NSString*)path withParms:(NSDictionary*)params whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed andEnableNotification:(BOOL)b;
{
    if (b)
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConsts_NetworkBegin object:self];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURL *url = [NSURL URLWithString:kNetworkConsts_RemoteServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:path parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary* json) {
                                             @try {
                                                 
                                                 NSLog(@"Request finished on %@: %@", path, json);
                                                 BOOL s = [[json objectForKey:kNetworkConsts_SucccessKey] boolValue];
                                                 if (s)
                                                 {
                                                     success([json objectForKey:kNetworkConsts_ResultKey]);
                                                     if (b)
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConsts_NetworkEnd object:self];
                                                 }
                                                 else
                                                 {
                                                     NSString *reason = [json objectForKey:kNetworkConsts_ReasonKey];
                                                     if ([reason isEqualToString:kNetworkConsts_ServerError])
                                                     {
                                                         if (b)
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConsts_ServerError object:self];
                                                     }
                                                     else
                                                     {
                                                         failed(reason);
                                                         if (b)
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConsts_NetworkEnd object:self];
                                                     }
                                                 }
                                                 
                                             }
                                             @catch (NSException *exception) {
                                                 NSLog(@"Request finished on %@: %@ Error: %@", path, json, exception);
                                             }
                                             @finally {
                                                 
                                             }
                                         }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary* json) {
                                             NSLog(@"Request failed on %@: %@", path, error);
                                             if (b)
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConsts_NetworkError object:self];
                                             
                                         }];
    
    [operationQueue addOperation:operation];
    
}


@end
