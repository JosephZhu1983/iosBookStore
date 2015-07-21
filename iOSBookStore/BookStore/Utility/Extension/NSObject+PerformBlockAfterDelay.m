//
//  NSObject+PerformBlockAfterDelay.m
//  BookStore
//
//  Created by Ye Zhu on 8/27/12.
//
//

#import "NSObject+PerformBlockAfterDelay.h"

@implementation NSObject (PerformBlockAfterDelay)

- (void)performBlock:(void (^)(void))block
          afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}

@end