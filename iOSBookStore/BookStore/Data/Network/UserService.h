//
//  UserService.h
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

@interface UserService : BaseService

+ (UserService*)instance;

- (void)loginWithUsername:(NSString*)username andPassword:(NSString*)password whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed;
- (void)registerWithUsername:(NSString*)username andPassword:(NSString*)password whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed;
- (void)changePassword: (NSString*)password forUserid:(NSInteger)userid whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed;
@end
