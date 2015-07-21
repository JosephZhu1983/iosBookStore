//
//  UserDefaultsService.h
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import <Foundation/Foundation.h>

@interface UserDefaultsService : NSObject

+ (UserDefaultsService*)instance;

-(void)syncToDisk;
- (NSInteger)getUserId;
- (void)setUserId:(NSInteger)userId;
- (NSString*)getUsername;
- (void)setUsername:(NSString*)username;
@end
