//
//  TellFriendViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


/*
 告诉朋友 视图控制器
 
 正在出售、即将出售、预售日历都能连接到本视图控制器
 */

#import <UIKit/UIKit.h>

@protocol tellFriendDelegate

@optional

//-(void) didFinishChoosePhoneNumber:(NSString *)thePhoneNumber;
-(void) didFinishChoosePhoneNumberInvite:(NSArray *)thePhoneName;


@end


@interface TellFriendViewController : UIViewController <UITextFieldDelegate,tellFriendDelegate,UITextViewDelegate>
{
	id<tellFriendDelegate> delegate;	//代理方法，处理手机号码选择
	UIImageView *imageView;				//品牌（活动）图片
	UITextField *mobilTF;				//好友电话
	UITextView *contentTV;				//内容
	
    NSString * numbersStr;              //选择电话号码记录
    
	NSString *subjectNo;				//活动编号
	NSString *subjectTheme;				//活动主题
	NSString *theNumbers;				//选择的全部电话号码
    NSString *theNames;                  //选择的全部好友名字
	
	LoadingView *loadingView;					//等待界面
	NSURLConnection *tellFriendConnection;		//告诉好友
	NSMutableData *receivedData;				//数据接收
	
	BOOL clearContent;						//清除发送内容
}

@property(nonatomic,retain) NSMutableData *receivedData;
@property(nonatomic,assign) id<tellFriendDelegate> delegate;
@property(nonatomic,copy) NSString *subjectNo,*subjectTheme;
@property(nonatomic,copy) NSString *theNumbers;
@property(nonatomic,copy) NSString *theNames;

+(TellFriendViewController *) getTellFriendInstanse;
-(void) showImageViewWithUrl:(NSString *)theUrl andId:(NSString *)theID andTheme:(NSString *)theTheme;
-(void)keyboardReturn;

@end
