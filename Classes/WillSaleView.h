//
//  WillSaleView0.h
//  ShangPin
//
//  Created by 唐彬琪 on 11-8-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//


/*
 即将出售 视图
 
 对应界面 正在出售－即将出售
 */

#import <UIKit/UIKit.h>

@class Willsale;

@protocol WillsaleDelegate		//代理方法  告诉好友

-(void) doTellFriendWillSale:(Willsale *)willsale;

@end


@interface WillSaleView : UITableView <UITableViewDelegate,UITableViewDataSource> 
{
	id<WillsaleDelegate> willsaleDelegate;		//代理方法
	NSMutableArray *willSaleArray;				//UITableView的数据源
	
	LoadingView *loadingView;					//等待界面
	NSURLConnection *myPromptSaveConnection;	//保存我的提醒的 链接
	NSMutableData *receivedData;				//接口返回的数据
}

@property(nonatomic,assign) id<WillsaleDelegate> willsaleDelegate;
@property(nonatomic,retain) NSMutableArray *willSaleArray;
@property(nonatomic,retain) NSMutableData *receivedData;

@end
