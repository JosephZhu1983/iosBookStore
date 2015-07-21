//
//  Book.h
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic, assign) NSInteger bookid;
@property (nonatomic, assign) NSInteger categoryid;
@property (nonatomic, copy) NSString *bookname;
@property (nonatomic, copy) NSString *bookdesc;
@property (nonatomic, copy) NSString *categoryname;
@property (nonatomic, copy) NSString *imagename;
@property (nonatomic, copy) NSDecimalNumber *bookprice;

@end
