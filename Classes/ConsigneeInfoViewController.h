//
//  ConsigneeInfoViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 收货人信息 视图控制器
 
 商品详情页面点购买进入
 */

@protocol ConsigneeVCDelegate		//修改收货地址 省市县

-(void) didFinishChooseAddressWithArray:(NSArray *)infoArray;

@end

#import <UIKit/UIKit.h>
@class Receiver;

@interface ConsigneeInfoViewController : UIViewController <UITextFieldDelegate,ConsigneeVCDelegate>
{
	id<ConsigneeVCDelegate> delegate;		//购买-收货地址代理
	
	NSMutableArray *receiverArray;			// 收货人地址数组，值从上个界面传过来
	NSString *voucherUrlStr;				//可用代金券请求，上个界面传过来的，下个界面要用。
	
	UITextField *receiverTF;				//收货人姓名
	UILabel *cityLabel;						//省市县
	UITextField *addressTF;					//收获详细地址
	UITextField *postCodeTF;				//邮编
	UITextField *mobileTF;					//手机号码
	UITextField *phoneTF;					//电话号码
	Receiver *defaultReceiver;				//默认收获信息
	
	NSString *consigneeid;						//收货地址编号
	NSString *provinceid;							//省份
	NSString *cityid;								//城市
	NSString *areaid;								//地区
	NSString *proNO;							//购买的产品的id
}

@property(nonatomic,assign) id<ConsigneeVCDelegate> delegate;
@property(nonatomic,retain) NSMutableArray *receiverArray;
@property(nonatomic,retain) NSString *voucherUrlStr;
@property(nonatomic,retain) Receiver *defaultReceiver;
@property(nonatomic,copy) NSString *consigneeid;
@property(nonatomic,copy) NSString *provinceid;
@property(nonatomic,copy) NSString *cityid;
@property(nonatomic,copy) NSString *areaid;

@property(nonatomic,copy) NSString *proNO;

-(void) defaultReceiverInfo;
-(void) changeToChoosedReceiver:(Receiver *)receiver;

@end
