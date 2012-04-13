//
//  EditPasswordViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 修改密码 视图控制器
 对应界面:我的账户->个人信息->修改密码
 */

#import <UIKit/UIKit.h>


@interface EditPasswordViewController : UIViewController <UITextFieldDelegate>
{
	UITextField *originPasswordTF;			//原密码
	UITextField *newPasswordTF;				//新密码
	UITextField *commitPwdTF;				//确认密码
	
	NSURLConnection *editPwdConnection;		//获取我的信息的 链接
	LoadingView *loadingView;				//等待界面
	NSMutableData *receivedData;			//数据接收
}

@property(nonatomic,retain) NSMutableData *receivedData;

@end
