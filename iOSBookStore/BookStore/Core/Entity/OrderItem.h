//
//  OrderItem.h
//  BookStore
//
//  Created by Ye Zhu on 8/26/12.
//
//

#import <Foundation/Foundation.h>

@interface OrderItem : NSObject

@property (nonatomic, assign) NSInteger bookid;
@property (nonatomic, copy) NSDecimalNumber *price;
@property (nonatomic, copy) NSDecimalNumber *totalprice;
@property (nonatomic, copy) NSString *bookname;
@property (nonatomic, assign) NSInteger qty;

@end
