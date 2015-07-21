//
//  ViewLogService.h
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import <Foundation/Foundation.h>

@interface ViewLogService : NSObject

+ (ViewLogService*)instance;

- (void)start;
- (void)addLogWithBookId:(NSInteger)bookid;
- (NSArray*)getViewlogs;

@end
