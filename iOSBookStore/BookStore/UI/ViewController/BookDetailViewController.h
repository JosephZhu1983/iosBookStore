//
//  BookDetailViewController.h
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Book.h"

@interface BookDetailViewController : BaseViewController

@property (strong, nonatomic) Book *book;

@end
