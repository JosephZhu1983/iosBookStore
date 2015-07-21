//
//  Order.h
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic, assign) NSInteger orderid;
@property (nonatomic, copy) NSDecimalNumber *totalprice;
@property (nonatomic, copy) NSDate *time;
@property (nonatomic, strong) NSMutableArray *items;

@end
