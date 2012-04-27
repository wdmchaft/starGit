    //
//  LogInViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LogInViewController.h"
#import "ShangPinAppDelegate.h"
#import "GDataXMLNode.h"

@implementation LogInViewController
@synthesize haslogin;
@synthesize delegate;
@synthesize MyAcountDelegate;
@synthesize userNameTF;
@synthesize receivedData;

#pragma mark -
#pragma mark 数据存储
-(void) saveUserName
{
	NSLog(@"保存用户信息");
    NSString *email = userNameTF.text;
	NSString *password = passwordTF.text;
	NSArray *m_array = [[NSArray alloc] initWithObjects:email,password,nil];
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]; 
	NSString *filename = [path stringByAppendingPathComponent:@"userEmail"];
	[NSKeyedArchiver archiveRootObject:m_array toFile:filename];
	[m_array release];
}

-(void) readUserName
{
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]; 
	NSString *filename = [path stringByAppendingPathComponent:@"userEmail"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:filename])
	{
		userNameTF.text = [[NSKeyedUnarchiver unarchiveObjectWithFile:filename] objectAtIndex:0];
		//passwordTF.text = [[NSKeyedUnarchiver unarchiveObjectWithFile:filename] objectAtIndex:1];
	}
}

#pragma mark -
#pragma mark 键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField.tag<1002) {
        [textField resignFirstResponder];
        UITextField * textFieldDawn = (UITextField *)[backGroundView viewWithTag:[textField tag]+1];
        [textFieldDawn becomeFirstResponder];
        return NO;
    }
    else{
        [textField resignFirstResponder];
        [self doLogin];
        return YES;
    }
}

#pragma mark -
#pragma mark 登录界面  返回
-(void) backToNewsView
{
	[self dismissModalViewControllerAnimated:YES];
    //userNameTF.text = nil;
    passwordTF.text = nil;
    
    //发送定时器开始 的 通知  接收类为shangpindelegate
    NSNotificationCenter * noticeCenter = [NSNotificationCenter defaultCenter];
    NSString * const StarTimerNotification = @"StarTimer";
    [noticeCenter postNotificationName:StarTimerNotification object:self];
    NSLog(@"Sending notifiction");
    
    //[self.delegate initTimer];
    //NSLog(@"返回__定时器");
}


#pragma mark -
#pragma mark 初始化方法
static LogInViewController *loginVC = nil;
+(LogInViewController *)defaultLoginViewController
{
	if(loginVC == nil)
	{
		loginVC = [[LogInViewController alloc] init];
	}
	return loginVC;
}

- (void)loadView 
{
	UIView *loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	//loginView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginBG.png"]];
	//背景图片
    UIImageView *imageBJ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	imageBJ.image = [UIImage imageNamed:@"AllowBackground.jpg"];
    imageBJ.alpha = 1.0f;
	[loginView addSubview:imageBJ];
	[imageBJ release];
    
    backGroundView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    backGroundView.contentSize = CGSizeMake(320, 461);
    backGroundView.backgroundColor = [UIColor clearColor];
    backGroundView.showsVerticalScrollIndicator = NO;
    backGroundView.showsHorizontalScrollIndicator = NO;
    [loginView addSubview:backGroundView];
    [backGroundView release];
    
    //登录窗口
    UIImageView * imageDL = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 300, 235)];
    imageDL.image = [UIImage imageNamed:@"Layer_DownRound.png"];
    imageDL.layer.masksToBounds = YES;
    imageDL.layer.cornerRadius = 6.0f;
    [backGroundView addSubview:imageDL];
    [imageDL release];
    
    UIImageView * imageDLtitle = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 300, 35)];
    imageDLtitle.image = [UIImage imageNamed:@"AllowTitle.png"];
    UILabel * imageDLtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 300, 35)];
    imageDLtitleLabel.backgroundColor = [UIColor clearColor];
    imageDLtitleLabel.text = @"会 员 登 陆";
    imageDLtitleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    imageDLtitleLabel.textAlignment = UITextAlignmentCenter;
    imageDLtitleLabel.textColor = [UIColor whiteColor];
    [backGroundView addSubview:imageDLtitle];
    [backGroundView addSubview:imageDLtitleLabel];
    [imageDLtitle release];
    [imageDLtitleLabel release];
    
    UIImageView * imageDLtext1 = [[UIImageView alloc] initWithFrame:CGRectMake(24, 71, 272, 29)];
    imageDLtext1.image = [UIImage imageNamed:@"TextField.png"];
    imageDLtext1.layer.masksToBounds = YES;
    imageDLtext1.layer.cornerRadius = 2.0f;
    imageDLtext1.layer.borderWidth = 0.5f;
    imageDLtext1.layer.borderColor = [[UIColor colorWithRed:0.722 green:0.537 blue:0.169 alpha:1.0] CGColor];
    [backGroundView addSubview:imageDLtext1];
    [imageDLtext1 release];
       
    UIImageView * imageDLtext2 = [[UIImageView alloc] initWithFrame:CGRectMake(24, 115, 272, 29)];
    imageDLtext2.image = [UIImage imageNamed:@"TextField.png"];
    imageDLtext2.layer.masksToBounds = YES;
    imageDLtext2.layer.cornerRadius = 2.0f;
    imageDLtext2.layer.borderWidth = 0.5f;
    imageDLtext2.layer.borderColor = [[UIColor colorWithRed:0.722 green:0.537 blue:0.169 alpha:1.0] CGColor];

    [backGroundView addSubview:imageDLtext2];
    [imageDLtext2 release];


    
	
	haslogin = FALSE;
	remoteNotification = TRUE;
	
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.frame = CGRectMake(272.5, 22.5, 35, 35);
    UIImageView * backButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close.png"]];
    backButtonView.frame = CGRectMake(7, 9, 20, 20);
    [backButton addSubview:backButtonView];
    [backButtonView release];
	[backButton addTarget:self action:@selector(backToNewsView) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
	[backGroundView addSubview:backButton];
	
	//用户名 以 及密码 输入框
	userNameTF = [[UITextField alloc] initWithFrame:CGRectMake(27, 71, 272, 29)];
	userNameTF.backgroundColor = [UIColor clearColor];
	userNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userNameTF.text = @"";
	userNameTF.borderStyle = UITextBorderStyleNone;
	userNameTF.placeholder = @" Email/手机号";
	userNameTF.keyboardType = UIKeyboardTypeEmailAddress;
    userNameTF.keyboardAppearance = UIKeyboardAppearanceAlert;
    userNameTF.returnKeyType = UIReturnKeyNext;
	userNameTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNameTF.tag = 1001;
    [userNameTF becomeFirstResponder];
    //userNameTF.secureTextEntry = YES;
    userNameTF.delegate = self;
    [backGroundView addSubview:userNameTF];
	
	passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(27, 115, 272, 29)];
	passwordTF.backgroundColor = [UIColor clearColor];
	passwordTF.text = @"";
    passwordTF.borderStyle = UITextBorderStyleNone;
	passwordTF.placeholder = @" 请输入密码";
	passwordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	passwordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordTF.keyboardAppearance = UIKeyboardAppearanceAlert;
    passwordTF.returnKeyType = UIReturnKeyJoin;
	passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTF.tag = 1002;
	passwordTF.secureTextEntry = YES;
	passwordTF.delegate = self;
	[backGroundView addSubview:passwordTF];
	
	
	//登录  忘记密码   注册
	UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
	loginButton.frame =CGRectMake(25, 159, 270, 35);
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [loginButton setTitle:@"登         录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage * d_m_image = [UIImage imageNamed:@"YellowButtonBig.png"];
    UIImage * loginBtuImage = [d_m_image stretchableImageWithLeftCapWidth:4.0f topCapHeight:0.0f];
    [loginButton setBackgroundImage:loginBtuImage forState:UIControlStateNormal];
    [loginButton setBackgroundImage:loginBtuImage forState:UIControlStateHighlighted];
    loginButton.showsTouchWhenHighlighted = YES;
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 3.0f;
    loginButton.layer.borderWidth = 0.2f;
	[loginButton addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
	[backGroundView addSubview:loginButton];
	
	UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
	forgetButton.frame = CGRectMake(25, 209, 130, 30);
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [forgetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage * forgerBtuImage = [[UIImage imageNamed:@"GrayButton_mid.png"] stretchableImageWithLeftCapWidth:4.0f topCapHeight:0.0f];
    [forgetButton setBackgroundImage:forgerBtuImage forState:UIControlStateNormal];
	[forgetButton setBackgroundImage:forgerBtuImage forState:UIControlStateHighlighted];
    forgetButton.showsTouchWhenHighlighted = YES;
    forgetButton.layer.masksToBounds = YES;
    forgetButton.layer.cornerRadius = 3.0f;
    forgetButton.layer.borderWidth = 0.2f;
	[forgetButton addTarget:self action:@selector(doForgetPassword) forControlEvents:UIControlEventTouchUpInside];
	[backGroundView addSubview:forgetButton];
	
	UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	registerButton.frame = CGRectMake(167, 209, 130, 30);
    registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [registerButton setTitle:@"注 册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage * registerBtuImage = [[UIImage imageNamed:@"GrayButton_mid.png"] stretchableImageWithLeftCapWidth:4.0f topCapHeight:0.0f];
    [registerButton setBackgroundImage:registerBtuImage forState:UIControlStateNormal];
	[registerButton setBackgroundImage:registerBtuImage forState:UIControlStateHighlighted];
    registerButton.showsTouchWhenHighlighted = YES;
    registerButton.layer.masksToBounds = YES;
    registerButton.layer.cornerRadius = 3.0f;
    registerButton.layer.borderWidth = 0.2f;                              
	[registerButton addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
	[backGroundView addSubview:registerButton];
	
	UIImageView *bottomImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, 288, 270, 158)];
	bottomImg.image = [UIImage imageNamed:@"LoginBottomImg.png"];
	//[loginView addSubview:bottomImg];
	[bottomImg release];
	
	[self readUserName];
	
	self.view = loginView;
	[loginView release];
    
//    MyAccountViewController * myAccountVC = [[MyAccountViewController alloc] init];
//    self.MyAcountDelegate = myAccountVC;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"in  RootViewController viewWillAppear  %s",__FUNCTION__);
    [userNameTF becomeFirstResponder];
}

#pragma mark -
#pragma mark 登录  忘记密码  注册 方法
-(void) keyBoardReturn
{
	if([userNameTF isFirstResponder])
	{
		[userNameTF resignFirstResponder];
	}
	if([passwordTF isFirstResponder])
	{
		[passwordTF resignFirstResponder];
	}
}


-(void) doLogin
{
	[self keyBoardReturn];
	//userNameTF.text = ACCOUNT;				//以后去掉这两行
	//passwordTF.text = PASSWORD;
	
	NSString *userName = [Trim trim:userNameTF.text];
	NSString *password = [Trim trim:passwordTF.text];
	if([userName length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"用户名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([password length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		OnlyAccount *account = [OnlyAccount defaultAccount];
		account.account = userName;
		account.password = password;
		ShangPinAppDelegate *shangPin = (ShangPinAppDelegate *)[[UIApplication sharedApplication] delegate];
		shangPin.userName = account.account;
		shangPin.password = account.password;
		if(remoteNotification == TRUE)
		{
			remoteNotification = FALSE;
			[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
			[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
		}
		[self saveUserName];
		
		NSString *parameters = [NSString stringWithFormat:@"%@|%@|0",userName,password];
		NSString *encodedString = [URLEncode encodeUrlStr:parameters];
		NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
		NSString *loginUrlStr = [NSString stringWithFormat:@"%@=Login&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
		NSLog(@"登录接口:%@",loginUrlStr);
		
		NSURL *loginUrl = [[NSURL alloc] initWithString:loginUrlStr];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:loginUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		[self.view addSubview:loadingView];
		loginConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[request release];
		[loginUrl release];
        
	}
	
}

-(void) doForgetPassword
{
	[self keyBoardReturn];
    passwordTF.text = nil;
	if(forgetPasswordVC == nil)
	{
		forgetPasswordVC = [[ForgetPasswordViewController alloc] init];
	}
	[self.view addSubview:forgetPasswordVC.view];
    [forgetPasswordVC.emailTF becomeFirstResponder];
}

-(void) doRegister
{
	[self keyBoardReturn];
	passwordTF.text = nil;
    if(registerVC == nil)
	{
		registerVC = [RegisterViewController defaultRegisterViewController];
        //[registerVC.emailTF becomeFirstResponder];
	}
	[self.view addSubview:registerVC.view];
	[registerVC.emailTF becomeFirstResponder];
}

-(void)getAccountInfo	//读取账户信息－真实姓名
{
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@",account.account];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	NSString *myAccountStr = [NSString stringWithFormat:@"%@=MyAccount&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"我的账户:%@",myAccountStr);
	NSURL *myAccountUrl = [[NSURL alloc] initWithString:myAccountStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:myAccountUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[self.view addSubview:loadingView];
	myAccountConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[myAccountUrl release];
}


#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response //当连接已收到足够的数据来构建其请求的URL的响应发送。
{
	NSLog(@"登录请求 获得服务器 回应");
    NSMutableData * rData = [[NSMutableData alloc] init];
    self.receivedData = rData;
    [rData release];
	[self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data  //连接逐步加载数据
{
	NSLog(@"接收到 数据");
	[self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection  //在成功完成加载连接时发送。
{
	NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	
	if(connection == loginConnection)
	{
		NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
        //NSLog(@"receivedData=%@",str);
		char flag = [str characterAtIndex:0];
		if(flag == '1')
		{
			[MobClick event:@"login"];
           // [self loginSuccessNotice];
            [self getAccountInfo];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"用户名或者密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		[loginConnection release];
	}
	
	if(connection == myAccountConnection)
	{
		NSLog(@"%s",__FUNCTION__);
        NSError *error = nil;
		GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
		if(error)
		{
			[document release];
			[myAccountConnection release];
			return;
		}
		GDataXMLElement *root = [document rootElement];
		GDataXMLElement *name = [[root elementsForName:@"name"] objectAtIndex:0];	//用户名
		
		OnlyAccount *account = [OnlyAccount defaultAccount];
		
        GDataXMLElement * gender = [[root elementsForName:@"gender"] objectAtIndex:0];   //用户性别
        account.gender = [gender stringValue];
        NSLog(@"用户性别 ：%@",account.gender);
        
        account.realName = [name stringValue];		
		NSLog(@"real name : %@",account.realName);
		[myAccountConnection release];
		[document release];
		[self dismissModalViewControllerAnimated:NO];
		haslogin = YES;
		[delegate didLoginSucess];
         [MyAcountDelegate loadMyAcountData];
	}
	passwordTF.text = nil;
	self.receivedData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error  //连接时未能成功加载其请求时调用。
{
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	[connection release];
	
    passwordTF.text = nil;
    self.receivedData = nil;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
//未使用
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
	{
        [self getAccountInfo];
	}
}

#pragma mark -
#pragma mark 释放相关
- (void)dealloc 
{
	[userNameTF release];
	[passwordTF release];
	self.receivedData = nil;
	
	if(forgetPasswordVC)
	{
		[forgetPasswordVC release];
	}
	if(registerVC)
	{
		[registerVC release];
	}
	
    [super dealloc];
}


@end
