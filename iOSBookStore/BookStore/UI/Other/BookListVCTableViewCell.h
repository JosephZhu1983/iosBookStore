//
//  BookListVCTableViewCell.h
//  BookStore
//
//  Created by Ye Zhu on 8/26/12.
//
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "ShoppingCart.h"
#import "UpdateShoppingCartDelegate.h"

#define kBookListTableViewCell      @"BookListVCTableViewCell"

@interface BookListVCTableViewCell : UITableViewCell

@property (nonatomic, weak) id<UpdateShoppingCartDelegate> delegate;

- (void)configureForBook:(Book*)book;
- (void)configureForShoppingCart:(ShoppingCart*)cart;
@end
