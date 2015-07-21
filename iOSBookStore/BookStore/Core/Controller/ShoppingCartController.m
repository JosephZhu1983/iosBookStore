//
//  ShoppingCartController.m
//  BookStore
//
//  Created by Ye Zhu on 8/26/12.
//
//

#import "ShoppingCartController.h"
#import "ShoppingCartFileService.h"
#import "Shoppingcart.h"
#import "Book.h"
#import "BookService.h"
#import "NotificationConsts.h"
#import "BookController.h"


@implementation ShoppingCartController
{
    NSMutableArray *shoppingCarts;
}

+ (ShoppingCartController*) instance
{
    static ShoppingCartController* instance = nil;

    @synchronized(self){
		if (nil == instance) {
			instance = [[self alloc] init];
		}
	}
	
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        shoppingCarts = [[NSMutableArray alloc] initWithArray:[[ShoppingCartFileService instance]loadShoppingCart]];
        
        if (shoppingCarts.count >0)
        {
            [[BookService instance] getBooksByIds:[shoppingCarts valueForKey:@"bookid"] whenSuccess:^(NSDictionary *result)
             {
                 for (NSDictionary *item in result)
                 {
                     NSInteger bookid = [[item objectForKey:@"bookid"] integerValue];
                     NSArray* matchingCarts = [shoppingCarts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"bookid == %d", bookid]];
                     if ([matchingCarts count] >0)
                     {
                         ShoppingCart *cart = [matchingCarts objectAtIndex:0];
                         cart.bookname = [item objectForKey:@"bookname"];
                         cart.categoryname = [item objectForKey:@"categoryname"];
                         cart.imagename = [item objectForKey:@"imagename"];
                         cart.bookprice = [item objectForKey:@"bookprice"];
                     }
                 }
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConsts_GetBooksByIdsSuccess object:self];
             } andFailed:^(NSString *reason) {}];
            
            
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willTerminate:) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
    return self;
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)updateShoppingCartWithBookid:(NSInteger)bookid andQty:(NSInteger)qty;
{
    NSArray* matchingCarts = [shoppingCarts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"bookid == %d", bookid]];
    if ([matchingCarts count] >0)
    {
        ShoppingCart *item = [matchingCarts objectAtIndex:0];
        if (qty > 0)
        { 
            item.qty = qty;
        }
        else
        {
            [shoppingCarts removeObject:item];
        }
    }
    else
    {
        NSArray* matchingBooks = [[BookController instance].books filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"bookid == %d", bookid]];
        if ([matchingBooks count] >0)
        {
            Book *book = [matchingBooks objectAtIndex:0];
            ShoppingCart *item = [[ShoppingCart alloc] init];
            item.bookid = book.bookid;
            item.bookname = book.bookname;
            item.imagename = book.imagename;
            item.categoryname = book.categoryname;
            item.bookprice = book.bookprice;
            item.qty = qty;
            [shoppingCarts addObject:item];
        }
    }
}

- (void)addShoppingCartWithBookid:(NSInteger)bookid andQty:(NSInteger)qty
{
    NSArray* matchingCarts = [shoppingCarts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"bookid == %d", bookid]];
    if ([matchingCarts count] >0)
    {
        ShoppingCart *item = [matchingCarts objectAtIndex:0];
        [self updateShoppingCartWithBookid:bookid andQty:qty + item.qty];
    }
    else
    {
        [self updateShoppingCartWithBookid:bookid andQty:qty];
        
    }
    
}

- (void)removeShoppingCartWithBookId:(NSInteger)bookid
{
    NSArray* matchingCarts = [shoppingCarts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"bookid == %d", bookid]];
    [shoppingCarts removeObjectsInArray:matchingCarts];
}

- (void)clearShoppingCart
{
    [shoppingCarts removeAllObjects];
}

- (NSArray*)getShoppintCarts
{
    return shoppingCarts;
}

- (ShoppingCart*)getShoppingCartWithBookid:(NSInteger)bookid
{
    NSArray* matchingCarts = [shoppingCarts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"bookid == %d", bookid]];
    if ([matchingCarts count] >0)
    {
        return [matchingCarts objectAtIndex:0];
    }
    return nil;
}

-(void)willTerminate:(id)sender
{
    [[ShoppingCartFileService instance] saveShoppingCart:shoppingCarts];
}

-(void)didEnterBackground:(id)sender
{
    [[ShoppingCartFileService instance] saveShoppingCart:shoppingCarts];
}

@end
