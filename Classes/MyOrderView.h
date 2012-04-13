//
//  MyOrderView.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 我的订单 视图
 对应界面:我的账户->我的订单
 */

#import <UIKit/UIKit.h>
#import "MyOrderDetailViewController.h"

@protocol MyOrderDelegate

-(void) showDetailOrder:(NSString *) orderId;
//-(void) didOrderViewFinishLaunching;

@end



@interface MyOrderView : UITableView <UITableViewDelegate,UITableViewDataSource>
{
	id<MyOrderDelegate> orderDelegate;						//我的订单代理，用于触发进入详情
    
   
	
	NSURLConnection *myOrderListConnection;					//获取订单列表的 链接
	NSMutableArray *orderArray;								//订单列表 存放于本数组中
	LoadingView *loadingView;								//等待界面
	NSMutableData *receivedData;							//数据接收
}
@property(nonatomic,retain) NSMutableData *receivedData;
@property(nonatomic,retain) NSMutableArray *orderArray;;
@property(nonatomic,assign) id<MyOrderDelegate> orderDelegate;

-(void) loadMyOrder;

@end
