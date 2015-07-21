//
//  OrderController.m
//  BookStore
//
//  Created by Ye Zhu on 8/26/12.
//
//

#import "OrderController.h"
#import "OrderService.h"
#import "UserController.h"
#import "NotificationConsts.h"
#import "ShoppingCartController.h"
#import "Order.h"
#import "OrderItem.h"
#import "NSString+Json.h"

@implementation OrderController
{
    
}

+ (OrderController*) instance
{
    static OrderController* instance = nil;

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
        self.orders = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    return self;
}

- (void)submitOrder
{
    [[OrderService instance] submitOrder:[[ShoppingCartController instance] getShoppintCarts] forUserid:[UserController instance].user.userid whenSuccess:^(NSDictionary *result) {
        
        [[ShoppingCartController instance] clearShoppingCart];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConsts_SubmitOrderSuccess object:self];
        
    } andFailed:^(NSString *reason) {
        
    }];
}

- (void)getOrders
{
    [[OrderService instance] getOrdersforUserid:[UserController instance].user.userid whenSuccess:^(NSDictionary *result)
     {
         @synchronized(self){
             [self.orders removeAllObjects];
             for (NSDictionary *item in result)
             {
                 Order *order = [[Order alloc]init];
                 order.orderid = [[item objectForKey:@"orderid"] integerValue];
                 order.totalprice = [item objectForKey:@"totalprice"];
                 order.time = [[item objectForKey:@"time"] getJSONDate];
                 for(NSDictionary *oi in [item objectForKey:@"orderitems"])
                 {
                     OrderItem *item = [[OrderItem alloc] init];
                     item.bookid = [[oi objectForKey:@"bookid"] integerValue];
                     item.bookname = [oi objectForKey:@"bookname"];
                     item.price = [oi objectForKey:@"price"];
                     item.totalprice = [oi objectForKey:@"totalprice"];
                     item.qty = [[oi objectForKey:@"qty"] integerValue];
                     [order.items addObject:item];
                 }
                 [self.orders addObject:order];
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConsts_GetOrdersSuccess object:self];
         }
     } andFailed:^(NSString *reason) {}];
}

@end
