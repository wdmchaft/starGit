//
//  MyAccountViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 我的账户 视图控制器
 */

#import <UIKit/UIKit.h>
#import "UserInfoViewController.h"
#import "MyOrderViewController.h"    //我的订单控制器
#import "VoucherView.h"						//代金券
#import "MessageBoardView.h"				//留言板
#import "InviteRecord.h"					//邀请记录
#import "MyOrderDetailViewController.h"		//订单详情 视图控制器
#import "LogInViewController.h"	
#import "MyKeepListViewController.h"


@class MyAlertViewController;			//我的提醒 视图控制器
@class SubscriptionViewController;		//尚品订阅 视图控制器
//@class LogInViewController;

extern NSString * const logOutNotification;
extern NSString * const renewSuggestStr;

@interface MyAccountViewController : UIViewController 
<UIAlertViewDelegate,UIActionSheetDelegate,MyAcountLoginDelegate,getEmail,UITableViewDataSource,UITableViewDelegate>
{
	UIImageView *headPhotoImgV;					//会员头像
	UILabel *userNameLabel;						//会员姓名
    NSString *userSexStr;                       //性别
    UILabel *userEmailLable;                   //用户邮箱
	UIImageView *VIPImgV;						//会员等级
    UILabel * userLevel;                           //会员等级
    
    UITableView * functionTableView;                  //功能表格
    NSArray * functionAarray;                               //功能表格数组
	
	NSMutableArray *addressArray;				//收货人地址（可能有多个地址）
	NSURLConnection *getAddressConnection;		//获取收货地址的 链接
	NSURLConnection *myAccountConnection;		//我的账户 链接
	LoadingView *loadingView;					//等待界面
	NSMutableData *receivedData;				//数据接收
	
    UserInfoViewController * userInfoVC;
    MyOrderViewController * myOrderVC;                 //我的订单 视图控制器
	MyAlertViewController *myAlertVC;				        //我的提醒 视图控制器
	SubscriptionViewController *subscriptionVC;		//尚品订阅 视图控制器
    MyKeepListViewController * myKeepListVC;        //我的收藏 视图控制器
    
	
	MyOrderDetailViewController *orderDetailVC;		//订单详情 视图控制器
	
	NSMutableArray *provinceArray;					//所有省份的键值
	NSMutableArray *cityArray;						//所有城市的键值
	NSMutableArray *areaArray;						//所有地区的键值
    int  postNum;                          //判断是否重复发送  “进入收藏”的通知
}

@property(nonatomic,retain) NSMutableData *receivedData;
@property(nonatomic,retain) NSMutableArray *addressArray;
@property(nonatomic,retain) NSMutableArray *provinceArray;
@property(nonatomic,retain) UITableView * functionTableView;
@property(nonatomic,retain) NSMutableArray *cityArray;
@property(nonatomic,retain) NSMutableArray *areaArray;



-(void) showMyAlert;
-(void) showMyInfo;
-(void) getAddressInfo;
-(void) showAddress;
-(void) postLogoutNotice;
-(void) doEditPassWord;
@end
