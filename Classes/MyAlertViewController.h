//
//  MyAlertViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 我的提醒 视图控制器
 */

#import <UIKit/UIKit.h>


@interface MyAlertViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
	UITableView *m_tableView;					//提醒列表
	NSMutableArray *promptArray;				//我的全部提醒存放于本数组中
	
	LoadingView *loadingView;					//等待界面
	NSURLConnection *myPromptConnection;		//获得我的提醒的 链接
	NSURLConnection *myPromptSaveConnection;	//保存我的提醒的 链接
	NSMutableData *receivedData;				//接口返回的数据
	
	NSString *subjectNos;						//设置提醒的id
	NSString *flags;							//提醒状态
}

@property(nonatomic,retain) NSMutableData *receivedData;
@property(nonatomic,retain) NSMutableArray *promptArray;
@property(nonatomic,copy) NSString *subjectNos;
@property(nonatomic,copy) NSString *flags;


-(void) getMyPromptList;

@end
