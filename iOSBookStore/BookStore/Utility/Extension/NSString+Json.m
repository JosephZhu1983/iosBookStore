//
//  NSString+Json.m
//  BookStore
//
//  Created by Ye Zhu on 8/29/12.
//
//

#import "NSString+Json.h"

@implementation NSString (Json)

- (NSDate *) getJSONDate{
    NSString* header = @"/Date(";
    uint headerLength = [header length];
    
    NSString*  timestampString;
    
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    [scanner setScanLocation:headerLength];
    [scanner scanUpToString:@")" intoString:&timestampString];
    
    NSCharacterSet* timezoneDelimiter = [NSCharacterSet characterSetWithCharactersInString:@"+-"];
    NSRange rangeOfTimezoneSymbol = [timestampString rangeOfCharacterFromSet:timezoneDelimiter];
    
    if (rangeOfTimezoneSymbol.length!=0) {
        scanner = [[NSScanner alloc] initWithString:timestampString];
        
        NSRange rangeOfFirstNumber;
        rangeOfFirstNumber.location = 0;
        rangeOfFirstNumber.length = rangeOfTimezoneSymbol.location;
        
        NSRange rangeOfSecondNumber;
        rangeOfSecondNumber.location = rangeOfTimezoneSymbol.location + 1;
        rangeOfSecondNumber.length = [timestampString length] - rangeOfSecondNumber.location;
        
        NSString* firstNumberString = [timestampString substringWithRange:rangeOfFirstNumber];

        unsigned long long firstNumber = [firstNumberString longLongValue];
        
        NSTimeInterval interval = firstNumber/1000;
        
        return [NSDate dateWithTimeIntervalSince1970:interval];
    }
    
    unsigned long long firstNumber = [timestampString longLongValue];
    NSTimeInterval interval = firstNumber/1000;
    
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

@end
