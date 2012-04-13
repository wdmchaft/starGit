//
//  VoucherView.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 代金券 视图
 对应界面:我的账户->代金券
 */

@protocol VoucherViewDelegate

-(void) didVoucherViewFinishLaunching;

@end


#import <UIKit/UIKit.h>


@interface VoucherView : UIView <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
	id<VoucherViewDelegate> voucherDelegate;		//代金券代理
	
	UITextField *rechargeTF;						//代金券充值码 输入框
	
	NSURLConnection *activateConnection;			//激活代金券的 链接
	NSURLConnection *voucherConnection;				//获得代金券列表的 链接
	UITableView *m_tableView;						//代金券列表 显示于此控件中
	NSMutableArray *voucherArray;					//代金券数据 存放于此数组中
	LoadingView *loadingView;						//等待界面
	NSMutableData *receivedData;					//数据接收
}

@property(nonatomic, assign) id<VoucherViewDelegate> voucherDelegate;
@property(nonatomic, retain) UITextField *rechargeTF;

@property(nonatomic, retain) NSMutableArray *voucherArray;
@property(nonatomic, retain) NSMutableData *receivedData;


-(void) loadVoucher;

@end
