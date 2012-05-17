    //
//  UserInfoViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserInfoViewController.h"
#import "CustomLabel.h"
#import "EditPasswordViewController.h"
#import "GDataXMLNode.h"

@implementation UserInfoViewController
@synthesize getEmailDelegate;
@synthesize receivedData;
@synthesize provinceArray;
@synthesize cityArray;
@synthesize areaArray;
@synthesize sexLabel;


#pragma mark -
#pragma mark 返回 我的账户界面
- (void)returnBack
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 个人信息视图控制器 初始化

- (id)init
{
    self = [super init];
    if (self) {
        sexLabel = [[CustomLabel alloc] init];
    }
    return self;
}


- (void)loadView 
{
	self.title = @"个人信息";
	//返回按钮
//	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	backButton.frame = CGRectMake(0, 0, 53, 29);
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//	[backButton setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal];
//	[backButton addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
//	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//	self.navigationItem.leftBarButtonItem = backItem;
//	[backItem release];

    UIBarButtonItem *backBI = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(returnBack)];
    self.navigationItem.leftBarButtonItem = backBI;
    [backBI release];

    
//	//修改密码 按钮
//	UIBarButtonItem *editPasswordBI = [[UIBarButtonItem alloc] initWithTitle:@"修改密码" style:UIBarButtonItemStyleBordered target:self action:@selector(doEditPassWord)];
//	self.navigationItem.rightBarButtonItem = editPasswordBI;
//    [editPasswordBI release];
	
	UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	userInfoView.backgroundColor = [UIColor blackColor];

    
    //电子邮箱   1
	emailLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 20, 300, 30)];//CGRectMake(10, 90, 300, 30)];
	emailLabel.backgroundColor = [UIColor clearColor];
	emailLabel.numberOfLines = 0;
	emailLabel.verticalAlignment = VerticalAlignmentTop;
	emailLabel.textColor = WORDCOLOR;
	emailLabel.text = @"邮箱:";
	[userInfoView addSubview:emailLabel];    
    
    //真实姓名   2
	realNameLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 55, 300, 30)];//CGRectMake(10, 20, 300, 30)];
	realNameLabel.backgroundColor = [UIColor clearColor];
    realNameLabel.verticalAlignment = VerticalAlignmentTop;
	realNameLabel.textColor = WORDCOLOR;
	realNameLabel.text = @"姓名:";
	[userInfoView addSubview:realNameLabel];
    
    //性别    3
    sexLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 90, 300, 30)];
	sexLabel.frame = CGRectMake(10, 90, 300, 30);
    sexLabel.backgroundColor = [UIColor clearColor];
	sexLabel.numberOfLines = 0;
	sexLabel.textColor = WORDCOLOR;
	sexLabel.text = @"性别: ";
	[userInfoView addSubview:sexLabel];

    
	//手机号码   4
	mobileLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 125, 300, 30)];//CGRectMake(10, 55, 300, 30)];
	mobileLabel.backgroundColor = [UIColor clearColor];
	mobileLabel.textColor = WORDCOLOR;
    mobileLabel.verticalAlignment = VerticalAlignmentTop;
	mobileLabel.text = @"号码:";
	[userInfoView addSubview:mobileLabel];
    
    
    
    //固话    5
    telephone = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 160, 300, 30)];
	telephone.backgroundColor = [UIColor clearColor];
	telephone.numberOfLines = 0;
	telephone.textColor = WORDCOLOR;
    telephone.verticalAlignment = VerticalAlignmentTop;
	telephone.text = @"固话:";
	[userInfoView addSubview:telephone];    
	
	
	
	UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 300, 15)];
	tipLabel.font = [UIFont fontWithName:@"Arial" size:14];
	tipLabel.textColor = [UIColor redColor];
	tipLabel.text = @"如若修改个人信息,请登录www.shangpin.com";
	tipLabel.backgroundColor = [UIColor clearColor];
	[userInfoView addSubview:tipLabel];
	[tipLabel release];
	
	self.view = userInfoView;
	[userInfoView release];
}

#pragma mark -
#pragma mark 修改密码  加载个人信息
-(void) doEditPassWord
{
	EditPasswordViewController *editPasswordVC = [[EditPasswordViewController alloc] init];
	[self.navigationController pushViewController:editPasswordVC animated:YES];
	[editPasswordVC release];
}

-(void) loadmyInfo
{
	self.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@",account.account];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	[MobClick event:@"PersonalCenter"];
	
	NSString *personalCenterStr = [NSString stringWithFormat:@"%@=PersonalCenter&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"个人信息:%@",personalCenterStr);
	NSURL *personalCenterUrl = [[NSURL alloc] initWithString:personalCenterStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:personalCenterUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:loadingView];
	myInfoConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[personalCenterUrl release];
}

-(float)contentHeight: (NSString *)string			//根据字符串的内容计算其宽高
{
	CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(300, 500) lineBreakMode:UILineBreakModeCharacterWrap];
	float height = size.height;
	NSLog(@"width = %g  height = %g",size.width,size.height);
	return height;
}

#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"个人信息 获得服务器 回应");
    NSMutableData * rData = [[NSMutableData alloc] init];
    self.receivedData = rData;
    [rData release];
	[self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Succeeded! Received %d bytes of data_个人信息",[self.receivedData length]);
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	NSError *error = nil;
	GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
	if(error)
	{
		[document release];
		[myInfoConnection release];
		return;
	}
	GDataXMLElement *root = [document rootElement];
	GDataXMLElement *name = [[root elementsForName:@"name"] objectAtIndex:0];	//真实姓名
	if ([[name stringValue]isEqualToString:@"(null)"])
    {
        realNameLabel.text = @"姓名：";
    }else
    {
        realNameLabel.text = [NSString stringWithFormat:@"姓名: %@",[name stringValue]];
    }
	GDataXMLElement *mobile = [[root elementsForName:@"mobile"] objectAtIndex:0];//手机号码
    if ([[mobile stringValue]isEqualToString:@"(null)"])
    {
        mobileLabel.text =  @"号码：";
    }else
    {
        mobileLabel.text = [NSString stringWithFormat:@"号码: %@",[mobile stringValue]];
    }
    
	GDataXMLElement *email = [[root elementsForName:@"email"] objectAtIndex:0];//Email地址
	NSString *emailStr = [NSString stringWithFormat:@" %@",[email stringValue]];
	float emailHeight = [self contentHeight:emailStr];
	emailLabel.frame = CGRectMake(10, 20, 300, emailHeight);
	_emailStr = emailStr;
    if ([emailStr isEqualToString:@"(null)"])
    {
        emailLabel.text =   @"邮箱：";
    }else
    {
        emailLabel.text = [NSString stringWithFormat:@"邮箱: %@",emailStr];
    }
	GDataXMLElement *city = [[root elementsForName:@"city"] objectAtIndex:0];//省市县地址
	NSString *cityStr = [city stringValue];
	NSString *theCity = [NSString stringWithFormat:@"省市县: %@",[NameValue findAddressWithValue:cityStr]];
	float cityHeight = [self contentHeight:theCity];
	cityLabel.frame = CGRectMake(10, 95 + emailHeight, 300, cityHeight);
	cityLabel.text = theCity;
	GDataXMLElement *address = [[root elementsForName:@"address"] objectAtIndex:0];	//具体地址
	NSString *addressStr = [NSString stringWithFormat:@"地址: %@",[address stringValue]];
	float addressHeight = [self contentHeight:addressStr];
	addressLabel.frame = CGRectMake(10, 100 + emailHeight + cityHeight, 300, addressHeight);
	addressLabel.text = addressStr;
	GDataXMLElement *postcode = [[root elementsForName:@"postcode"] objectAtIndex:0];//邮政编码
	postcodeLabel.frame = CGRectMake(10, 105 + emailHeight +cityHeight + addressHeight, 300, 30);
	postcodeLabel.text = [NSString stringWithFormat:@"邮政编码: %@",[postcode stringValue]];
    
    GDataXMLElement * telephoneElement = [[root elementsForName:@"telephone"] objectAtIndex:0];
    //NSString * telephoneStr = [telephoneElement stringValue];
    
    if (telephoneElement != nil) {
            if ([[telephoneElement stringValue] isEqualToString:@"(null)"])
            {
                telephone.text =   @"固话:";
                NSLog(@"固定电话 ：%@",[telephoneElement stringValue]);
            }else
            {
                NSMutableString * telephoneStr =(NSMutableString *) [telephoneElement stringValue];
                NSInteger tsrt = [telephoneStr length];
                if ([telephoneStr substringFromIndex:tsrt] == @"-") {
                    [telephoneStr deleteCharactersInRange:NSMakeRange(tsrt, 1)];
                    telephone.text = [NSString stringWithFormat:@"固话: %@",telephoneStr];
                    NSLog(@"固定电话 ：%@",telephoneStr);
                }
            }        
    }

        
	
	[document release];
	[myInfoConnection release];
	[getEmailDelegate setUserEmail:_emailStr];
    self.receivedData = nil;
	self.provinceArray = nil;
	self.cityArray = nil;
	self.areaArray = nil;
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	[myInfoConnection release];
	self.receivedData = nil;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark 释放相关

- (void)dealloc 
{
	[realNameLabel release];
	[mobileLabel release];
	[emailLabel release];
	[cityLabel release];
	[addressLabel release];
	[postcodeLabel release];
	
	self.receivedData = nil;
	self.provinceArray = nil;
	self.cityArray = nil;
	self.areaArray = nil;
	
    [super dealloc];
}


@end
