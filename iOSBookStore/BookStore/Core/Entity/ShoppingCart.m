//
//  ShoppingCart.m
//  BookStore
//
//  Created by Ye Zhu on 8/26/12.
//
//

#import "ShoppingCart.h"
#import "UserDefaultsConsts.h"

@implementation ShoppingCart

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super init])) {
		self.bookid = [[aDecoder decodeObjectForKey:@"bookid"] integerValue];
		self.qty = [[aDecoder decodeObjectForKey:@"qty"] integerValue];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:[NSNumber numberWithInt:self.bookid] forKey:@"bookid"];
	[aCoder encodeObject:[NSNumber numberWithInt:self.qty] forKey:@"qty"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"bookid: %d, bookname: %@, bookprice: %f, imagename: %@, qty: %d,", self.bookid, self.bookname, [self.bookprice floatValue], self.imagename, self.qty];
}

@end
