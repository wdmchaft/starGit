//
//  ShangPinAppDelegate.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShangPinAppDelegate.h"
#import "RootViewController.h"
#import "GDataXMLNode.h"
#import "NameValue.h"


@implementation ShangPinAppDelegate

@synthesize window,userName,password;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    

    //[NSThread sleepForTimeInterval:2];   
    
    [MobClick setDelegate:self];
    [MobClick appLaunched];
    /*
    应用程序每次只会在启动时会向服务器发送一次消息，在应用程序过程中产生的所有消息(包括自定义事件和本次使用时长)都会在下次启动时候发送。
    如果应用程序启动时处在不联网状态，那么消息将会缓存在本地，下次再尝试发送。
    如果需要使用实时发送方式，请将
    [MobClick setDelegate:self];
    替换为如下语句：
    [MobClick setDelegate:self reportPolicy:REALTIME]; 
    */
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self performSelectorOnMainThread:@selector(starSound) withObject:nil waitUntilDone:NO];
    //添加动画
    //[self starSound];
    [self starAnimation];
    
    
    application.statusBarStyle = UIStatusBarStyleBlackOpaque;
	application.statusBarHidden = NO;
    
    
        //4.3秒后定时停止动画
        animationOverTime = [NSTimer scheduledTimerWithTimeInterval:4.3F target:self selector:@selector(stopAnimation) userInfo:nil repeats:NO];
        //4.5秒后开始加载初始界面
        addRootViewTime = [NSTimer scheduledTimerWithTimeInterval:4.5f target:self selector:@selector(addRootViewController) userInfo:nil repeats:NO];

    [self.window makeKeyAndVisible];   
    //注册通知
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    //[self setScheduleNotifications];
	return YES;
}
//启动动画
-(void)starAnimation{
    NSMutableArray * imageArray = [NSMutableArray array];
    for (int imageNum = 10001; imageNum<=10095 ;imageNum++) 
    {

        NSString * imageNameStr = [NSString stringWithFormat:@"res%d",imageNum];
        UIImage * imageName = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imageNameStr ofType:@"jpg"]];
        //NSLog(@"imageName = %@",imageName);
        [imageArray addObject:imageName];
    }
    imageViewAnimation = [[TouchImageView_star alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    imageViewAnimation.backgroundColor = [UIColor clearColor];
    imageViewAnimation.userInteractionEnabled = YES;
    imageViewAnimation.delegate = self;
    [imageViewAnimation becomeFirstResponder];
    
    imageViewAnimation.animationImages = imageArray;
    imageViewAnimation.animationDuration = 4.3f;
    [imageViewAnimation startAnimating];
    //[imageViewAnimation stopAnimating];
    [window addSubview:imageViewAnimation];
    [imageViewAnimation release];


}

//启动的声音
-(void)starSound{
    NSString * soundPath = [[NSBundle mainBundle] pathForResource:@"声音3" ofType:@"wav"];
    NSURL * soundUrl = [[NSURL alloc] initFileURLWithPath:soundPath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [player prepareToPlay];
    [player play];
    [soundUrl release];

}

//停止动画
- (void)stopAnimation{

    [imageViewAnimation stopAnimating];

}
//点击屏幕，结束开场动画
-(void)TouchStopAnimation
{
    
    [animationOverTime invalidate];
    [addRootViewTime invalidate];
    [player stop];
    [self stopAnimation];
    [self addRootViewController];
}

//加载初始界面
- (void)addRootViewController{
    //[player release];
    
    
    
    // 初始化ImageCacheManager
    [ImageCacheManager initCacheDirectory];
    m_rootVC = [[RootViewController alloc] init];
	[window addSubview:m_rootVC.view];
    
    //[self CheckForUpgrade];

    
//    UIAlertView * UpgradAlerView = [[UIAlertView alloc] initWithTitle:@"尚品升级" message:@"尚品新版完美支持iOS5,修复多出BUG，购物体验更佳，推荐升级！" delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"立即升级", nil];
//    UpgradAlerView.tag = 100;
//    [UpgradAlerView show];
//    [UpgradAlerView release];
	
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"退出到后台");

}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
	[MobClick appTerminated];
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
	[MobClick setDelegate:self];
	[MobClick appLaunched];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
	[MobClick appTerminated];
}

//添加本地通知的调用方法
#pragma mark -
#pragma mark LocaltionNotifiction
- (void)setScheduleNotifications
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    NSString * identifier = [[NSBundle mainBundle] bundleIdentifier];
//    NSLog(@"我要看看bundle %@",identifier);
//    for (UILocalNotification * localNotification in [[UIApplication sharedApplication]scheduledLocalNotifications]) {
//        NSString * identifierString_bigDay = [localNotification.userInfo objectForKey:@"bigDay"];
//        NSString * identifierString_weekly = [localNotification.userInfo objectForKey:@"weekly"];
//        
//        if ([identifierString_bigDay isEqualToString:@"bigDay"]||[identifierString_weekly isEqualToString:@"weekly"]) {
//            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
//            NSLog(@"取消了");
//            break;
//        }
//    }
    

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    UILocalNotification * localNotice_bigDay = [[UILocalNotification alloc] init];
    if (localNotice_bigDay != nil) {
        NSLog(@"本地通知");
        localNotice_bigDay.repeatInterval = kCFCalendarUnitDay;
        localNotice_bigDay.fireDate = [NSDate dateWithTimeIntervalSinceReferenceDate:34200];
        localNotice_bigDay.timeZone = [NSTimeZone defaultTimeZone];
        localNotice_bigDay.alertBody = @"尚品顶级时尚品特卖活动，即将开始";
        localNotice_bigDay.alertAction = @"进入活动";
        localNotice_bigDay.applicationIconBadgeNumber = 1;
        localNotice_bigDay.soundName = UILocalNotificationDefaultSoundName;
        
        //NSDateComponents
        
        NSString * bundleIdentifier = @"bigDay";
        NSDictionary * inforDic = [NSDictionary dictionaryWithObject:bundleIdentifier forKey:@"bigDay"];
        NSLog(@"看看infor = %@",inforDic);
        localNotice_bigDay.userInfo = inforDic;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotice_bigDay];
        [localNotice_bigDay release];
    }
    
    UILocalNotification * localNotice_weekly = [[UILocalNotification alloc] init];
    if (localNotice_weekly != nil) {
        NSLog(@"本地通知");
        //localNotice_weekly.repeatInterval = kCFCalendarUnitMinute;
        localNotice_weekly.fireDate = [NSDate dateWithTimeIntervalSinceNow:604800];
        localNotice_weekly.timeZone = [NSTimeZone defaultTimeZone];
        localNotice_weekly.alertBody = @"尊贵的尚品会员，您已经一周未登陆尚品，期待您的光临";
        localNotice_weekly.alertAction = @"进入尚品";
        localNotice_weekly.applicationIconBadgeNumber = 1;
        localNotice_weekly.soundName = UILocalNotificationDefaultSoundName;
        
        //NSDateComponents
        
        NSString * bundleIdentifier = @"weekly";
        NSDictionary * inforDic = [NSDictionary dictionaryWithObject:bundleIdentifier forKey:@"weekly"];
        NSLog(@"看看infor = %@",inforDic);
        localNotice_weekly.userInfo = inforDic;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotice_weekly];
        [localNotice_weekly release];
    }
    


}

# pragma mark -



#pragma mark RemoteNotifictions
//苹果推送通知的注册
- (void)applicationDidBecomeActive:(UIApplication *)application{
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"deviceToken: %@", deviceToken); 
    NSString *token_string = [[[deviceToken description] 
							   stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] 
							  stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	NSString *parameters = [NSString stringWithFormat:@"%@|%@",self.userName,token_string];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	NSString *tokenUrlStr = [NSString stringWithFormat:@"%@=GetPushParameter&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,self.userName,self.password];
	NSLog(@"发送token:%@",tokenUrlStr);
	
	NSURL *tokenUrl = [[NSURL alloc] initWithString:tokenUrlStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:tokenUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	[request release];
	[tokenUrl release];
	[connection release];
}

-(void)alertNotice:(NSString *)title withMSG:(NSString *)msg cancleButtonTitle:(NSString *)cancleTitle otherButtonTitle:(NSString *)otherTitle
{
    NSLog(@"%s",__FUNCTION__);
//    UIAlertView *alert;
//    if([otherTitle isEqualToString:@""])
//        alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancleTitle otherButtonTitles:nil,nil];
//    else
//        alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancleTitle otherButtonTitles:otherTitle,nil];
//    [alert show];
//    [alert release];
  
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	 NSLog(@"%s",__FUNCTION__);
    NSString * errorMessage = [error localizedDescription];
	[self alertNotice:@"" withMSG:[NSString stringWithFormat:@"Error in registraton.Error: %@",errorMessage] cancleButtonTitle:@"ok" otherButtonTitle:@""];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	NSLog(@"%s",__FUNCTION__);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"尚品通知" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}



# pragma mark -



-(NSString *)appKey
{
	return @"4da455eb112cf70b2b00003e";
}



- (void)dealloc
{
	self. userName = nil;
	[m_rootVC release];
    [window release];
    [super dealloc];
}


@end
