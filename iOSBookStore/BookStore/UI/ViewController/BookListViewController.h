//
//  BookListViewController.h
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SubmitOrderDelegate.h"
#import "STableViewController.h"

@interface BookListViewController : STableViewController<UISearchBarDelegate,UIGestureRecognizerDelegate, SubmitOrderDelegate>

@end
