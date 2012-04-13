    //
//  RootViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "NewInfomationVC.h"
#import "LimitBuyViewController.h"
#import "InviteViewController.h"
#import "MyAccountViewController.h"
#import "MoreVC.h"
#import "CustomTabBar.h"
#import "GDataXMLNode.h"


@implementation RootViewController
@synthesize selectedView;
@synthesize tabBarC;
@synthesize myAccountVC;
@synthesize receivedData;


#pragma mark -
#pragma mark 初始化

- (void)loadView 
{
    [super loadView];
    //NSLog(@"%s",__FUNCTION__);
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 480)];
	mainView.backgroundColor = [UIColor blackColor];
	
	NewInfomationVC *shangPinInfoVC = [[NewInfomationVC alloc] init];
    UITabBarItem * shangPinTabBarItem = [[UITabBarItem alloc] init];
    
    shangPinInfoVC.tabBarItem = shangPinTabBarItem;
    [shangPinTabBarItem release];
    shangPinInfoVC.tabBarItem.tag = 1000;
	UINavigationController *shangPinInfoNavC = [[UINavigationController alloc] initWithRootViewController:shangPinInfoVC];
	shangPinInfoNavC.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[shangPinInfoVC release];
	
	LimitBuyViewController *limitBuyVC = [[LimitBuyViewController alloc] init];
	UITabBarItem * limitTabBarItem = [[UITabBarItem alloc] init];
    limitBuyVC.tabBarItem = limitTabBarItem;
    [limitTabBarItem release];
    limitBuyVC.tabBarItem.tag = 1001;
	UINavigationController *limitBuyNavC = [[UINavigationController alloc] initWithRootViewController:limitBuyVC];
	limitBuyNavC.navigationBar.barStyle = UIBarStyleBlack;
	[limitBuyVC release];
	
//	InviteViewController *inviteVC = [[InviteViewController alloc] init];
//	UITabBarItem * inviteTabBarItem = [[UITabBarItem alloc] init];
//    inviteVC.tabBarItem = inviteTabBarItem;
//    [inviteTabBarItem release];
//    inviteVC.tabBarItem.tag = 1002;
//	UINavigationController *inviteNavC = [[UINavigationController alloc] initWithRootViewController:inviteVC];
//	inviteNavC.navigationBar.barStyle = UIBarStyleBlack;
//	[inviteVC release];
	
	myAccountVC = [[MyAccountViewController alloc] init];
	UITabBarItem * myAcountTabBarItem = [[UITabBarItem alloc] init];
    myAccountVC.tabBarItem = myAcountTabBarItem;
    [myAcountTabBarItem release];
    myAccountVC.tabBarItem.tag = 1002;
	UINavigationController *myAccountNavC = [[UINavigationController alloc] initWithRootViewController:myAccountVC];
	myAccountNavC.navigationBar.barStyle = UIBarStyleBlack;
    NSLog(@"nav de 计数器 = %d",[myAccountNavC retainCount]);
    [myAccountVC release];
	
    MoreVC * moreVC = [[MoreVC alloc] init];
 	UITabBarItem * moreTabBarItem = [[UITabBarItem alloc] init];
    moreVC.tabBarItem = moreTabBarItem;
    [moreTabBarItem release];
    moreVC.tabBarItem.tag = 1003;
    //moreVC.tabBarItem.imageInsets
    UINavigationController * moreNavC = [[UINavigationController alloc] initWithRootViewController:moreVC];
    moreNavC.navigationBar.barStyle = UIBarStyleBlack;
    moreNavC.navigationItem.title = @"更多";
    [moreVC release];
    
    
    NSMutableArray *viewControllersArray = [[NSMutableArray alloc] initWithObjects:shangPinInfoNavC,limitBuyNavC,myAccountNavC,moreNavC,nil];
	
	[shangPinInfoNavC release];
	[limitBuyNavC release];
	[myAccountNavC release];
    [moreNavC release];
	
	
	tabBarC = [[CustomTabBar alloc] init];
	tabBarC.viewControllers = viewControllersArray;
    [tabBarC customTabBarButton];
    [tabBarC changeImageBtn:0];
    //[tabBarC selectedTabBarNo:0];
    self.tabBarC.customTabDelegate = self;
	tabBarC.selectedIndex = 0;
    seletedTab = 0;

    [self CheckForUpgrade];
    
    onsaleDetailVC = [[OnsaleDetailViewController alloc] init];
    onsaleDetailVC.changeImagDelegate = self;
    
 	[viewControllersArray release];
	[mainView addSubview:tabBarC.view];
	[self.view addSubview: mainView];
	[mainView release];
    
    
    //注册通知接收，接收类MyAccountViewController发出的通知
    NSNotificationCenter * logOutNotice = [NSNotificationCenter defaultCenter];
    [logOutNotice addObserver:self selector:@selector(logOut) name:@"logOut" object:nil];
    
//    NSNotificationCenter * stopTimer = [NSNotificationCenter defaultCenter];
//    NSString * const StarTimerNotification = @"StarTimer";
    
}
//“退出”通知中，退出当前的登录账户方法
-(void)logOut
{
    LogInViewController *loginViewController = [LogInViewController defaultLoginViewController];
    loginViewController.haslogin = NO;
    [self presentModalViewController:loginViewController animated:YES];
    
    //myAccountVC  = nil;   注销之后，每次调用代理方法
    
    [self.tabBarC selectedTabBarNo:0];
    tabBarC.selectedIndex = 0;    
    seletedTab = 0;
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
*/

-(void)changeMyAccountImagNum:(NSInteger)sender
{
    NSLog(@"%s",__FUNCTION__);
    //[self selecedTabBarAction:sender];
    [self.tabBarC selectedTabBarNo:sender];

}


#pragma mark -
#pragma CustomTabBarDelegate

- (void)selecedTabBarAction:(NSInteger)buttonTag
{
    UIViewController * seleccedVC = [[[tabBarC.viewControllers objectAtIndex:buttonTag]viewControllers] objectAtIndex:0];
    [self tabBarDidSelectViewController:seleccedVC];
    
    NSNotificationCenter * stopTimer = [NSNotificationCenter defaultCenter];
    NSString * const StarTimerNotification = @"StarTimer";
    NSString * const StopTimerNotification = @"StopTimer";


    //启动/关闭定时器
    if (buttonTag == 0) 
    {
        [stopTimer postNotificationName:StarTimerNotification object:self];
    }else
    {
        [stopTimer postNotificationName:StopTimerNotification object:self];
    }
}


#pragma mark -
#pragma mark CustomTabBarDelegate

- (void)tabBarDidSelectViewController:(UIViewController *)viewController
{
    
     LogInViewController *loginViewController = [LogInViewController defaultLoginViewController];
     [loginViewController readUserName];
	loginViewController.delegate = self;
    loginViewController.MyAcountDelegate = myAccountVC;
	if(loginViewController.haslogin)
	{
        seletedTab = viewController.tabBarItem.tag - 1000;
        [self.tabBarC selectedTabBarNo:seletedTab];
        
        
        if(viewController.tabBarItem.tag == 1001)
        {
            tabBarC.selectedIndex = 1;
        }
//        if(viewController.tabBarItem.tag == 1002)
//		{
//            tabBarC.selectedIndex = 2;
//            if(seletedTab != 2)
//            {
//                InviteViewController *inviteVC = (InviteViewController *)((UINavigationController *)viewController).visibleViewController;
//                [inviteVC showInviteView];
//
//            }
//			
//		}
		if(viewController.tabBarItem.tag == 1002)
		{
            tabBarC.selectedIndex = 2;
            
            if(seletedTab != 2)
            {
                myAccountVC = (MyAccountViewController *)((UINavigationController *)viewController).visibleViewController;
                
                    
//                if([myAccountVC.navigationController.visibleViewController isMemberOfClass:[MyAccountViewController class]])
//                {
//                    if(myAccountVC.segmentControl.selectedSegmentIndex == 0 && myAccountVC.segmentControl)
//                    {
//                        [myAccountVC showMyOrderView];
//                    }
//                }
//                else
//                {
//                    ;
//                }
            }
        }
        if(viewController.tabBarItem.tag == 1003)
        {
            tabBarC.selectedIndex = 3;
        }
        

	}
	else
	{
		if(viewController.tabBarItem.tag != 1000)
		{
            [self presentModalViewController:loginViewController animated:YES];
        }
		tabBarC.selectedIndex = 0;
	}
	seletedTab = viewController.tabBarItem.tag - 1000;
}


#pragma mark -
#pragma mark LoginDelegate
-(void) didLoginSucess
{
    NSLog(@"登陆代理执行");
    [self.tabBarC selectedTabBarNo:seletedTab];
    
}

#pragma mark -
#pragma mark 释放相关

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (interfaceOrientation == UIInterfaceOrientationPortrait ||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    }
    return NO;
}

- (void)CheckForUpgrade{
    
    NSLog(@"%s",__FUNCTION__);
    NSString *parameters = [NSString stringWithFormat:@""];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	NSString *ckeckUpgradeUrlStr = [NSString stringWithFormat:@"%@=GetVersionAndAppAddresss&parameters=%@&md5=%@&u=&w=",ADDRESS,encodedString,md5Str];                                     //新接口到了即改正
	NSLog(@"检查更新:%@",ckeckUpgradeUrlStr);
	
	NSURL *ckeckUpgradeUrl = [[NSURL alloc] initWithString:ckeckUpgradeUrlStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:ckeckUpgradeUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    
//  loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//self.view.frame];
//	[self.view addSubview:loadingView];
	checkUpgradConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[ckeckUpgradeUrl release];
}


#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"更新检查 获得服务器 回应1");
	
    NSMutableData * nData = [[NSMutableData alloc] init];
    self.receivedData = nData;
    [nData release];
	[self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSLog(@"更新检查 接收到列表 数据1");
	[self.receivedData appendData:data];
    //data = nil ;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Succeeded! Received %d bytes of data_1",[self.receivedData length]);

    NSError *error = nil;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
    
    if(error)
    {
        [document release];
        return;
    }
    GDataXMLElement *root = [document rootElement];
    GDataXMLElement *version = [[root elementsForName:@"version"] objectAtIndex:0];
    NSString * versionStr = [version stringValue];
    GDataXMLElement *addr = [[root elementsForName:@"addr"]objectAtIndex:0];
    NSString * addrStr = [addr stringValue];
    versionInfoArray = [[NSArray alloc] initWithObjects:versionStr,addrStr, nil];
    [document release];
    [checkUpgradConnection release];
    self.receivedData = nil;
    
    [self deterMineVersion];

}

//判断是否需要更新
- (void)deterMineVersion;//:(NSArray * )versionInfoArray
{
    NSString * NewStr = [versionInfoArray objectAtIndex:0];
    NSString * OldStr = VERSIONID;
    
    //[self CompareNewStr:NewStr OldStr:OldStr];
    //[versionInfoArray objectAtIndex:0] != VERSIONID
    
    if ([self CompareNewStr:NewStr OldStr:OldStr])
    {
        UIAlertView * UpgradAlerView = [[UIAlertView alloc] initWithTitle:@"版本升级" message:@"发现新版本，是否需要升级？" delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"立即升级", nil];
        UpgradAlerView.tag = 100;
        [UpgradAlerView show];
        [UpgradAlerView release];

    }

}

- (BOOL)CompareNewStr:(NSString *)newStr OldStr:(NSString *)OldStr
{
    newStr = [newStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([newStr length]<3) {
        newStr = [NSString stringWithFormat:@"%@0",newStr];
    }
    
    OldStr = [OldStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([OldStr length]<3) {
        OldStr = [NSString stringWithFormat:@"%@0",OldStr];
    }
    
    if ([newStr intValue] > [OldStr intValue]) {
        return YES;
    }
    else
    {
        return NO;
    }
}





#pragma mark  UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 100) 
    {
        if (buttonIndex == 1) 
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[versionInfoArray objectAtIndex:1]]];
        }
    }
}





- (void)dealloc 
{
	[tabBarC release];
    NSNotificationCenter * logOutNotice = [NSNotificationCenter defaultCenter];
    [logOutNotice removeObserver:self];
    [super dealloc];
}


@end









