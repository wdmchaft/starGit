//
//  NewRegisterVC.h
//  ShangPin
//
//  Created by 唐彬琪 on 11-7-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString * const LoginSuccess;
@interface RegisterViewController : UIViewController <UITextFieldDelegate> {
    UITextField *emailTF;					//邮箱地址
	UITextField *setPasswordTF;				//设置密码
    UITextField *mobileTF;                  //手机号码
    UISegmentedControl * sexSegmentedCtl;             //性别选择
    BOOL  doSelectSex;                                                 //是否已经选择性别   TURE 已经选择     FALSE 未选择
    //BOOL conformClause;						//TRUE 遵守条款, FALSE 不遵守条款
    
    NSInteger genderValue;							//1 男, 0 女, -1未选择
	BOOL remoteNotification;				//TRUE 注册远程通知 FALSE 不注册远程通知
	UIImageView *clauseImgV;				//条款    复选框
	BOOL conformClause;						//TRUE 遵守条款, FALSE 不遵守条款
	
	//UIImageView *soldNoticeImgV;			//售卖通知 复选框
	BOOL soldNotice;						//TRUE 接收通知, FALSE 拒绝通知
	
	UIView *clauseView;						//条款视图

    
    
    NSMutableData *receivedData;			//接口返回的数据
	LoadingView *loadingView;				//等待界面

    
    NSURLConnection *registerConnection;	//注册链接
	NSURLConnection *loginConnection;		//登录 链接
	NSURLConnection *myAccountConnection;	//我的账户信息 链接
	
	
	int maxConnectionCount;					//登录的最大次数限制

}
@property(nonatomic, retain) UITextField *emailTF;
@property(nonatomic, retain) NSMutableData *receivedData;



+(RegisterViewController *) defaultRegisterViewController;

-(void) doLogin;

//-(void)ChangeSegmentFont:(UIView *)aView;
@end
