//
//  InviteRecord.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 邀请记录  视图
 对应界面:我的账户->邀请记录
 */

@protocol InviteRecordDelegate

-(void) didInviteRecordFinishLaunching;

@end

#import <UIKit/UIKit.h>


@interface InviteRecord : UIView <UITableViewDelegate,UITableViewDataSource>
{
	id<InviteRecordDelegate>inviteRecordDelegate;	//邀请记录 代理
	
	NSURLConnection *inviteConnection;		//获得邀请记录的 链接
	NSMutableArray *recordArray;			//邀请记录 存放于本数组中
	UITableView *m_tableView;				//邀请记录 在此控件中显示
	NSMutableData *receivedData;			//数据接收
	LoadingView *loadingView;				//等待界面
}

@property(nonatomic,assign) id<InviteRecordDelegate>inviteRecordDelegate;

@property(nonatomic,retain) NSMutableArray *recordArray;
@property(nonatomic,retain) NSMutableData *receivedData;


-(void) loadInviteRecord;

@end
