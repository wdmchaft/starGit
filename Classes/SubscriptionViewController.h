//
//  SubscriptionViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 尚品订阅 视图控制器
 */

#import <UIKit/UIKit.h>

@class CustomLabel;

@interface SubscriptionViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
	CustomLabel *emailLabel;			//邮箱
	int emailType;						//邮件接收频率
	UILabel *mobileLabel;				//手机号
	int mobileType;						//短信接收频率

	UITableView *m_tableView;			//通知方式
	NSArray *noticeTimeArray;			//通知频率
	
	int m_valueArray[2];				//存储对号对应的indexpath
	
	LoadingView *loadingView;					//等待界面
	NSURLConnection *subscribeConnection;		//获得我的订阅信息的 链接
	NSURLConnection *subscribeSaveConnection;	//保存我的订阅信息的 链接
	NSMutableData *receivedData;				//接口返回的数据
}

@property(nonatomic,retain) NSMutableData *receivedData;

-(void) getSubscribeInfo;

@end
