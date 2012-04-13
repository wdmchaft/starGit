//
//  Register.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 这册界面 视图控制器
 */

#import <UIKit/UIKit.h>


@interface RegisterViewController0 : UIViewController <UITextFieldDelegate>
{
	UITextField *emailTF;					//邮箱地址
	UITextField *setPasswordTF;				//设置密码
	UITextField *commitPasswordTF;			//确认密码
	UITextField *realNameTF;				//真实姓名
	UITextField *mobileTF;					//手机号码
	
	UIImageView *maleSelectedImgV;			//性别 男
	UIImageView *femaleSelectedImgV;		//性别 女
	//UIImageView *defaultGenderImgV;			//默认性别 非男非女
	
	//int gender;								//0－男,1-女  -1－无性别
	BOOL isMale;							//TRUE 男, FALSE 女
	BOOL remoteNotification;				//TRUE 注册远程通知 FALSE 不注册远程通知
	UIImageView *clauseImgV;				//条款    复选框
	BOOL conformClause;						//TRUE 遵守条款, FALSE 不遵守条款
	
	UIImageView *soldNoticeImgV;			//售卖通知 复选框
	BOOL soldNotice;						//TRUE 接收通知, FALSE 拒绝通知
	
	UIView *clauseView;						//条款视图
	
	LoadingView *loadingView;				//等待界面
	NSMutableData *receivedData;			//接口返回的数据
	NSURLConnection *registerConnection;	//注册链接
	NSURLConnection *loginConnection;		//登录 链接
	NSURLConnection *myAccountConnection;	//我的账户信息 链接
	
	
	int maxConnectionCount;					//登录的最大次数限制
}

@property(nonatomic, retain) UITextField *emailTF;
@property(nonatomic, retain) NSMutableData *receivedData;

+(RegisterViewController0 *) defaultRegisterViewController;
-(void) doLogin;

@end
