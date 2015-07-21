//
//  ViewLogService.m
//  BookStore
//
//  Created by Ye Zhu on 8/24/12.
//
//

#import "ViewLogService.h"
#import "FMDatabase.h"
#import "ViewLog.h"
#import "OtherService.h"

@implementation ViewLogService
{
    NSTimer *submitlogTimer;
}

+ (ViewLogService*) instance
{
    static ViewLogService* instance = nil;
    
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];

    }
    
    return self;
}



-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:nil];
    if ([submitlogTimer isValid])
        [submitlogTimer invalidate];
}

-(NSString*)getdbpath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"viewlog.sqlite"];
    return dbPath;
}

-(void)didFinishLaunching:(id)sender
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    if([fileManager fileExistsAtPath:[self getdbpath]]==NO){
        
        NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:@"viewlog" ofType: @"sqlite"];
        BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:[self getdbpath] error:&error];
        
        if(!success){
            NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
}

- (void)start
{
    
}

- (void)addLogWithBookId:(NSInteger)bookid
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getdbpath]] ;
    
    @try {
        
        if (![db open]) {
            NSLog(@"Could not open db in %@", [self getdbpath]);
            return ;
        }
        
        NSDictionary *argsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:bookid], @"bookid", [NSDate date], @"submittime", nil];
        [db executeUpdate:@"INSERT INTO log (bookid, submittime) VALUES (:bookid, :submittime)" withParameterDictionary:argsDict];
        
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"addLogWithBookId Error: %@", exception);
    }
    @finally {
        [db close];
        
    }
    
}

- (NSArray*)getViewlogs
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getdbpath]] ;
    
    @try {
        
        if (![db open]) {
            NSLog(@"Could not open db in %@", [self getdbpath]);
            return nil;
        }
        
        FMResultSet *rs = [db executeQuery:@"SELECT bookid, submittime FROM log"];
        NSMutableArray *logs = [[NSMutableArray alloc] init];
        while ([rs next]) {
            ViewLog *log = [[ViewLog alloc] init];
            log.bookid = [rs intForColumn:@"bookid"];
            log.time = [rs dateForColumn:@"submittime"];
            [logs addObject:log];
        }
        
        [rs close];

        [db executeUpdate:@"delete from log"];
        
        return logs;
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"addLogWithBookId Error: %@", exception);
    }
    @finally {
        [db close];
        
    }
    
}

@end
