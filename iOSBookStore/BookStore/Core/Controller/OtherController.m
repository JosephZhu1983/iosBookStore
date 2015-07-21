//
//  OtherController.m
//  BookStore
//
//  Created by Ye Zhu on 8/29/12.
//
//

#import "OtherController.h"
#import "ViewLogService.h"
#import "OtherService.h"
#import "UserController.h"

@implementation OtherController
{
    NSTimer *submitlogTimer;
}

+ (OtherController*) instance
{
    static OtherController* instance = nil;
    @synchronized(self){
		if (nil == instance) {
			instance = [[self alloc] init];
            
		}
	}
	
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        
        
    }
    
    return self;
}

- (void)start
{
    [[ViewLogService instance] start];
    if (!submitlogTimer)
        submitlogTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(submitviewlogTimerTick:) userInfo:nil repeats:YES];
}

- (void)submitviewlogTimerTick:(NSTimer*)sender
{
    @try {
        NSArray *logs = [[ViewLogService instance] getViewlogs];
        if (logs != nil && [logs count]>0)
        {
            [[OtherService instance] submitViewLogs:logs forUserid:[UserController instance].user.userid whenSuccess:^(NSDictionary *result){
                NSLog(@"成功提交 %d 条日志！", [logs count]);
            } andFailed:^(NSString *reason){
            }];
        }
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"submitviewlogTimerTick Error: %@", exception);
    }
    @finally {
        
    }
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:nil];
    if ([submitlogTimer isValid])
        [submitlogTimer invalidate];
}

- (void)addLogWithBookId:(NSInteger)bookid
{
    [[ViewLogService instance] addLogWithBookId:bookid];
}

@end
