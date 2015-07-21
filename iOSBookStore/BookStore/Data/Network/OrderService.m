//
//  OrderService.m
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import "OrderService.h"
#import "NetworkConsts.h"
#import "ShoppingCart.h"

@implementation OrderService

+ (OrderService*) instance
{
    
    static OrderService* instance = nil;

    @synchronized(self){
		if (nil == instance) {
			instance = [[self alloc] init];
		}
	}
	
    return instance;
}

- (void)submitOrder:(NSArray*)shoppingCart forUserid:(NSInteger)userid whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed
{
    [super sendRequestToController:kNetworkConsts_OrderControllerPath andAction:kNetworkConsts_SubmitOrderActionPath
                         withParms:[NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%d", userid], [[shoppingCart valueForKey:@"bookid"] componentsJoinedByString:@","], [[shoppingCart valueForKey:@"qty"] componentsJoinedByString:@","]] forKeys:@[@"userid", @"bookids", @"qtys"]] whenSuccess:success andFailed:failed andEnableNotification:YES];

}

- (void)getOrdersforUserid:(NSInteger)userid whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed
{
    [super sendRequestToController:kNetworkConsts_OrderControllerPath andAction:kNetworkConsts_GetOrdersActionPath withParms:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", userid] forKey:@"userid"] whenSuccess:success andFailed:failed andEnableNotification:YES];
}

@end
