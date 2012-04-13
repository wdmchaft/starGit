//
//  Record.h
//  ShangPin
//
//  Created by apple_cyy on 11-3-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 邀请记录 数据模型
 
 每条邀请记录都包含2部分内容
 1、邀请时间（好友正式成为尚品会员的时间）
 2、好友联系方式
 */

#import <Foundation/Foundation.h>


@interface Record : NSObject 
{
	NSString *time;				//邀请时间
	NSString *contactway;		//好友联系方式
}

@property(nonatomic,copy) NSString *time;
@property(nonatomic,copy) NSString *contactway;

@end
