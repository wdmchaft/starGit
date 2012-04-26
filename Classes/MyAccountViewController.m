    //
//  MyAccountViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyAccountViewController.h"
#import "UserInfoViewController.h"
#import "AddressViewController.h"
#import "MyAlertViewController.h"
#import "SubscriptionViewController.h"
#import "GDataXMLNode.h"
#import "Address.h"
#import "AddressListViewController.h"
#import "EditPasswordViewController.h"

@implementation MyAccountViewController
@synthesize receivedData;
@synthesize addressArray;
@synthesize provinceArray;
@synthesize functionTableView;
@synthesize cityArray;
@synthesize areaArray;

#pragma mark -
#pragma mark 释放相关

- (void)dealloc 
{
    NSLog(@"%@",__FUNCTION__);
    [super dealloc];
    [userInfoVC release];
    [functionAarray release];
    [functionTableView release];
    [headPhotoImgV release];
    [userNameLabel release];
    [userLevel release];
    [userEmailLable release];
    [functionAarray release];
    
    myOrderVC = nil;
    
    self.functionTableView = nil;
    self.receivedData = nil;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@",account.account];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	NSString *myAccountStr = [NSString stringWithFormat:@"%@=MyAccount&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"我的账户:%@",myAccountStr);
	NSURL *myAccountUrl = [[NSURL alloc] initWithString:myAccountStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:myAccountUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
//	[self.view addSubview:loadingView];
//    NSLog(@"添加加载视图");
    myAccountConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[myAccountUrl release];
    
    userInfoVC = [[UserInfoViewController alloc] init];
    userInfoVC.getEmailDelegate = self;
	[userInfoVC loadmyInfo];
    
    
    NSNotificationCenter * comeKeepNotice = [NSNotificationCenter defaultCenter];
    [comeKeepNotice addObserver:self selector:@selector(comeKeep) name:@"comeKeep" object:nil];
    [comeKeepNotice addObserver:self selector:@selector(loadMyAcountData) name:@"LoginSuccess" object:nil];
}

//获取用户个人信息  -----
- (void)viewDidLoadData
{
    //[super viewDidLoad];
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@",account.account];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	NSString *myAccountStr = [NSString stringWithFormat:@"%@=MyAccount&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"我的账户:%@",myAccountStr);
	NSURL *myAccountUrl = [[NSURL alloc] initWithString:myAccountStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:myAccountUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:loadingView];
    myAccountConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[myAccountUrl release];
    
    userInfoVC = [[UserInfoViewController alloc] init];
    userInfoVC.getEmailDelegate = self;
	[userInfoVC loadmyInfo];
    
    
//    NSNotificationCenter * comeKeepNotice = [NSNotificationCenter defaultCenter];
//    [comeKeepNotice addObserver:self selector:@selector(comeKeep) name:@"comeKeep" object:nil];
    
}


#pragma mark -
#pragma mark 初始化方法
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{

    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoTittle.png"]];
    logoImageView.center = CGPointMake(160, [logoImageView center].y);
    self.navigationItem.titleView = logoImageView;
    [logoImageView release];
    

    UIBarButtonItem *logOutBI = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStyleBordered target:self action:@selector(logOut)];
    self.navigationItem.rightBarButtonItem = logOutBI;
    [logOutBI release];

      
	UIView *myAccountView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	myAccountView.backgroundColor = [UIColor blackColor];
	
	//会员头像   会员姓名   会员余额   会员等级
	headPhotoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(4, 8, 72, 70)];
	[myAccountView addSubview:headPhotoImgV];
    [headPhotoImgV release];
	
	userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(94, 8, 200, 20)];
	userNameLabel.backgroundColor = [UIColor clearColor];
	userNameLabel.textColor = [UIColor whiteColor];//WORDCOLOR;
	userNameLabel.font = [UIFont fontWithName:@"Arial" size:16];
	[myAccountView addSubview:userNameLabel];
    [userNameLabel release];
    NSLog(@"userNameLabel  retaincount = %d",[userNameLabel retainCount]);
	
	
	userLevel = [[UILabel alloc] initWithFrame:CGRectMake(94, 35, 200, 20)];//[[UILabel alloc] initWithFrame:CGRectMake(220, 10, 48, 14)];
	userLevel.backgroundColor = [UIColor clearColor];
	userLevel.textColor = [UIColor whiteColor];//WORDCOLOR;
	userLevel.font = [UIFont fontWithName:@"Arial" size:16];
	//userLevel.hidden = TRUE;//余额隐藏，以后扩展来用
	[myAccountView addSubview:userLevel];
    [userLevel  release];
    
    userEmailLable = [[UILabel alloc] initWithFrame:CGRectMake(92, 60, 220, 20)];//[[UILabel alloc] initWithFrame:CGRectMake(220, 10, 48, 14)];
	userEmailLable.backgroundColor = [UIColor clearColor];
	userEmailLable.textColor = [UIColor whiteColor];//WORDCOLOR;
	userEmailLable.font = [UIFont fontWithName:@"Arial" size:16];
	[myAccountView addSubview:userEmailLable];
    [userEmailLable release];

    
	
    
    NSArray * functionAarrayUp = [[NSArray alloc] initWithObjects:@"我的订单",@"我的收藏",@"我的提醒", nil];
    NSArray * functionAarrayDawn = [[NSArray alloc] initWithObjects:@"个人信息",@"收货地址",@"修改密码",nil];
    functionAarray = [[NSArray alloc] initWithObjects:functionAarrayUp,functionAarrayDawn,nil];
    [functionAarrayUp release];
    [functionAarrayDawn release];
    
	functionTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 80, 300, 277) style:UITableViewStyleGrouped ];
    functionTableView.backgroundColor = [UIColor clearColor];
    functionTableView.delegate = self;
    functionTableView.dataSource = self;
    [myAccountView addSubview:functionTableView];
    [functionTableView release];
    
	
	self.view = myAccountView;
	
	[myAccountView release];
    
    
    
    postNum = 3;

}



#pragma mark -
#pragma mark 接受通知 ，进入我的收藏 方法
-(void)comeKeep
{
    if (postNum%2==1) 
    {
        if (myKeepListVC == nil) {
                myKeepListVC = [[MyKeepListViewController alloc] initWithStyle:UITableViewStylePlain];
            }
        if (self.navigationController.visibleViewController != myKeepListVC) {
             [self.navigationController pushViewController:myKeepListVC animated:YES];
        }    
        [myKeepListVC getMyKeepList];
    }
    postNum++;
}



#pragma mark -
#pragma mark 退出账户

-(void)logOut
{
    UIActionSheet *logOutActSheet =[[UIActionSheet alloc] initWithTitle:@"确定要退出登录吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
    logOutActSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    logOutActSheet.alpha = 0.9f;
    [logOutActSheet showInView:self.tabBarController.view];
    [logOutActSheet release];
    [myOrderVC release];
    myOrderVC = nil;
    myKeepListVC = nil;
    
}

#pragma mark -
#pragma mark  MyAcountLoginDelegate method
- (void)loadMyAcountData
{
    [self viewDidLoadData];
}

#pragma mark - 
#pragma mark getEmailDelegate method

- (void)setUserEmail:(NSString *)emailStr
{
    userEmailLable.text = emailStr;
}




#pragma mark - 
#pragma mark UIActionSheetDelegate method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self postLogoutNotice];
    }
}

//注册通知，发送退出账户通知,接收通知的类为RootViewController

-(void)postLogoutNotice
{
    NSNotificationCenter * logOutNotice = [NSNotificationCenter defaultCenter];
    NSString * const logOutNotification = @"logOut";
    NSString * const renewSuggestStr = @"renewSug";
    [logOutNotice postNotificationName:renewSuggestStr object:self];
    [logOutNotice postNotificationName:logOutNotification object:self];
    
}

#pragma mark -
#pragma mark tableViewDelegate  Datascouer method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [functionAarray count];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [functionAarray objectAtIndex:section];
    
    return [array count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"indexCell";	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        UIView * cellBackView = [[UIView alloc] initWithFrame:cell.frame];//cell的选中背景视图
        cellBackView.backgroundColor = [UIColor colorWithRed:0.83f green:0.75f blue:0.36f alpha:0.9f];
        cellBackView.layer.masksToBounds = YES;
        cellBackView.layer.cornerRadius = 5.0f;
        cell.selectedBackgroundView = cellBackView;
        [cellBackView release];

        cell.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"303x1.png"]];
        UILabel * textLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 230, 30)];
        textLable.textColor = [UIColor blackColor];
        textLable.font = [UIFont boldSystemFontOfSize:16.0f];
        [cell.contentView addSubview:textLable];
        [textLable release];
        UIImageView * accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Accessary.png"]];
        [cell.contentView addSubview:accessoryView];
        cell.accessoryView = accessoryView;
        [accessoryView release];
    }    
    cell.textLabel.text = [[functionAarray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中的是第 %d 行",indexPath.section*3+indexPath.row);
    int  selectRow = indexPath.section*3+indexPath.row;
    switch (selectRow) {
        case 0:
            if (myOrderVC == nil) {
                myOrderVC = [[MyOrderViewController alloc] init];
            }
            [self.navigationController pushViewController:myOrderVC animated:YES];
            [myOrderVC.myOrderView loadMyOrder];
//            [myOrderVC release];
//            myOrderVC = nil;
            break;
        case 1:
            if (myKeepListVC == nil) {
                myKeepListVC = [[MyKeepListViewController alloc] initWithStyle:UITableViewStylePlain];
            }
            [self.navigationController pushViewController:myKeepListVC animated:YES];
            [myKeepListVC getMyKeepList];
            break;
        case 2:
            [self showMyAlert];
           break;
        case 3:
            [self showMyInfo];
            break;
        case 4:
            [self getAddressInfo];
            //[self showAddress];
            break;
        case 5:
            [self doEditPassWord];
            break;
    
        default:
            break;
    }
    
    [self performSelector:@selector(deselect:) withObject:nil afterDelay:0.1f];

    
}

- (void)deselect:(NSIndexPath *)indexPath
{
    [self.functionTableView deselectRowAtIndexPath: self.functionTableView.indexPathForSelectedRow   animated:YES];
}


#pragma mark -
#pragma mark 修改密码  加载个人信息
-(void) doEditPassWord
{
	EditPasswordViewController *editPasswordVC = [[EditPasswordViewController alloc] init];
	[self.navigationController pushViewController:editPasswordVC animated:YES];
	[editPasswordVC release];
}




#pragma mark -
#pragma mark 个人信息   收货地址   我的提醒   尚品订阅

-(void) showMyInfo
{
    if (userInfoVC == nil) {
         userInfoVC = [[UserInfoViewController alloc] init];
        [userInfoVC loadmyInfo];
    }
    userInfoVC.sexLabel.text = [NSString stringWithFormat:@"性别: %@",userSexStr];
	[self.navigationController pushViewController:userInfoVC animated:YES];
	//[userInfoVC release];
}

-(void) showAddress
{
    AddressListViewController *addressListVC = [[AddressListViewController alloc] init];
	addressListVC.addressArray = self.addressArray;
	self.addressArray = nil;
	[self.navigationController pushViewController:addressListVC animated:YES];
	[addressListVC showList];
	[addressListVC release];
}

-(void) showMyAlert
{
	if(myAlertVC == nil)
	{
		myAlertVC = [[MyAlertViewController alloc] init];
	}
	[self.navigationController pushViewController:myAlertVC animated:YES];
	[myAlertVC getMyPromptList];
}

-(void) showMySubscription
{
	if(subscriptionVC == nil)
	{
		subscriptionVC = [[SubscriptionViewController alloc] init];
	}
	[self.navigationController pushViewController:subscriptionVC animated:YES];
	[subscriptionVC getSubscribeInfo];
}

#pragma mark -
#pragma mark 获得收货地址信息
-(void) getAddressInfo
{
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@",account.account];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	NSString *deliveryaddress = [NSString stringWithFormat:@"%@=Deliveryaddress&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"我的账户-收货地址（显示）:%@",deliveryaddress);
	NSURL *deliveryaddressUrl = [[NSURL alloc] initWithString:deliveryaddress];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:deliveryaddressUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	getAddressConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[deliveryaddressUrl release];
}



#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"我的账户 获得服务器 回应");
    NSMutableData * rData = [[NSMutableData alloc] init];
    self.receivedData = rData;
    [rData release];
	[self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSLog(@"接收到 数据");
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Succeeded! Received %d bytes of data_我的尚品",[self.receivedData length]);
    NSError *error = nil;

    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
    if(connection == myAccountConnection)
	{
		NSLog(@"Succeeded! Received  bytes of data ——个人信息");
        if(error)
		{
            [loadingView finishLoading];
            [loadingView removeFromSuperview];
            [loadingView release];
            NSLog(@"   %@             取消图片",error);
            [document release];
			[myAccountConnection release];
			return;
		}
        [loadingView finishLoading];
		[loadingView removeFromSuperview];
		[loadingView release];
        NSLog(@"                取消图片");
        GDataXMLElement *root = [document rootElement];
		GDataXMLElement *name = [[root elementsForName:@"name"] objectAtIndex:0];	//用户名
        if ([[name stringValue]isEqualToString:@"(null)"])
        {
            userNameLabel.text = nil;
        }
        else
        {
            userNameLabel.text = [name stringValue];
        }
		//GDataXMLElement *money = [[root elementsForName:@"money"] objectAtIndex:0];	//余额
		//NSLog(@"余额：  %@",money);
        //userMoneyLabel.text = [NSString stringWithFormat:@"余额 ： %@",[money stringValue] ];
		GDataXMLElement *level = [[root elementsForName:@"level"] objectAtIndex:0];	//会员等级
		NSString *leavelStr = [level stringValue];
		if([leavelStr isEqualToString:@"0003"])
		{
			VIPImgV.image = [UIImage imageNamed:@"VIP3.png"];
            userLevel.text = @"白金会员";
		}
		else if([leavelStr isEqualToString:@"0002"])
		{
			VIPImgV.image = [UIImage imageNamed:@"VIP2.png"];
            userLevel.text = @"黄金会员";
		}
		else
		{
			VIPImgV.image = [UIImage imageNamed:@"VIP1.png"];
            userLevel.text = @"普通会员";
		}
		GDataXMLElement *gender = [[root elementsForName:@"gender"] objectAtIndex:0];//性别
        if([[gender stringValue] isEqualToString:@"1"])
		{
			
            userSexStr = @"男";
            headPhotoImgV.image	= [UIImage imageNamed:@"Male.png"];
		}
		else if([[gender stringValue] isEqualToString:@"0"])
		{
			userSexStr = @"女";
            headPhotoImgV.image	= [UIImage imageNamed:@"Female.png"];
		}
		else
		{
			headPhotoImgV.image	= [UIImage imageNamed:@"NoneGender.png"];
		}
		[myAccountConnection release];
	}
	
	if(connection == getAddressConnection)
	{
		if(error)
		{
			[document release];
			[getAddressConnection release];
            NSLog(@"back to Error = %@",error);
			return;
		}
		GDataXMLElement *root = [document rootElement];
		NSMutableArray * rArray = [[NSMutableArray alloc]init];
        self.addressArray = rArray;
        [rArray release];
		NSArray *array = [root elementsForName:@"receiver"];
		for(GDataXMLElement *receiver in array)
		{
			Address *address = [[Address alloc] init];
			GDataXMLElement *name = [[receiver elementsForName:@"name"] objectAtIndex:0];		//收货人姓名
			address.Name = [name stringValue];
			GDataXMLElement *city = [[receiver elementsForName:@"city"] objectAtIndex:0];		//省市县编码
			address.city = [city stringValue];												//省市县地址
			GDataXMLElement *addressElement = [[receiver elementsForName:@"address"] objectAtIndex:0];
			address.address = [addressElement stringValue];									//详细地址
			GDataXMLElement *postcode = [[receiver elementsForName:@"postcode"] objectAtIndex:0];
			address.postcode = [postcode stringValue];										//邮政编码
			GDataXMLElement *phone = [[receiver elementsForName:@"phone"] objectAtIndex:0];
			address.phone = [phone stringValue];											//电话号码
			GDataXMLElement *mobile = [[receiver elementsForName:@"mobile"] objectAtIndex:0];
			address.mobile = [mobile stringValue];											//手机号码
			GDataXMLElement *consigneeid = [[receiver elementsForName:@"consigneeid"] objectAtIndex:0];
			address.consigneeid = [consigneeid stringValue];
			[self.addressArray addObject:address];
			[address release];
		}
		[getAddressConnection release];
		[self showAddress];
	}
	
    
	[document release];
	self.receivedData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if(getAddressConnection != connection)
	{
        [loadingView finishLoading];
		[loadingView removeFromSuperview];
		[loadingView release];
    }
	[connection release];
	self.receivedData = nil;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}



@end
