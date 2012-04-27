//
//  LogInViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 登录界面 视图控制器
 */

#import <UIKit/UIKit.h>
#import "ForgetPasswordViewController.h"
#import "RegisterViewController.h"
//#import "MyAccountViewController.h"

@protocol LoginDelegate

- (void) didLoginSucess;

@end

@protocol MyAcountLoginDelegate 

- (void) loadMyAcountData;

@end

extern NSString * const StarTimerNotification;
@interface LogInViewController : UIViewController <UITextFieldDelegate>
{	
	id<LoginDelegate> delegate;							//登录成功的代理
    id<MyAcountLoginDelegate>MyAcountDelegate;          //登录后加载我的尚品数据代理
	UIScrollView * backGroundView;
    UITextField *userNameTF;							//用户名
	UITextField *passwordTF;							//密码
    
	BOOL haslogin;										//TRUE 已经登录   FALSE 还没登录
	
	BOOL remoteNotification;							//TRUE 注册远程通知 FALSE 不注册远程通知
	
	LoadingView *loadingView;							//等待界面
	NSURLConnection *loginConnection;					//登录 链接
	NSMutableData *receivedData;						//接口返回的数据
	
	NSURLConnection *myAccountConnection;				//我的账户信息 链接
	
	ForgetPasswordViewController *forgetPasswordVC;		//找回密码 视图控制器
	RegisterViewController *registerVC;					//注册    视图控制器
}

@property (nonatomic, assign) id<LoginDelegate> delegate;
@property (nonatomic, assign) id<MyAcountLoginDelegate> MyAcountDelegate;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) UITextField *userNameTF;
@property BOOL haslogin;

+(LogInViewController *)defaultLoginViewController;		//单例 初始化方法
-(void) readUserName;                    //读取保存的用户信息
-(void) doLogin;
@end
