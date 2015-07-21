//
//  ShoppingCartFileService.m
//  BookStore
//
//  Created by Ye Zhu on 8/26/12.
//
//

#import "ShoppingCartFileService.h"

@implementation ShoppingCartFileService


+ (ShoppingCartFileService*) instance
{
    static ShoppingCartFileService* instance = nil;

    @synchronized(self){
		if (nil == instance) {
			instance = [[self alloc] init];
		}
	}
	
    return instance;
}

- (NSString *)documentsDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}

- (NSString *)dataFilePath
{
	return [[self documentsDirectory] stringByAppendingPathComponent:kShoppingCartFile];
}

- (void)saveShoppingCart:(NSArray*)lists
{
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:lists forKey:kShoppingCartFileDataKey];
	[archiver finishEncoding];
	[data writeToFile:[self dataFilePath] atomically:YES];
}

- (NSArray*)loadShoppingCart
{
	NSString *path = [self dataFilePath];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSData *data = [[NSData alloc] initWithContentsOfFile:path];
		NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		NSArray *lists = [unarchiver decodeObjectForKey:kShoppingCartFileDataKey];
		[unarchiver finishDecoding];
        return lists;
    }
    return nil;
}



@end
