//
//  ShoppingCartController.h
//  BookStore
//
//  Created by Ye Zhu on 8/26/12.
//
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import "ShoppingCart.h"

@interface ShoppingCartController : NSObject

+ (ShoppingCartController*) instance;

- (void)addShoppingCartWithBookid:(NSInteger)bookid andQty:(NSInteger)qty;
- (void)updateShoppingCartWithBookid:(NSInteger)bookid andQty:(NSInteger)qty;
- (void)removeShoppingCartWithBookId:(NSInteger)bookid;
- (void)clearShoppingCart;
- (ShoppingCart*)getShoppingCartWithBookid:(NSInteger)bookid;
- (NSArray*)getShoppintCarts;

@end
