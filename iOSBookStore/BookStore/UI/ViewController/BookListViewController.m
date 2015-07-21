//
//  BookListViewController.m
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import "BookListViewController.h"
#import "MyProfileViewController.h"
#import "LoginViewController.h"
#import "BookController.h"
#import "BookListVCTableViewCell.h"
#import "NotificationConsts.h"
#import "MyShoppingCartViewController.h"
#import "Book.h"
#import "BookDetailViewController.h"
#import "SVProgressHUD.h"
#import "BookListVCTableViewFooter.h"
#import "BookListVCTableViewHeader.h"

@interface BookListViewController ()

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
//@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end


@implementation BookListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = NSLocalizedString(@"书籍列表", @"");
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"我的信息", nil) style:UIBarButtonItemStylePlain target:self action:@selector(viewMyProfileButtonPressed:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"购物车", nil) style:UIBarButtonItemStylePlain target:self action:@selector(viewMyShoppingCartButtonPressed:)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBooksSuccess:) name:kNotificationConsts_GetBooksSuccess object:nil];
        
        
	}
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConsts_GetBooksSuccess object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UINib *cellNib = [UINib nibWithNibName:kBookListTableViewCell bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:kBookListTableViewCell];
    self.tableView.rowHeight = 100;
    
    
    NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"BookListVCTableViewHeader" owner:self options:nil];
    
    BookListVCTableViewHeader *headerView = (BookListVCTableViewHeader *)[nib1 objectAtIndex:0];
    self.headerView = headerView;
    
    NSArray *nib2 = [[NSBundle mainBundle] loadNibNamed:@"BookListVCTableViewFooter" owner:self options:nil];
    BookListVCTableViewFooter *footerView = (BookListVCTableViewFooter *)[nib2 objectAtIndex:0];
    self.footerView = footerView;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllFirstResponder)];
    gestureRecognizer.cancelsTouchesInView = NO;
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    [self performSearchWithKeyword:nil];
}

- (void)resignAllFirstResponder
{
    [self.searchBar resignFirstResponder];
}

- (void)performSearchWithKeyword:(NSString*)keyword
{
    [self resignAllFirstResponder];
    [[BookController instance] getBooksInCategory:0];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UISearchBar class]]){
        return NO;
    }
    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewMyProfileButtonPressed:(UIBarButtonItem *)sender
{
    UIViewController *myProfileViewController = [[MyProfileViewController alloc] init];
    [self.navigationController pushViewController:myProfileViewController animated:YES];
}

- (void)viewMyShoppingCartButtonPressed:(UIBarButtonItem *)sender
{
    MyShoppingCartViewController *myShoppingCartViewController = [[MyShoppingCartViewController alloc] init];
    UINavigationController *rootController = [[UINavigationController alloc] initWithRootViewController:myShoppingCartViewController];
    myShoppingCartViewController.delegate = self;
    myShoppingCartViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentModalViewController:rootController animated:YES];
}

- (void)getBooksSuccess:(NSNotification *)aNotification
{
    if (![[BookController instance] canGetMoreBooks]) {
        BookListVCTableViewFooter *fv = (BookListVCTableViewFooter *)self.footerView;
        fv.infoLabel.hidden = NO;
    }
    [super refreshCompleted];
    [self.tableView reloadData];
}

- (void)submitOrderSuccess
{
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *books = [BookController instance].books;
	return books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookListVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBookListTableViewCell];
    
    NSArray *books = [BookController instance].books;
    if (books.count > indexPath.row)
    {
        Book *book = [books objectAtIndex:indexPath.row];
        [cell configureForBook:book];
    }
    return cell;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    NSArray *books = [BookController instance].books;
    if (books.count > indexPath.row)
    {
        Book *book = [books objectAtIndex:indexPath.row];
        
        BookDetailViewController *detailViewController = [[BookDetailViewController alloc]init];
        detailViewController.book = book;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performSearchWithKeyword:self.searchBar.text];
}


#pragma mark - Pull to Refresh


- (void) pinHeaderView
{
    [super pinHeaderView];
    
    BookListVCTableViewHeader *hv = (BookListVCTableViewHeader *)self.headerView;
    hv.infoLabel.text = NSLocalizedString(@"数据加载中...", nil);
}


- (void) unpinHeaderView
{
    [super unpinHeaderView];
    
}
- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
    BookListVCTableViewHeader *hv = (BookListVCTableViewHeader *)self.headerView;
    if (willRefreshOnRelease)
        hv.infoLabel.text = NSLocalizedString(@"放开刷新...", nil);
    else
        hv.infoLabel.text = NSLocalizedString(@"下拉刷新...", nil);
}


- (BOOL) refresh
{
    if (![super refresh])
        return NO;
    
    [self performSearchWithKeyword:nil];
    
    return YES;
}

#pragma mark - Load More

- (BOOL) loadMore
{
    if (![super loadMore])
        return NO;
    
    [self loadMoreBooks];
    return YES;
}

- (void) loadMoreBooks
{
    [[BookController instance] getMoreBooksInCategory:0];
}

@end
