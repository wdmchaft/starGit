//
//  MD5.m
//  TestInterface
//
//  Created by apple_cyy on 11-2-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MD5.h"
#import <CommonCrypto/CommonDigest.h>


@implementation MD5


/*
 对指定的字符串进行32位md5加密
 入参str是加密前的字符串
 返回值32位md5码
 */
+ (NSString *)md5Digest:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    return [[NSString stringWithFormat:
			 @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			 result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			 result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			 ] uppercaseString];
}

@end
