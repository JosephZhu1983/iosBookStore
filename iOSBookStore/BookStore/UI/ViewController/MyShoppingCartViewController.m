//
//  MyShoppingCartViewController.m
//  BookStore
//
//  Created by Ye Zhu on 8/26/12.
//
//

#import "MyShoppingCartViewController.h"
#import "ShoppingCartController.h"
#import "BookListVCTableViewCell.h"
#import "ShoppingCart.h"
#import "NotificationConsts.h"
#import "OrderController.h"
#import "SVProgressHUD.h"
#import "NSObject+PerformBlockAfterDelay.h"

@interface MyShoppingCartViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *bookcountLabel;
@property (nonatomic, weak) IBOutlet UILabel *bookpriceLabel;

- (IBAction)clearShoppingCart:(id)sender;

@end

@implementation MyShoppingCartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"购物车", @"");
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"提交订单", nil) style:UIBarButtonItemStylePlain target:self action:@selector(submitOrderButtonPressed:)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBooksSuccess:) name:kNotificationConsts_GetBooksByIdsSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitOrderSuccess:) name:kNotificationConsts_SubmitOrderSuccess object:nil];
        
    }
    return self;
}

- (void)submitOrderButtonPressed:(UIBarButtonItem *)sender
{
    if ([[[ShoppingCartController instance] getShoppintCarts] count] >0)
        [[OrderController instance] submitOrder];
    else
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"您的购物车为空!", nil)];
}

- (void)backButtonPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateShoppingCart];
}

- (void)delloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConsts_GetBooksByIdsSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConsts_SubmitOrderSuccess object:nil];
 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:kBookListTableViewCell bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:kBookListTableViewCell];
    self.tableView.rowHeight = 100;
    
}

- (void)getBooksSuccess:(NSNotification *)aNotification
{
    [self updateShoppingCart];
}

- (void)submitOrderSuccess:(NSNotification *)aNotification
{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"消息", nil) message:NSLocalizedString(@"提交订单成功!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];
    [self dismissModalViewControllerAnimated:YES];
    [[self delegate] submitOrderSuccess];
}

-(void)updateShoppingCart
{
    NSArray *carts = [[ShoppingCartController instance] getShoppintCarts];
    
    NSInteger bookcount = [carts count];
    NSInteger bookqty = [[carts valueForKeyPath:@"@sum.qty"] integerValue];
    float bookprice = 0;
    for(ShoppingCart *cart in carts)
    {
        bookprice+= [cart.bookprice floatValue] * cart.qty;
    }
    self.bookcountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"您总共选购了 %d 种图书，共计 % d 本", nil), bookcount, bookqty];
    self.bookpriceLabel.text = [NSString stringWithFormat:NSLocalizedString(@"总价格为 %.2f 元", nil), bookprice];
    
    [self.tableView reloadData];
}

- (IBAction)clearShoppingCart:(id)sender
{
    [[ShoppingCartController instance] clearShoppingCart];
    [self updateShoppingCart];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *carts = [[ShoppingCartController instance] getShoppintCarts];
	return carts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookListVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBookListTableViewCell];
    
    cell.delegate = self;
    NSArray *carts = [[ShoppingCartController instance] getShoppintCarts];
    if (carts.count > indexPath.row)
    {
        ShoppingCart *cart = [carts objectAtIndex:indexPath.row];
        [cell configureForShoppingCart:cart];
    }
    return cell;
}

#pragma mark - UITableViewDelegate


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
