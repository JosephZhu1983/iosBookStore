//
//  BookService.h
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

@interface BookService : BaseService

+ (BookService*)instance;

- (void)getBookswhenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed;
- (void)getBooksByIds:(NSArray*)bookids whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed;
- (void)getBooksInCategory:(NSInteger)categoryid withPageIndex:(NSInteger)pageindex andPageSize:(NSInteger)pagesize whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed;
- (void)getBookCategorieswhenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed;

@end
