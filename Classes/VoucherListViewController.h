//
//  VoucherListViewController.h
//  ShangPin
//
//  Created by cyy on 11-3-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 购买某商品,可用代金券列表
 */

@protocol VoucherListVCDelegate
@optional

-(void)didSaveVoucher:(NSString *)theVoucher;

@end


#import <UIKit/UIKit.h>


@interface VoucherListViewController : UIViewController <UIAlertViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,VoucherListVCDelegate>
{
	id<VoucherListVCDelegate> delegate;
	
	UITextField *voucherTextField;					//代金券充值
	UITableView *voucherListTB;						//代金券列表
	NSString *voucherUrlStr;						//可用代金券请求地址
	NSMutableArray *voucherArray;					//可用代金券列表
	NSMutableArray *voucherCodeArray;				//代金券编码
	NSMutableArray *voucherStartDate;				//代金券开始时间
	NSMutableArray *voucherEndDate;					//代金券截止时间
	
	NSString *voucher;				//代金券面值
	
	int selectVoucher;							//选中的代金券
	
	LoadingView *loadingView;					//等待界面
	NSURLConnection *voucherListConnection;		//代金券列表 链接
	NSURLConnection *activationConnection;		//代金券激活
	NSMutableData *receivedData;				//接口返回的数据
	
}

@property(nonatomic,assign) id<VoucherListVCDelegate> delegate;
@property(nonatomic,retain) NSMutableData *receivedData;
@property(nonatomic,copy) NSString *voucherUrlStr;
@property(nonatomic,retain) NSMutableArray *voucherArray,*voucherCodeArray,*voucherEndDate,*voucherStartDate;
@property(nonatomic,copy)  NSString *voucher;

-(void) voucherListConnection;

@end
