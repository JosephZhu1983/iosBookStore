//
//  BookDetailViewController.m
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import "BookDetailViewController.h"
#import "Global.h"
#import "AppDelegate.h"
#import "TextStepperField.h"
#import "BookController.h"
#import "ShoppingCart.h"
#import "ShoppingCartController.h"
#import "SVProgressHUD.h"
#import "OtherController.h"

@interface BookDetailViewController ()

@property (nonatomic, weak) IBOutlet UILabel *booknameLabel;
@property (nonatomic, weak) IBOutlet UILabel *bookcategoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *bookpriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *shoppingCartLabel;
@property (nonatomic, weak) IBOutlet UIImageView *bookImage;
@property (nonatomic, weak) IBOutlet UITextView *bookdesc;
@property (nonatomic, weak) IBOutlet UIButton  *removeFromShoppingCartButton;
@property (nonatomic, weak) IBOutlet TextStepperField *bookcountStepper;

- (IBAction)removeFromShoppingCart:(id)sender;
- (IBAction)addToShoppingCart:(id)sender;

@end

@implementation BookDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.bookcountStepper setCurrent:1];
    [self.bookcountStepper setMaximum:99];
    [self.bookcountStepper setMinimum:1];
    [self.bookcountStepper setIsEditableTextField:NO];
    
    self.booknameLabel.text = self.book.bookname;
    self.bookcategoryLabel.text = self.book.categoryname;
    self.bookpriceLabel.text = [NSString stringWithFormat:NSLocalizedString(@"价格为 %@ 元", nil), [self.book.bookprice stringValue]];
    [[BookController instance] setBookImage:self.book.imagename onImageView:self.bookImage];
    self.bookdesc.text = self.book.bookdesc;
    [self.bookdesc setEditable:NO];
    
    [self reload];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[OtherController instance] addLogWithBookId:self.book.bookid];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)reload
{
    ShoppingCart *cart  = [[ShoppingCartController instance] getShoppingCartWithBookid:self.book.bookid];
    
    NSInteger qty = 0;
    if (cart != nil)
    {
        qty = cart.qty;
    }
    
    self.shoppingCartLabel.text = [NSString stringWithFormat:NSLocalizedString(@"已经购买了 %d 本", nil), qty];
    
    [self.removeFromShoppingCartButton setEnabled:qty >0];
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

- (IBAction)removeFromShoppingCart:(id)sender
{
    [[ShoppingCartController instance] removeShoppingCartWithBookId:self.book.bookid];
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"从购物车删除成功", nil)];
    [self reload];
}
- (IBAction)addToShoppingCart:(id)sender
{
    [[ShoppingCartController instance] addShoppingCartWithBookid:self.book.bookid andQty: self.bookcountStepper.Current];
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"加入购物车成功", nil)];
    [self reload];
}

@end
