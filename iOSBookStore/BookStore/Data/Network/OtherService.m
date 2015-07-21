//
//  OtherService.m
//  BookStore
//
//  Created by Ye Zhu on 8/29/12.
//
//

#import "OtherService.h"
#import "NetworkConsts.h"
#import "ViewLog.h"

@implementation OtherService

+ (OtherService*) instance
{
    static OtherService* instance = nil;
    
    @synchronized(self){
		if (nil == instance) {
			instance = [[self alloc] init];
		}
	}
	
    return instance;
}

- (void)submitViewLogs:(NSArray*)viewlogs forUserid:(NSInteger)userid whenSuccess:(NetworkRequestSuccessCallback)success andFailed:(NetworkRequestFailedCallback)failed
{
    
    [super sendRequestToController:kNetworkConsts_OtherControllerPath andAction:kNetworkConsts_SubmitViewLogsActionPath
                         withParms:[NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%d", userid], [[viewlogs valueForKey:@"bookid"] componentsJoinedByString:@","], [[viewlogs valueForKey:@"time"] componentsJoinedByString:@","]] forKeys:@[@"userid", @"bookids", @"times"]] whenSuccess:success andFailed:failed andEnableNotification:NO];
    
}

@end
