//
//  AddressViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 收货地址 视图控制器
 对应界面:我的账户->收货地址列表->收货地址
 */

@protocol AddressVCDelegate

-(void) didFinishChooseAddressArray:(NSArray *)infoArray;

@end



#import <UIKit/UIKit.h>

@class Address;

@interface AddressViewController : UIViewController <UITextFieldDelegate,AddressVCDelegate>
{
	id<AddressVCDelegate>delegate;				//我的账户-收货地址代理
	UIScrollView * addressView;            //可滚动的底层
    UITextField *receiverTF;					//收货人姓名
	UILabel *cityLabel;							//省市县
	UITextField *addressTF;						//地址
	UITextField *postCodeTF;					//邮编
	UITextField *phoneTF;						//电话号码
	UITextField *mobileTF;						//手机号码
    NSString * promptStr;                        //判断修改/添加
	
	NSURLConnection *saveAddressConnection;		//保存收货地址的 链接
	LoadingView *loadingView;					//等待界面
	NSMutableData *receivedData;				//数据接收
	NSString *consigneeid;						//收货地址编号
	NSString *provinceid;							//省份
	NSString *cityid;								//城市
	NSString *areaid;								//地区
	
}

@property(nonatomic,assign) id<AddressVCDelegate>delegate;
@property(nonatomic,retain) NSMutableData *receivedData;
@property(nonatomic,copy) NSString *consigneeid;
@property(nonatomic,copy) NSString *provinceid;
@property(nonatomic,copy) NSString *cityid;
@property(nonatomic,copy) NSString *areaid;
@property(nonatomic,copy) NSString * promptStr;

+(AddressViewController *)defaultAVC;
-(void) showDetailAddress:(Address *)theAddress;
-(void) showBlank;
-(void)changePrompt;

@end
