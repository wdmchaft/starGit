//
//  InviteViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 邀请 视图控制器
 */

@protocol inviteDelegate

@optional

//-(void) didFinishChoosePhoneNumber:(NSString *)thePhoneNumber;
-(void) didFinishChoosePhoneNumberInvite:(NSArray *)thePhoneName;
-(void) hideMobileLabel;

@end


#import <UIKit/UIKit.h>

@interface InviteViewController : UIViewController <UITextFieldDelegate,inviteDelegate,UITextViewDelegate>
{
	id<inviteDelegate> delegate;		//代理方法，处理手机号码选择
	
	NSString *theNumbers;				//选择的全部电话号码
    NSString *theNames;                  //选择的全部好友名字
    NSString * numbersStr;              //选择电话号码记录
    
    UIScrollView *inviteView;            //界面的滑动背景
	UITextView *mobileTF;				//好友手机号码列表
	UITextView *emailTF;				//好友email列表
	UITextView *contentTV;				//邀请内容
    
    UILabel * emailPromptLabel;          //提示用户用逗号隔开邮箱名
    UILabel * moilePromptLabel;          //提示用户用逗号隔开手机号码
	
	UITextField *codeTF;				//邀请码
	UITextView *linkTV;					//邀请链接
	
	NSURLConnection *inviteInfoConnection;			//获取邀请码和邀请链接
	
	LoadingView *loadingView;			//等待界面
	NSURLConnection *inviteWithSMSConnection;		//短信邀请
	NSURLConnection *inviteWithEmailConnection;		//邮件邀请
	NSMutableData *receivedData;		//接口返回的数据
	
	BOOL clearContent;						//清除发送内容
}

@property(nonatomic,assign) id<inviteDelegate> delegate;
@property(nonatomic,copy) NSString *theNumbers;
@property(nonatomic,copy) NSString *theNames;
@property(nonatomic,retain) NSMutableData *receivedData;
@property(nonatomic,retain) UILabel * emailPromptLabel;
@property(nonatomic,retain) UILabel * moilePromptLabel;

-(void) showInviteView;

@end
