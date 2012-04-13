//
//  UserInfoViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 个人信息 视图控制器
 对应界面:我的账户->个人信息
 */

#import <UIKit/UIKit.h>
@class CustomLabel;								//自定义Label,添加了垂直对齐属性

@protocol getEmail 

- (void)setUserEmail:(NSString *)emailStr;

@end


@interface UserInfoViewController : UIViewController 
{
	id<getEmail>getEmailDelegate;             //获取用户email的代理
    CustomLabel *realNameLabel;							//真实姓名
	CustomLabel *mobileLabel;							//手机号码
    CustomLabel *sexLabel;                              //性别 
    CustomLabel *telephone;                             //固话
	CustomLabel *emailLabel;						//电子邮箱
    NSString  * _emailStr;                               //电子邮箱字符串
	CustomLabel *cityLabel;							//省市县地址
	CustomLabel *addressLabel;						//具体地址
	UILabel *postcodeLabel;							//邮政编码
	
	NSURLConnection *myInfoConnection;				//获取我的信息的 链接
	LoadingView *loadingView;						//等待界面
	NSMutableData *receivedData;					//数据接收
	
	NSMutableArray *provinceArray;					//所有省份的键值
	NSMutableArray *cityArray;						//所有城市的键值
	NSMutableArray *areaArray;						//所有地区的键值
}

@property(nonatomic, assign)	id<getEmail>getEmailDelegate;
@property(nonatomic, retain) NSMutableData *receivedData;
@property(nonatomic, retain) NSMutableArray *provinceArray;
@property(nonatomic, retain) NSMutableArray *cityArray;
@property(nonatomic, retain) NSMutableArray *areaArray;
@property(nonatomic, retain) UILabel * sexLabel;

-(void) loadmyInfo;

@end
