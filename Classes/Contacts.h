//
//  Contacts.h
//  MessageSend
//
//  通讯录类
//  Created by BB-JiaFei by on 11-2-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 通讯录 数据模型
 
 包含用户名以及手机号码列表2部分
 */

#import <UIKit/UIKit.h>


@interface Contacts : UIViewController 
{
	NSString *contactName;					//用户姓名
	NSMutableArray *contactPhoneArray;		//手机号码列表
	//NSMutableArray *contactMailArray;
}

@property (nonatomic, retain) NSString *contactName;
@property (nonatomic, retain) NSMutableArray *contactPhoneArray;
//@property (nonatomic, retain) NSMutableArray *contactMailArray;

@end
