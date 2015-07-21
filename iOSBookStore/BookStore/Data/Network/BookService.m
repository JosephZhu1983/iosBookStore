//
//  BookService.m
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import "BookService.h"
#import "NetworkConsts.h"


@implementation BookService

+ (BookService*) instance
{
    static BookService* instance = nil;
    
    @synchronized(self){
		if (nil == instance) {
			instance = [[self alloc] init];
		}
	}
	
    return instance;
}


- (void)getBookswhenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed
{
    [self getBooksInCategory:0 withPageIndex:0 andPageSize:10 whenSuccess:success andFailed:failed];
}

- (void)getBooksInCategory:(NSInteger)categoryid withPageIndex:(NSInteger)pageindex andPageSize:(NSInteger)pagesize whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (categoryid >0)
    {
        [params setObject:[NSNumber numberWithInteger:categoryid] forKey:@"categoryid"];
    }
    [params setObject:[NSNumber numberWithInteger:pagesize] forKey:@"pagesize"];
    [params setObject:[NSNumber numberWithInteger:pageindex] forKey:@"pageindex"];
    
    [super sendRequestToController:kNetworkConsts_BookControllerPath andAction:kNetworkConsts_GetBooksActionPath
                         withParms:params whenSuccess:success andFailed:failed andEnableNotification:YES];
}

- (void)getBooksByIds:(NSArray*)bookids whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed
{
    NSString *bookidsString = [bookids componentsJoinedByString:@","];
    [super sendRequestToController:kNetworkConsts_BookControllerPath andAction:kNetworkConsts_GetBooksByIdsActionPath
                         withParms:[NSDictionary dictionaryWithObjects:@[bookidsString] forKeys:@[@"bookids"]] whenSuccess:success andFailed:failed andEnableNotification:YES];
}

- (void)getBookCategorieswhenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed
{
    
    [super sendRequestToController:kNetworkConsts_BookControllerPath andAction:kNetworkConsts_GetBookCategoriesActionPath
                         withParms:nil whenSuccess:success andFailed:failed andEnableNotification:YES];
}

@end
