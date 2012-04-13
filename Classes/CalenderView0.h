//
//  CalenderView.h
//  TestCalender
//
//  Created by cyy on 11-3-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 预售日历 视图
 
 对应界面 正在出售－预售日历
 */

#import <UIKit/UIKit.h>
@class Willsale;

@protocol CalenderDelegate		//代理方法 告诉好友

-(void) doTellFriendCalender:(Willsale *)willsale;

@end

@interface CalenderView0 : UIView <UITableViewDelegate,UITableViewDataSource>
{
	id<CalenderDelegate> calenderDelegate;		//告诉朋友

	NSMutableArray *calenderArray;
	
	UITableView *m_tableView;					//每天活动列表
	NSMutableArray *activityArray;				//活动列表
	
	LoadingView *loadingView;					//等待界面
	NSURLConnection *myPromptSaveConnection;	//保存我的提醒的 链接
	NSURLConnection *pcListConnection;			//获得某天预售列表的 请求
	NSMutableData *receivedData;				//接口返回的数据
}

@property (nonatomic, retain) id<CalenderDelegate> calenderDelegate;
@property (nonatomic, retain) NSMutableArray *calenderArray;
@property (nonatomic, retain) NSMutableArray *activityArray;
@property (nonatomic, retain) NSMutableData *receivedData;

- (id)initWithFrame:(CGRect)frame andArray:(NSMutableArray *)array;
//自定义初始化方法，传入了frame以及日历包含的天数


-(void) showFirstDayProductList;
//显示明天的所有活动
@end
