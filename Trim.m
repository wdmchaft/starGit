//
//  Trim.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Trim.h"


@implementation Trim


/*
 字符串修整，去掉\r \n \t 以及空格
 入参string想要修整的字符串
 返回值是去掉\r \n \t 以及空格 之后的字符串
 */
+(NSString*)trim:(NSString*)string
{
	NSString* returnStr = string;
	returnStr = [returnStr stringByTrimmingCharactersInSet:([NSCharacterSet whitespaceAndNewlineCharacterSet])];
	returnStr = [returnStr stringByReplacingOccurrencesOfString: @"\r" withString: @""];
	returnStr = [returnStr stringByReplacingOccurrencesOfString: @"\n" withString: @""];
	returnStr = [returnStr stringByReplacingOccurrencesOfString: @"\t" withString: @""];
	returnStr = [returnStr stringByReplacingOccurrencesOfString:@" " withString:@""];
	
    return returnStr;
}


@end
