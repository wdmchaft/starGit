//
//  Message.h
//  ShangPin
//
//  Created by apple_cyy on 11-3-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 我的留言 数据模型
 
 每条留言都包含3部分内容
 1、留言时间
 2、我的留言内容
 3、尚品回复内容
 */

#import <Foundation/Foundation.h>


@interface Message : NSObject 
{
	NSString *Date;			//留言时间
	NSString *message;		//我的留言内容
	NSString *reply;		//尚品回复内容
}

@property(nonatomic, copy) NSString *Date;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, copy) NSString *reply;

@end
