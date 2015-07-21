//
//  MyProfileViewController.m
//  BookStore
//
//  Created by Ye Zhu on 8/25/12.
//
//

#import "MyProfileViewController.h"
#import "UserController.h"
#import "NotificationConsts.h"
#import "OrderController.h"
#import "Order.h"

@interface MyProfileViewController ()

@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *ordercountLabel;
@property (nonatomic, weak) IBOutlet UITextField *newpasswordField;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (IBAction)changePasswordButtonPressed:(id)sender;

@end

@implementation MyProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"我的信息", nil);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"登出", nil) style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonPressed:)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrdersSuccess:) name:kNotificationConsts_GetOrdersSuccess object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllFirstResponder)];
    gestureRecognizer.cancelsTouchesInView = NO;
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    [[OrderController instance] getOrders];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.usernameLabel.text = [UserController instance].user.username;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)logoutButtonPressed:(UIBarButtonItem *)sender
{
    [self resignAllFirstResponder];
    [[UserController instance] logout];
    [appDelegate.rootContoller popViewControllerAnimated:YES];
}

- (IBAction)changePasswordButtonPressed:(id)sender
{
    [self resignAllFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePasswordSuccess:) name:kNotificationConsts_ChangePasswordSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePasswordFailed:) name:kNotificationConsts_UserNotExists object:nil];
    
    [[UserController instance] changePassword:self.newpasswordField.text];
}

- (void)removeChangePasswordObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConsts_ChangePasswordSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConsts_UserNotExists object:nil];
}

- (void)changePasswordSuccess:(NSNotification *)aNotification
{
    [self removeChangePasswordObserver];
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"消息", nil) message:NSLocalizedString(@"修改密码成功!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];
}

- (void)changePasswordFailed:(NSNotification *)aNotification
{
    [self removeChangePasswordObserver];
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"警告", nil) message:NSLocalizedString(@"修改密码失败!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭", nil) otherButtonTitles:nil];
    [alert show];
}

- (void)getOrdersSuccess:(NSNotification *)aNotification
{
    [self.tableView reloadData];
    self.ordercountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d 个", nil),[[OrderController instance].orders count]];
}

- (void)resignAllFirstResponder
{
    [self.newpasswordField resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[OrderController instance].orders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrderListCell";
        
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
    
	Order *order = [[OrderController instance].orders objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"订单号：%d 订单金额：%@ 元", nil), order.orderid, [order.totalprice stringValue]];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"订单时间：%@", nil), [dateFormatter stringFromDate:order.time]];
    
	return cell;

}

#pragma mark - UITableViewDelegate


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

@end
