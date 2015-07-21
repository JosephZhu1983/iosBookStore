//
//  BaseService.h
//  BookStore
//
//  Created by Ye Zhu on 8/25/12.
//
//

#import <Foundation/Foundation.h>
#import "Blocks.h"

@interface BaseService : NSObject

-(NSURL*)getUrl;
-(void)sendRequestToController:(NSString*)controller andAction:(NSString*)action withParms:(NSDictionary*)params whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed andEnableNotification:(BOOL)b;
-(void)sendRequestToPath:(NSString*)path withParms:(NSDictionary*)params whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed andEnableNotification:(BOOL)b;
@end
