//
//  OtherController.h
//  BookStore
//
//  Created by Ye Zhu on 8/29/12.
//
//

#import <Foundation/Foundation.h>

@interface OtherController : NSObject

+ (OtherController*) instance;

- (void)addLogWithBookId:(NSInteger)bookid;
- (void)start;

@end
