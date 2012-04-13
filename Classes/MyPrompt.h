//
//  MyPrompt.h
//  ShangPin
//
//  Created by cyy on 11-3-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 我的提醒 数据模型
 包括5部分内容组成
 1、提醒的id
 2、提醒的日期
 3、提醒的状态
 4、活动的图片
 5、活动名称
 */

#import <Foundation/Foundation.h>


@interface MyPrompt : NSObject 
{
	NSString *promptID;		//提醒的id
	NSString *date;			//提醒的日期
	NSString *push;			//提醒的状态
	NSString *img;			//活动的图片
	NSString *name;			//活动名称
}

@property(nonatomic,copy) NSString *promptID;
@property(nonatomic,copy) NSString *date;
@property(nonatomic,copy) NSString *push;
@property(nonatomic,copy) NSString *img;
@property(nonatomic,copy) NSString *name;

@end
