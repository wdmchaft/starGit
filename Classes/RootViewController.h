//
//  RootViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 根视图控制器
 */

#import <UIKit/UIKit.h>
#import "LogInViewController.h"
#import "CustomTabBar.h"
#import "MyAccountViewController.h"
#import "OnsaleDetailViewController.h"

extern NSString * const StopTimerNotification;
@interface RootViewController : UIViewController <UIAlertViewDelegate,LoginDelegate,CustomTabBarDelegate,changeMyAccountImag>
{
	CustomTabBar *tabBarC;		                //底部的tabBarController;
	int seletedTab;						        //选中的tab;
    LoadingView *loadingView;					//等待界面
    NSURLConnection *checkUpgradConnection;     //检查更新接口
    NSMutableData *receivedData;				//接口返回的数据
    NSArray * versionInfoArray;                 //版本信息
    MyAccountViewController * myAccountVC;
    OnsaleDetailViewController * onsaleDetailVC;
}

@property(nonatomic ,retain) UIImageView * selectedView;
@property(nonatomic ,retain) CustomTabBar * tabBarC;
@property(nonatomic ,retain) MyAccountViewController * myAccountVC;
@property(nonatomic ,retain) NSMutableData * receivedData;

- (void)tabBarDidSelectViewController:(UIViewController *)viewController;
- (void)CheckForUpgrade;                                                            //检查更新
- (void)deterMineVersion;                                                           //判断是否需要升级
- (BOOL)CompareNewStr:(NSString *)newStr OldStr:(NSString *)OldStr;                 //判断版本号高低
@end
