//
//  Order.m
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import "Order.h"

@implementation Order


- (id)init
{
    self = [super init];
    if (self) {
        
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
