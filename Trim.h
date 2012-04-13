//
//  Trim.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


/*
 去掉指定 字符串 中的\r \n \t 以及空格
 
 
 
 本类用来对指定的字符串进行修整。
 主要功能是去掉指定字符串中的 \r \n \t 以及空格
 此类主要 去除xml里 一些不规范标签里面的换行以及空格
 */

#import <Foundation/Foundation.h>


@interface Trim : NSObject 



/*
 字符串修整，去掉\r \n \t 以及空格
 入参string想要修整的字符串
 返回值是去掉\r \n \t 以及空格 之后的字符串
 */
+(NSString*)trim:(NSString*)string;

@end
