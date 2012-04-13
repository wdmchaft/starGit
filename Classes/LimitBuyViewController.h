//
//  LimitBuyViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 限时购 视图控制器
 */

#import <UIKit/UIKit.h>
#import "OnsaleView.h"
#import "WillSaleView.h"
#import "CalenderView.h"

@class OnsaleListViewController;

@interface LimitBuyViewController : UIViewController <OnsaleDelegate>
{
	OnsaleView *onsaleView;						//正在出售视图
	WillSaleView *willsaleView;					//即将出售视图
	CalenderView *calenderView;					//预售日历视图
	
    UISegmentedControl *segControl;           
    
    NSString * gender;                                 //性别
    
	LoadingView *loadingView;					//等待界面
	NSURLConnection *onSaleConnection;			//正在出售 链接
	NSURLConnection *willSaleConnection;		//即将出售 链接
	NSURLConnection *calenderConnection;		//预售日历 链接
	NSMutableData *receivedData;				//接口返回的数据
	
	OnsaleListViewController *onsaleListVC;		//尚品列表 视图控制器
	
	NSMutableArray *calenderArray;				//日历数据
}

@property(nonatomic,retain) NSMutableData *receivedData;
@property(nonatomic,retain) NSMutableArray *calenderArray;


//- (void)readGender;
-(void) doChangeMode:(UISegmentedControl *) sender;

@end
