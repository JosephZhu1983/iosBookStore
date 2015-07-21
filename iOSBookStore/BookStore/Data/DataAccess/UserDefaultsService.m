//
//  UserDefaultsService.m
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import "UserDefaultsService.h"
#import "UserDefaultsConsts.h"

@implementation UserDefaultsService


+ (UserDefaultsService*) instance
{
    static UserDefaultsService* instance = nil;

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
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willTerminate:) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
    return self;
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)willTerminate:(id)sender
{
    [self syncToDisk];
}

-(void)didEnterBackground:(id)sender
{
    [self syncToDisk];
}

-(void)syncToDisk
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)getUserId
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaults_Userid];
}

- (void)setUserId:(NSInteger)userId
{
    [[NSUserDefaults standardUserDefaults] setInteger:userId forKey:kUserDefaults_Userid];
    [self syncToDisk];
}

- (NSString*)getUsername
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaults_Username];
}

- (void)setUsername:(NSString*)username
{
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kUserDefaults_Username];
}

@end
