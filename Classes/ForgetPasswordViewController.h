//
//  ForgetPasswordViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 找回密码 视图控制器
 */

#import <UIKit/UIKit.h>


@interface ForgetPasswordViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate>
{
	UITextField *emailTF;						//找回密码时输入的邮箱
	LoadingView *loadingView;					//等待界面
	NSURLConnection *getPasswordConnection;		//登录 链接
	NSMutableData *receivedData;				//接口返回的数据
}

@property(nonatomic, retain) NSMutableData *receivedData;

@end
