//
//  BookController.h
//  BookStore
//
//  Created by Ye Zhu on 8/26/12.
//
//

#import <Foundation/Foundation.h>
#import "Book.h"

@interface BookController : NSObject

@property (nonatomic, strong) NSMutableArray *books;
@property (nonatomic, strong) NSMutableArray *bookcategories;

+ (BookController*) instance;

- (void)setBookImage:(NSString*)imagename onImageView:(UIImageView*)image;
- (void)getBooksInCategory:(NSInteger)categoryid ;
- (void)getMoreBooksInCategory:(NSInteger)categoryid;
- (void)getBookCategories;
- (BOOL)canGetMoreBooks;

@end
