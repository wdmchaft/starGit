//
//  URLEncode.h
//  TestInterface
//
//  Created by apple_cyy on 11-2-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


/*
 对url进行编码
 接口需要对部分参数进行url编码
 */


#import <Foundation/Foundation.h>


@interface URLEncode : NSObject 

/*
 对指定的参数进行url编码
 入参sourceString 是希望进行编码的字符串
 返回值是编码后的字符串,此方法对!*'();:@&=+$,/?%#[]都做了编码
 */
+(NSString *) encodeUrlStr:(NSString *)sourceString;

@end
