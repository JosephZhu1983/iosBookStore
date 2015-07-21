//
//  UserController.h
//  BookStore
//
//  Created by Ye Zhu on 8/25/12.
//
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserController : NSObject

@property (nonatomic, strong) User *user;

+ (UserController*) instance;

- (BOOL)hasLogin;
- (void)loginWithUsername: (NSString*)username andPassword:(NSString*)password;
- (void)registerWithUsername: (NSString*)username andPassword:(NSString*)password;
- (void)changePassword:(NSString*)password;
- (void)logout;
@end
