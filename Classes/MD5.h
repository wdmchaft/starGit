//
//  MD5.h
//  TestInterface
//
//  Created by apple_cyy on 11-2-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 32位md5加密
 */


#import <Foundation/Foundation.h>


@interface MD5 : NSObject 

/*
 对指定的字符串进行32位md5加密
 入参str是加密前的字符串
 返回值32位md5码
 */
+ (NSString *)md5Digest:(NSString *)str;

@end
