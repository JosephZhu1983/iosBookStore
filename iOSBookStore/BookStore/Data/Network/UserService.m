//
//  UserService.m
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import "UserService.h"
#import "NetworkConsts.h"


@implementation UserService

+ (UserService*) instance
{
    static UserService* instance = nil;

    
    @synchronized(self){
		if (nil == instance) {
			instance = [[self alloc] init];
		}
	}
	
    return instance;
}

- (void)loginWithUsername: (NSString*)username andPassword:(NSString*)password whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed;

{
    [super sendRequestToController:kNetworkConsts_UserControllerPath andAction:kNetworkConsts_LoginActionPath
                         withParms:[NSDictionary dictionaryWithObjects:@[username, password] forKeys:@[@"username", @"password"]] whenSuccess:success andFailed:failed andEnableNotification:YES];
}

- (void)registerWithUsername: (NSString*)username andPassword:(NSString*)password whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed;

{
    [super sendRequestToController:kNetworkConsts_UserControllerPath andAction:kNetworkConsts_RegisterActionPath
                         withParms:[NSDictionary dictionaryWithObjects:@[username, password] forKeys:@[@"username", @"password"]] whenSuccess:success andFailed:failed andEnableNotification:YES];
}


- (void)changePassword: (NSString*)password forUserid:(NSInteger)userid whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed;

{
    [super sendRequestToController:kNetworkConsts_UserControllerPath andAction:kNetworkConsts_ChangePasswordActionPath
                         withParms:[NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%d", userid], password] forKeys:@[@"id", @"password"]] whenSuccess:success andFailed:failed andEnableNotification:YES];
}

@end
