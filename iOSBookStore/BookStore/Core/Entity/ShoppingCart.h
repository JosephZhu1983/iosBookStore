//
//  ShoppingCart.h
//  BookStore
//
//  Created by Ye Zhu on 8/26/12.
//
//

#import <Foundation/Foundation.h>

@interface ShoppingCart : NSObject<NSCoding>

@property (nonatomic, copy) NSString *bookname;
@property (nonatomic, copy) NSString *imagename;
@property (nonatomic, copy) NSString *categoryname;
@property (nonatomic, copy) NSDecimalNumber *bookprice;
@property (nonatomic, assign) NSInteger bookid;
@property (nonatomic, assign) NSInteger qty;

@end
