//
//  NeedLoginBaseViewController.m
//  BookStore
//
//  Created by Ye Zhu on 8/25/12.
//
//

#import "NeedLoginBaseViewController.h"
#import "LoginViewController.h"
#import "UserController.h"

@interface NeedLoginBaseViewController ()

@end

@implementation NeedLoginBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if (![[UserController instance] hasLogin])
    {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        loginViewController.delegate = self;
        UINavigationController *rootController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        
        loginViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.navigationController presentModalViewController:rootController animated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) cancelLogin
{
    [self dismissModalViewControllerAnimated:YES];
    [[appDelegate rootContoller] popViewControllerAnimated:NO];
}

@end
