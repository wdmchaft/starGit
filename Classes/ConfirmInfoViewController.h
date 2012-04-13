//
//  ConfirmInfoViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 确认订单 视图控制器
 
 由收货人信息界面 进入
 */


#import <UIKit/UIKit.h>
#import "VoucherListViewController.h"

@interface ConfirmInfoViewController : UIViewController <UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate,VoucherListVCDelegate>
{	
	int selectTime;					//选中的收货时间
	
	UITableView *confirmTableView;	//确认信息tableview
	UITextField *memoTF;			//备注
	
	NSString *voucherUrlStr;		//可用代金券请求地址
		
	LoadingView *loadingView;					//等待界面
	NSMutableData *receivedData;				//接口返回的数据
	NSURLConnection *submitConnect;				//提交订单链接
	
	
	VoucherListViewController *vlVC;
	
	//下订单需要的参数
	NSString *productNo;			//产品编号
	NSString *consigneeId;			//收货人地址id
	NSString *receiveName;			//收货人姓名
	NSString *proviceId;			//省份id
	NSString *cityId;				//城市id
	NSString *areaId;				//地区id
	NSString *address;				//详细地址
	NSString *postcode;				//邮政编码
	NSString *phone;				//固定电话
	NSString *mobile;				//手机号
	NSString *paymode;				//支付方式
	NSString *time;					//收货时间
	NSString *voucher;				//代金券面值
	NSString *memo;					//备注
}

@property(nonatomic,copy) NSString *voucherUrlStr;
@property(nonatomic,retain) NSMutableData *receivedData;

@property(nonatomic,copy) NSString *productNo;
@property(nonatomic,copy) NSString *consigneeId;
@property(nonatomic,copy) NSString *receiveName;
@property(nonatomic,copy) NSString *proviceId;
@property(nonatomic,copy) NSString *cityId;
@property(nonatomic,copy) NSString *areaId;
@property(nonatomic,copy) NSString *address;
@property(nonatomic,copy) NSString *postcode;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *mobile;
@property(nonatomic,copy) NSString *paymode;
@property(nonatomic,copy) NSString *time;
@property(nonatomic,copy) NSString *voucher;
@property(nonatomic,copy) NSString *memo;


@end
