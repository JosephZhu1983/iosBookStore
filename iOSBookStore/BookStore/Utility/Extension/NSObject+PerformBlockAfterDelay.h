//
//  NSObject+PerformBlockAfterDelay.h
//  BookStore
//
//  Created by Ye Zhu on 8/27/12.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformBlockAfterDelay)

- (void)performBlock:(void (^)(void))block
          afterDelay:(NSTimeInterval)delay;

@end
