//
//  UserController.m
//  BookStore
//
//  Created by Ye Zhu on 8/25/12.
//
//

#import "UserController.h"
#import "UserService.h"
#import "NotificationConsts.h"
#import "UserDefaultsService.h"
#import "User.h"
#import "NetworkConsts.h"

@implementation UserController

+ (UserController*) instance
{
    static UserController* instance = nil;
    @synchronized(self){
		if (nil == instance) {
			instance = [[self alloc] init];
		}
	}
	
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        [self setUserFromUserDefaults];
    }
    
    return self;
}

- (BOOL)hasLogin
{
    return self.user.userid >0;
}

-(void)setUserFromUserDefaults
{
    User *user = [[User alloc] init];
    user.userid = [[UserDefaultsService instance] getUserId];
    user.username = [[UserDefaultsService instance] getUsername];
    self.user = user;
}

-(void)setUserWithUsername:(NSString*)username andUserid:(NSInteger)userid
{
    [[UserDefaultsService instance] setUserId:userid];
    [[UserDefaultsService instance] setUsername:username];
    User *user = [[User alloc] init];
    user.userid = userid;
    user.username = username;
    self.user = user;
}

- (void)loginWithUsername:(NSString*)username andPassword:(NSString*)password
{
    [[UserService instance] loginWithUsername:username andPassword:password whenSuccess:^(NSDictionary *result) {
        
        NSInteger userid = [[result objectForKey:@"userid"] integerValue];
        [self setUserWithUsername:username andUserid:userid];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConsts_LoginSuccess object:self];
    } andFailed:^(NSString *reason) {
        [self handleFailed:reason];
    }];
}

- (void)registerWithUsername:(NSString*)username andPassword:(NSString*)password
{
    [[UserService instance] registerWithUsername:username andPassword:password whenSuccess:^(NSDictionary *result) {
        NSInteger userid = [[result objectForKey:@"userid"] integerValue];
        [self setUserWithUsername:username andUserid:userid];

        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConsts_RegisterSuccess object:self];
    } andFailed:^(NSString *reason) {
        [self handleFailed:reason];
    }];
}

-(void)changePassword:(NSString*)password
{
    [[UserService instance] changePassword:password forUserid:self.user.userid whenSuccess:^(NSDictionary *result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConsts_ChangePasswordSuccess object:self];
    } andFailed:^(NSString *reason) {
        [self handleFailed:reason];
    }];

}

-(void)logout
{
    [[UserDefaultsService instance] setUserId:0];
    [[UserDefaultsService instance] setUsername:nil];
    [self setUserFromUserDefaults];
}

- (void)handleFailed: (NSString*) reason
{
    if ([reason isEqualToString:kNetworkConsts_AuthFailed])
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConsts_AuthFailed object:self];
    else if ([reason isEqualToString:kNetworkConsts_UserExists])
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConsts_UserExists object:self];
    else if ([reason isEqualToString:kNetworkConsts_UserNotExists])
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConsts_UserNotExists object:self];
}

@end
