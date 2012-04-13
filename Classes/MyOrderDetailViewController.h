//
//  MyOrderDetailViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 订单详情  视图控制器
 对应界面:我的账户->我的订单->订单详情
 */

@protocol MyOrderDetailDelegate

-(void) finishCancelOrder;			//取消订单之后刷新订单列表

@end



#import <UIKit/UIKit.h>
@class CustomLabel;

@interface MyOrderDetailViewController : UIViewController <UIAlertViewDelegate>
{
	NSString *orderID;						//订单号
	id<MyOrderDetailDelegate> delegate;		//订单详情代理,用于处理取消订单之后刷新订单列表
	
	UILabel *totalLabel;					//总金额
	UILabel *voucherMoneyLabel;				//"代金券"三个字
	UILabel *voucherLabel;					//代金券
	UILabel *payLabel;						//支付状态
	UILabel *orderLabel;					//订单状态
	
	BOOL useVoucher;						//TRUE-使用了代金券  FALSE-未使用代金券
	UIButton *cancelButton;					//取消订单
	
	UIScrollView *addressScroll;			//收货详情
	UILabel *personLabel;					//收货人
	CustomLabel *addressLabel;				//收货地址
	UILabel *postcodeLabel;					//邮政编码
	UILabel *phoneLabel;					//联系电话
	UILabel *deliverymethodLabel;			//配送方式
	UILabel *payMothedLabel;				//支付方式
	CustomLabel *memoLabel;					//备注
	CustomLabel *timeLabel;					//收货时间
	
	NSURLConnection *cancelConnection;		//取消订单的链接
	NSURLConnection *detailConnection;		//获取订单详情的 链接
	LoadingView *loadingView;				//等待界面
	NSMutableData *receivedData;			//数据接收
}

@property(nonatomic, assign) id<MyOrderDetailDelegate> delegate;
@property(nonatomic, retain) NSMutableData *receivedData;
@property(nonatomic, copy) NSString *orderID;

-(void) loadOrderDetail:(NSString *) orderId;

@end
