//
//  LimitBuyGroomFriendsViewController.h
//  ShangPin
//
//  Created by ch_int_beam on 11-2-20.
//  Copyright 2011 Beyond. All rights reserved.
//

/*
 推荐给好友 视图控制器
 
 有具体商品界面进入
 */

@protocol OnsaleGroomFriendDelegate		//代理   处理通讯录选择号码

@optional

//-(void) didFinishChoosePhoneNumber:(NSString *)thePhoneNumber;
-(void) didFinishChoosePhoneNumberInvite:(NSArray *)thePhoneName;


@end


#import <UIKit/UIKit.h>


@interface OnsaleGroomFriendsViewController : UIViewController <UITextFieldDelegate,OnsaleGroomFriendDelegate,UITextViewDelegate>
{
	id<OnsaleGroomFriendDelegate> delegate;
	UIImageView *imageView;				//被推荐的商品的图片
	UILabel *titleLabel;				//标题
	UILabel *shoppePriceLabel;			//专柜价
	UILabel *lineThrough;				//贯穿线
	UILabel *VIPLabel;					//限时价
	
	UITextField *note;					//电话号码
	UITextField *mail;					//邮箱
	UITextView *remark;					//内容
	
	NSArray *infoArray;					//推荐产品的信息
	NSString *theNumbers;				//选择的全部电话号码
    NSString * theNames;                //选择的全部好友姓名
	
	LoadingView *loadingView;				//等待界面
	NSURLConnection *recfSMSConnection;		//短信推荐
	NSURLConnection *recfEmailConnection;	//邮件推荐
	NSMutableData *receivedData;			//接口返回的数据
	
	BOOL clearContent;						//清除发送内容
}

@property(nonatomic,assign) id<OnsaleGroomFriendDelegate> delegate;
@property(nonatomic,retain) NSArray *infoArray;
@property(nonatomic,copy) NSString *theNumbers;
@property(nonatomic,copy) NSString *theNames;
@property(nonatomic,retain) NSMutableData *receivedData;

-(void) showInfoWithArray:(NSArray *)theInfoArray;

@end
