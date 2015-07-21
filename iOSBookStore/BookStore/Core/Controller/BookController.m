//
//  BookController.m
//  BookStore
//
//  Created by Ye Zhu on 8/26/12.
//
//

#import "BookController.h"
#import "BookService.h"
#import "Book.h"
#import "Category.h"
#import "UIImageView+AFNetworking.h"
#import "NotificationConsts.h"

static const NSInteger pagesize = 10;

@implementation BookController
{
    NSInteger currentPageIndex;
    BOOL hasMoreBooks;
}

+ (BookController*) instance
{
    static BookController* instance = nil;
    
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
        currentPageIndex = 0;
        hasMoreBooks = YES;
        self.books = [[NSMutableArray alloc] initWithCapacity:10];
        self.bookcategories = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    return self;
}

- (void)setBookImage:(NSString*)imagename onImageView:(UIImageView*)image
{
    if (imagename != nil)
    {
        NSURL *url= [[BookService instance] getUrl];
        [image setImageWithURL: [url URLByAppendingPathComponent: imagename]];
    }
}

- (void)getBooksInCategory:(NSInteger)categoryid
{
    [self _getBooksInCategory:categoryid refresh:YES];
}

- (void)getMoreBooksInCategory:(NSInteger)categoryid
{
    [self _getBooksInCategory:categoryid refresh:NO];
}

- (void)_getBooksInCategory:(NSInteger)categoryid refresh:(BOOL)refresh
{
    if (refresh)
    {
        currentPageIndex = 0;
    }
    else
    {
        currentPageIndex++;
    }
    
    [[BookService instance] getBooksInCategory:categoryid withPageIndex:currentPageIndex andPageSize:pagesize whenSuccess:^(NSDictionary *result)
     {
         @synchronized(self){
             if (refresh)
             {
                 [self.books removeAllObjects];
                 hasMoreBooks = YES;
             }
             else
             {
                 hasMoreBooks = [result count] == pagesize;
             }
             if ([result count] >0)
             {
                 for (NSDictionary *item in result)
                 {
                     Book *book = [[Book alloc]init];
                     book.bookdesc = [item objectForKey:@"bookdesc"];
                     book.bookname = [item objectForKey:@"bookname"];
                     book.bookid = [[item objectForKey:@"bookid"] integerValue];
                     book.categoryid = [[item objectForKey:@"categoryid"] integerValue];
                     book.categoryname = [item objectForKey:@"categoryname"];
                     book.imagename = [item objectForKey:@"imagename"];
                     book.bookprice = [item objectForKey:@"bookprice"];
                     
                     [self.books addObject:book];
                 }
                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConsts_GetBooksSuccess object:self];
             }
         }
     } andFailed:^(NSString *reason) {}];
}

- (BOOL)canGetMoreBooks
{
    return hasMoreBooks;
}

- (void)getBookCategories
{
    [[BookService instance] getBookCategorieswhenSuccess:^(NSDictionary *result)
     {
         @synchronized(self){
             [self.bookcategories removeAllObjects];
             for (NSDictionary *item in result)
             {
                 Category *category = [[Category alloc]init];
                 category.categoryid = [[item objectForKey:@"id"] integerValue];
                 category.categoryname = [item objectForKey:@"name"];
                 [self.bookcategories addObject:category];
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConsts_GetBookCategoriesSuccess object:self];
         }
     } andFailed:^(NSString *reason) {}];
}


@end
