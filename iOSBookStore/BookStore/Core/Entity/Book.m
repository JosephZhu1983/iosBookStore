//
//  Book.m
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import "Book.h"

@implementation Book

- (NSString *)description
{
    return [NSString stringWithFormat:@"bookid: %d, bookname: %@, bookdesc: %@, bookprice: %f, imagename: %@, categoryid: %d, categoryname: %@", self.bookid, self.bookname, self.bookdesc, [self.bookprice floatValue], self.imagename, self.categoryid, self.categoryname];
}

@end
