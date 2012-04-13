//
//  AddressListViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-3-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 地址列表 视图控制器
 用于显示 地址列表
 对应界面:我的账户->收货地址列表
 */

#import <UIKit/UIKit.h>
@class ConsigneeInfoViewController;

@interface AddressListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
	ConsigneeInfoViewController *CIVC;		//购买-收货人地址
	UITableView *m_tableView;				//地址列表 显示于本控件中
	NSMutableArray *addressArray;			//地址列表数据
}

@property(nonatomic,retain) NSMutableArray *addressArray;
@property(nonatomic,retain) ConsigneeInfoViewController *CIVC;


-(void) showList;

@end
