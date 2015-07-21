//
//  OtherService.h
//  BookStore
//
//  Created by Ye Zhu on 8/29/12.
//
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

@interface OtherService : BaseService

+ (OtherService*)instance;

- (void)submitViewLogs:(NSArray*)viewlogs forUserid:(NSInteger)userid whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed;

@end
