//
//  ShangPinAppDelegate.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MobClick.h"
#import "TouchImageView_star.h"
@class RootViewController;

@interface ShangPinAppDelegate : NSObject <MobClickDelegate,TouchImageView_starDealegate,UIApplicationDelegate,UIAlertViewDelegate>
{
    UIWindow *window;
	RootViewController *m_rootVC;
	NSString *userName;
	NSString *password;
    TouchImageView_star * imageViewAnimation;
    AVAudioPlayer * player;
    NSTimer * animationOverTime;
    NSTimer * addRootViewTime;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
//@property (nonatomic, retain)

-(void)starSound;    //启动声音
-(void)starAnimation;//启动动画开始
-(void)addRootViewController;//加载初始界面
- (void)setScheduleNotifications; //添加本地通知
//-(void)CheckForUpgrade;//检查更新
@end

