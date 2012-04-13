//
//  URLEncode.m
//  TestInterface
//
//  Created by apple_cyy on 11-2-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "URLEncode.h"


@implementation URLEncode


/*
 对指定的参数进行url编码
 入参sourceString 是希望进行编码的字符串
 返回值是编码后的字符串,此方法对!*'();:@&=+$,/?%#[]都做了编码
 */
+(NSString *) encodeUrlStr:(NSString *)sourceString
{
	NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																				  NULL,
																				  (CFStringRef)sourceString,
																				  NULL,
																				  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				  kCFStringEncodingUTF8 );
	return encodedString;

}

@end
