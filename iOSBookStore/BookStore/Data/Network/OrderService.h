//
//  OrderService.h
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

@interface OrderService : BaseService

+ (OrderService*)instance;

- (void)submitOrder:(NSArray*)shoppingCart forUserid:(NSInteger)userid whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed;
- (void)getOrdersforUserid:(NSInteger)userid whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed;

@end
