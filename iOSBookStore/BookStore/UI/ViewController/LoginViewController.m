//
//  LoginViewController.m
//  BookStore
//
//  Created by Ye Zhu on 8/25/12.
//
//

#import "LoginViewController.h"
#import "UserController.h"
#import "NotificationConsts.h"

@interface LoginViewController ()

@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UILabel *message;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonSystemItemCancel target:self action:@selector(cancelLoginButtonPressed:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"登陆", nil);
    self.message.text = NSLocalizedString(@"请先登陆", nil);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)loginButtonPressed:(id)sender
{
    [self resignAllFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:kNotificationConsts_LoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed:) name:kNotificationConsts_AuthFailed object:nil];
    
    [[UserController instance] loginWithUsername:self.usernameField.text andPassword:self.passwordField.text];
}

- (IBAction)registerButtonPressed:(id)sender
{
    [self resignAllFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccess:) name:kNotificationConsts_RegisterSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerFailed:) name:kNotificationConsts_UserExists object:nil];
    
    [[UserController instance] registerWithUsername:self.usernameField.text andPassword:self.passwordField.text];
}

- (void)cancelLoginButtonPressed:(id)sender
{
    [self resignAllFirstResponder];
    [self.delegate cancelLogin];
}

- (void)removeLoginObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConsts_LoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConsts_AuthFailed object:nil];
}

- (void)removeRegisterObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConsts_RegisterSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConsts_UserExists object:nil];
}

- (void)loginSuccess:(NSNotification *)aNotification
{
    [self removeLoginObserver];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)loginFailed:(NSNotification *)aNotification
{
    [self removeLoginObserver];
    self.message.text = NSLocalizedString(@"用户名或密码错误!", nil);
}

- (void)registerSuccess:(NSNotification *)aNotification
{
    [self removeRegisterObserver];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)registerFailed:(NSNotification *)aNotification
{
    [self removeRegisterObserver];
    self.message.text = NSLocalizedString(@"用户已经存在!", nil);
}
- (void)resignAllFirstResponder
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

@end
