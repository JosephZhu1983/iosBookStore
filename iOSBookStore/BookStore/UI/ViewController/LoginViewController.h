//
//  LoginViewController.h
//  BookStore
//
//  Created by Ye Zhu on 8/25/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LoginViewControllerDelegate.h"

@interface LoginViewController : BaseViewController

@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;

@end
