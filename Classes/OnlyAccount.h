//
//  OnlyAccount.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OnlyAccount : NSObject 
{
	NSString *account;		//用户名
	NSString *realName;		//真实姓名
	NSString *password;		//密码
    NSString * gender;        //性别
    NSString * leavelStr;      //会员级别
}

@property(nonatomic,copy) NSString *account;
@property(nonatomic,copy) NSString *realName;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *gender;
@property(nonatomic,copy) NSString * leavelStr;
+(id) defaultAccount;


@end
