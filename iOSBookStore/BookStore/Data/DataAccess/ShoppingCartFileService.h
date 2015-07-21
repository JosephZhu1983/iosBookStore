//
//  ShoppingCartFileService.h
//  BookStore
//
//  Created by Ye Zhu on 8/26/12.
//
//

#import <Foundation/Foundation.h>

#define kShoppingCartFile               @"shoppingcarts.plist"
#define kShoppingCartFileDataKey        @"shoppingcarts"

@interface ShoppingCartFileService : NSObject

+ (ShoppingCartFileService*)instance;

- (NSArray*)loadShoppingCart;
- (void)saveShoppingCart:(NSArray*)lists;

@end
