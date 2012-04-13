//
//  LimitBuyDetailViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 商品详情
 
 具体商品的详细信息
 */

#import <UIKit/UIKit.h>
#import "TouchImagView.h"
#import "SimilarProductImageView.h"

@protocol comeKeep 

-(void)comeKeep;

@end

@protocol changeMyAccountImag <NSObject>

-(void)changeMyAccountImagNum:(NSInteger)sender;

@end

@interface OnsaleDetailViewController : UIViewController 
<UIPickerViewDelegate, UIPickerViewDataSource,UIScrollViewDelegate,TouchImagViewDelegate,SimilarProductDelegate,UIAlertViewDelegate>
{
	BOOL canBuy;							// 能够购买
	
	NSString *proNO;						//产品编号
	NSString *catNO;						//种类编号
    NSString *catPrice;                    //商品价格
	
	UIPickerView *propPicker;				//属性选择
	UIView *blackView;						//picker后面的view
	
	NSMutableArray *nameArray;				//属性名称
	NSMutableArray *valueArray;				//属性对应值(下订单需要)
	NSMutableArray *skuArray;				//存放各个单品的数组
	
	UILabel *titleLabel;					//标题
	UILabel *shoppePriceLabel;				//专柜价
	UILabel *lineThrough;					//贯穿线
	UILabel *VIPLabel;						//限时价
	UILabel *colorLabel;					//属性1名称
	UILabel *sizeLabel;						//属性2名称
	UITextField *colTextfield;				//属性1的值
	UIButton *colorButton;					//属性1选择别款
	UITextField *sizeTextfield;				//属性2的值
	UIButton *sizeButton;					//属性2选择别款
	UILabel *quantityLabel;					//剩余量
	
	NSString *skuNo;						//单品编号
	UIButton *buyButton;					//购买按钮
    UIButton * addKeepButton;          //添加收藏按钮
	
	UIPageControl *pageControl;				//图片上方圆点
	UIScrollView *scrollVC;					//滑动视图
	UIView *backView;						//半透明的view
	UIImageView *bigImgV;					//大图
	UIScrollView *bigScrollV;				//放大图的scroll
	UIPageControl *bigPageControl;			//大图下面的圆点
	
	
	NSArray *smallImageArray;				//小图片数组
	NSArray *bigImageArray;					//大图片数组
	
	UIScrollView *otherProductScroll;		//同类产品
	
	LoadingView *loadingView;					//等待界面
	NSURLConnection *detailConnection;			//详情 链接
	NSMutableData *receivedData;				//接口返回的数据
	NSURLConnection *similarConnection;			//同类产品 链接
	
	NSURLConnection *buyProductConnection;		//购买产品 链接
    NSURLConnection *addKeepConnection;           //加入收藏 链接
	NSMutableArray *receiverArray;				//收货人地址数组
	NSString *voucherUrlStr;					//可用代金券请求地址，订单确认界面要用
	
	NSMutableArray *similarArray;				//同类产品的数组
	
	NSString *intro;						//商品详情的内容
	UIWebView *detailInfoWebview;			//商品详情 显示
    id<comeKeep>comKeepDelegate;      //进入我的收藏代理
    id<changeMyAccountImag>changeImagDelegate;       //改变 加入收藏后 产看“我的收藏”时候，我的尚品tabbaritem的图片更改
}

@property (nonatomic,copy) NSString *skuNo;
@property (nonatomic,copy) NSString *proNO;
@property (nonatomic,copy) NSString *catNO;

@property (nonatomic,retain) NSMutableArray *nameArray, *valueArray;
@property (nonatomic,retain) NSMutableArray *skuArray;
@property (nonatomic,retain) NSMutableData *receivedData;
@property (nonatomic,copy) NSString *intro;

@property (nonatomic,retain) NSArray *smallImageArray;
@property (nonatomic,retain) NSArray *bigImageArray;


@property (nonatomic,retain) NSMutableArray *similarArray;
@property (nonatomic,retain) NSMutableArray *receiverArray;
@property (nonatomic,copy) NSString *voucherUrlStr;
@property (nonatomic,assign)id<comeKeep>comKeepDelegate;
@property (nonatomic,assign) id<changeMyAccountImag>changeImagDelegate;

-(void) detailInfo:(NSString *)theProductID catID:(NSString *)catID;
-(void) similarProductlistWithCatNo:(NSString *)theCatNo andProductNo:(NSString *)theProductNo;

- (void)comeKeep;             //注册通知
- (void)hideKeepButton;

@end
