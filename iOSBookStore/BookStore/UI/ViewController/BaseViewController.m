//
//  BaseViewController.m
//  BookStore
//
//  Created by Ye Zhu on 8/25/12.
//
//

#import "BaseViewController.h"
#import "NotificationConsts.h"
#import "SVProgressHUD.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkError:) name:kNotificationConsts_NetworkError object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverError:) name:kNotificationConsts_ServerError object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkBegin:) name:kNotificationConsts_NetworkBegin object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkEnd:) name:kNotificationConsts_NetworkEnd object:nil];
        
        
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConsts_NetworkError object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConsts_ServerError object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConsts_NetworkBegin object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConsts_NetworkEnd object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showProgress
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"加载中...", nil)];
}

- (void)hideProgress
{
    [SVProgressHUD dismiss];
}

- (void)networkError:(NSNotification *)aNotification
{
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"网络错误", nil)];
}

- (void)serverError:(NSNotification *)aNotification
{
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"服务器忙", nil)];
}

- (void)networkBegin:(NSNotification *)aNotification
{
    [self showProgress];
}

- (void)networkEnd:(NSNotification *)aNotification
{
    [self hideProgress];
}

@end
