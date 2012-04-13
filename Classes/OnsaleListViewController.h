//
//  LimitBuyListViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 某活动或者品牌 对应的产品列表 视图控制器
 */

#import <UIKit/UIKit.h>
#import "CustomImageView.h"

@class OnsaleDetailViewController;

@interface OnsaleListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,CustomImageViewDelegate>
{
	BOOL listMode;								//TRUE 列表模式, FALSE 九宫格
		
	UITableView *onSaleTableview;				//产品列表
	UIScrollView *imageScrollView;				//九宫格列表
	
	LoadingView *loadingView;					//等待界面
	NSURLConnection *onSaleListConnection;		//正在出售 链接
	NSMutableArray *onsaleCatalogArray;			//产品数据
	NSMutableData *receivedData;				//接口返回的数据
    OnsaleDetailViewController *buyDetailVC;  //产品详情
}

@property(nonatomic,retain) NSMutableArray *onsaleCatalogArray;	
@property(nonatomic,retain) NSMutableData *receivedData;

-(void) onsaleList:(NSString *)theID name:(NSString *)theName;
//正在出售会调用这个方法，显示指定的活动


@end
