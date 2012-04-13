//
//  WillSaleView.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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


@interface WillSaleView0 : UITableView <UITableViewDelegate,UITableViewDataSource> 
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
