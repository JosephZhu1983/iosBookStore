//
//  MyShoppingCartViewController.h
//  BookStore
//
//  Created by Ye Zhu on 8/26/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UpdateShoppingCartDelegate.h"
#import "SubmitOrderDelegate.h"

@interface MyShoppingCartViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UpdateShoppingCartDelegate>

@property (nonatomic,weak) id<SubmitOrderDelegate> delegate;

@end
