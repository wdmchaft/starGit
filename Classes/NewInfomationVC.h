//
//  NewInfomationVC.h
//  ShangPin
//
//  Created by 唐彬琪 on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogInViewController.h"
#import "NewsTextView.h"
#import "BlogDetailViewController.h"
#import "TouchImagView.h"

@class MyPageControl,OnsaleListViewController;
@interface NewInfomationVC : UIViewController <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,TouchImagViewDelegate> {
    UIScrollView * mainView;                    //主滑动视图
    UIScrollView * scrollImage;                //滑动滑动图片展示
    //TouchImagView * showSellActView;           //可点击的滑动图片视图
    MyPageControl * pageControl;               //自定义的pageControl
    UITableView * NewsTableView;               //资讯标题列表
    //NSMutableArray * cellMutableArray;
    NewsTextView * textViewVC;                    //资讯文字内容视图,点击资讯列表进入该VC界面
    BlogDetailViewController * blogVC;            //新资讯界面，文字标题加webview显示
    OnsaleListViewController * onsaleListVC;      //进入售卖列表
    
    NSTimer * showTime;                         //图片自动滑动定时器
    
    LoadingView *loadingView;					//等待界面
    
    NSURLConnection * superActConnection;       //特价活动链接
    NSMutableArray * superActArray;             //特价活动列表数组
    
    NSURLConnection *infoConnection;			//资讯链接
    NSMutableArray *blogArray;					//博客列表信息
    LogInViewController *loginVC;				//注册    视图控制器
    
    NSMutableData *receivedData;				//接口返回的数据
	

}
@property (nonatomic ,retain) NSMutableData *receivedData;
@property (nonatomic ,retain) NSMutableArray *blogArray;
@property (nonatomic ,retain) NSMutableArray *superActArray;
@property (nonatomic ,retain) NSTimer * showTime;
@property (nonatomic ,retain) UITableView * NewsTableView;



-(void) doRegister:(int)index;
-(void)initTimer;
-(void)stopTimer;
@end
