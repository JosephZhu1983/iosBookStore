//
//  OrderController.h
//  BookStore
//
//  Created by Ye Zhu on 8/26/12.
//
//

#import <Foundation/Foundation.h>

@interface OrderController : NSObject

@property (nonatomic, strong) NSMutableArray *orders;

+ (OrderController*) instance;
- (void)submitOrder;
- (void)getOrders;

@end
