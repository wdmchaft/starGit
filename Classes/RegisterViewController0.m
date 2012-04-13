    //
//  Register.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController0.h"
#import "ShangPinAppDelegate.h"
#import "LogInViewController.h"
#import "GDataXMLNode.h"
#include <unistd.h>

@implementation RegisterViewController0
@synthesize emailTF;
@synthesize receivedData;

#pragma mark -
#pragma mark 键盘回收

-(void)keyboardReturn
{
	[UIView beginAnimations:@"scroll" context:nil];
	[UIView setAnimationDuration:0.25];
	CGRect frame = CGRectMake(0, 0, 320, 480);
	self.view.frame = frame;
	[UIView commitAnimations];
	if([emailTF isFirstResponder])
	{
		[emailTF resignFirstResponder];
	}
	if([setPasswordTF isFirstResponder])
	{
		[setPasswordTF resignFirstResponder];
	}
	if([commitPasswordTF isFirstResponder])
	{
		[commitPasswordTF resignFirstResponder];
	}
	if([realNameTF isFirstResponder])
	{
		[realNameTF resignFirstResponder];
	}
	if([mobileTF isFirstResponder])
	{
		[mobileTF resignFirstResponder];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[UIView beginAnimations:@"scroll" context:nil];
	[UIView setAnimationDuration:0.25];
    CGRect frame = CGRectMake(0, 0, 320, 480);
	self.view.frame = frame;
	[UIView commitAnimations];
	[textField resignFirstResponder];
	return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	[UIView beginAnimations:@"scroll" context:nil];
	[UIView setAnimationDuration:0.25];
	CGRect frame = CGRectMake(0, -(textField.frame.origin.y -124), 320, 480);
	self.view.frame = frame; 
	[UIView commitAnimations];
	return YES;
}

#pragma mark -
#pragma mark 性别选择   是否接受条款   是否接收售卖通知
-(void) doChooseGender:(UIButton *)choosedButton		//设置性别
{
	int flag = choosedButton.tag;
	if(flag == 100) //性别为男
	{
		maleSelectedImgV.hidden = NO;
		femaleSelectedImgV.hidden = YES;
		//defaultGenderImgV.hidden = YES;
		isMale = YES;
		//gender = 0;
	}
	else //if(flag == 101)		//性别为女
	{
		maleSelectedImgV.hidden = YES;
		femaleSelectedImgV.hidden = NO;
		//defaultGenderImgV.hidden = YES;
		isMale = NO;
		//gender = 1;
	}
	//else
//	{
//		maleSelectedImgV.hidden = YES;
//		femaleSelectedImgV.hidden = YES;
//		defaultGenderImgV.hidden = NO;
//		//isMale = YES;
//		gender = -1;
//	}
	[self keyboardReturn];
	NSLog(@"gender:%d",isMale);
}

-(void) doConformClause			//是否接受条款
{
	if(conformClause)
	{
		clauseImgV.hidden = YES;
		conformClause = NO;
	}
	else
	{
		clauseImgV.hidden = NO;
		conformClause = YES;
	}
	[self keyboardReturn];
	NSLog(@"conformClause = %d",conformClause);
}

-(void) doSoldNotice			//是否接尚品售卖收邮件通知
{
	if(soldNotice)
	{
		soldNoticeImgV.hidden = YES;
		soldNotice = NO;
	}
	else
	{
		soldNoticeImgV.hidden = NO;
		soldNotice = YES;
	}
	[self keyboardReturn];
	NSLog(@"soldNotice = %d",soldNotice);
}

#pragma mark -
#pragma mark 返回登录界面
-(void) backToLoginView
{
	[self.view removeFromSuperview];
}


#pragma mark -
#pragma mark 初始化

static RegisterViewController0 *registerVC = nil;
+(RegisterViewController0 *) defaultRegisterViewController
{
	if(registerVC == nil)
	{
		registerVC = [[RegisterViewController0 alloc] init];
	}
	return registerVC;
}


- (void)loadView 
{
	maxConnectionCount = 5;
	
	UIView *registerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	imageView.image = [UIImage imageNamed:@"RegisterBG.png"];
	[registerView addSubview:imageView];
	[imageView release];
	remoteNotification = TRUE;
	//registerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RegisterBG.png"]];
	
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.frame = CGRectMake(260, 76, 30, 30);
	[backButton setBackgroundImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backToLoginView) forControlEvents:UIControlEventTouchUpInside];
	[registerView addSubview:backButton];
	
	//电子邮箱  设置密码  确认密码  真实姓名  手机号码
	emailTF = [[UITextField alloc] initWithFrame:CGRectMake(105, 124, 184, 24)];
	emailTF.backgroundColor = [UIColor clearColor];
    emailTF.text = @"";
	emailTF.borderStyle = UITextBorderStyleNone;
	emailTF.keyboardType = UIKeyboardTypeEmailAddress;
	emailTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	emailTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	emailTF.delegate = self;
	emailTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	[registerView addSubview:emailTF];
	
	setPasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(105, 163, 184, 24)];
	setPasswordTF.backgroundColor = [UIColor clearColor];
	setPasswordTF.text = @"";
	setPasswordTF.borderStyle = UITextBorderStyleNone;
	setPasswordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	setPasswordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	setPasswordTF.secureTextEntry = YES;
	setPasswordTF.delegate = self;
	setPasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	[registerView addSubview:setPasswordTF];
	
	commitPasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(105, 202, 184, 24)];
	commitPasswordTF.backgroundColor = [UIColor clearColor];
	commitPasswordTF.text = @"";
	commitPasswordTF.borderStyle = UITextBorderStyleNone;
	commitPasswordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	commitPasswordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	commitPasswordTF.delegate = self;
	commitPasswordTF.secureTextEntry = TRUE;
	commitPasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	[registerView addSubview:commitPasswordTF];
	
	realNameTF = [[UITextField alloc] initWithFrame:CGRectMake(105, 241, 184, 24)];
	realNameTF.backgroundColor = [UIColor clearColor];
	realNameTF.text = @"";
	realNameTF.borderStyle = UITextBorderStyleNone;
	realNameTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	realNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	realNameTF.delegate = self;
	realNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	[registerView addSubview:realNameTF];
	
	mobileTF = [[UITextField alloc] initWithFrame:CGRectMake(105, 280, 184, 24)];
	mobileTF.backgroundColor = [UIColor clearColor];
	mobileTF.text = @"";
	mobileTF.borderStyle = UITextBorderStyleNone;
	mobileTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	mobileTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	mobileTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	mobileTF.delegate = self;
	mobileTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	[registerView addSubview:mobileTF];
	
	//性别选择
	isMale = TRUE;
	NSLog(@"isMale = %d",isMale);
	//gender = -1;
	
	maleSelectedImgV = [[UIImageView alloc] initWithFrame:CGRectMake(97, 319.5, 14, 15)];
	maleSelectedImgV.image = [UIImage imageNamed:@"Dot.png"];
	[registerView addSubview:maleSelectedImgV];
	maleSelectedImgV.hidden = NO;
	UIButton *maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
	maleButton.frame = CGRectMake(95, 315, 55, 25);
	maleButton.tag = 100;
	[maleButton addTarget:self action:@selector(doChooseGender:) forControlEvents:UIControlEventTouchUpInside];
	[registerView addSubview:maleButton];
	
	femaleSelectedImgV = [[UIImageView alloc] initWithFrame:CGRectMake(156, 319.5, 14, 15)];
	femaleSelectedImgV.image = [UIImage imageNamed:@"Dot.png"];
	[registerView addSubview:femaleSelectedImgV];
	femaleSelectedImgV.hidden = YES;
	UIButton *femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
	femaleButton.frame = CGRectMake(154, 315, 55, 25);
	femaleButton.tag = 101;
	[femaleButton addTarget:self action:@selector(doChooseGender:) forControlEvents:UIControlEventTouchUpInside];
	[registerView addSubview:femaleButton];
	
	
	//是否同意接受条款
	conformClause = YES;
	
	clauseImgV = [[UIImageView alloc] initWithFrame:CGRectMake(27, 348, 14, 14)];
	clauseImgV.image = [UIImage imageNamed:@"CheckMark.png"];
	[registerView addSubview:clauseImgV];
	
	UIButton *conformClauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	conformClauseButton.frame = CGRectMake(25, 345, 190, 20);
	[conformClauseButton addTarget:self action:@selector(doConformClause) forControlEvents:UIControlEventTouchUpInside];
	[registerView addSubview:conformClauseButton];

	
	//是否同意接收售卖通知
	soldNotice = YES;
	soldNoticeImgV = [[UIImageView alloc] initWithFrame:CGRectMake(27, 373, 14, 14)];
	soldNoticeImgV.image = [UIImage imageNamed:@"CheckMark.png"];
	[registerView addSubview:soldNoticeImgV];
	
	UIButton *soldNoticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	soldNoticeButton.frame = CGRectMake(25, 370, 215, 20);
	[soldNoticeButton addTarget:self action:@selector(doSoldNotice) forControlEvents:UIControlEventTouchUpInside];
	[registerView addSubview:soldNoticeButton];
	
	//阅读条款按钮   立即注册按钮
	UIButton *readButton = [UIButton buttonWithType:UIButtonTypeCustom];
	readButton.frame = CGRectMake(224, 345, 47, 20);
    readButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [readButton setTitle:@"阅读" forState:UIControlStateNormal];
    [readButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [readButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
	[readButton setBackgroundImage:[UIImage imageNamed:@"ReadNormal.png"] forState:UIControlStateNormal];
	[readButton setBackgroundImage:[UIImage imageNamed:@"ReadClick.png"] forState:UIControlStateHighlighted];
	[readButton addTarget:self action:@selector(doRead) forControlEvents:UIControlEventTouchUpInside];
	[registerView addSubview:readButton];
	
	UIButton *registerNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
	registerNowButton.frame = CGRectMake(30, 397, 260, 30);
	[registerNowButton setBackgroundImage:[UIImage imageNamed:@"RegisterNowNormal.png"] forState:UIControlStateNormal];
	[registerNowButton setBackgroundImage:[UIImage imageNamed:@"RegisterNowClick.png"] forState:UIControlStateHighlighted];
	[registerNowButton addTarget:self action:@selector(doRegisterNow) forControlEvents:UIControlEventTouchUpInside];
	[registerView addSubview:registerNowButton];
	
	self.view = registerView;
	[registerView release];
}

#pragma mark -
#pragma mark 阅读条款   立即这册

-(void) doRead
{
	[self keyboardReturn];
	if(clauseView == nil)
	{
		clauseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
		clauseView.backgroundColor = [UIColor blackColor];
		UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 290, 423)];
		imgV.image = [UIImage imageNamed:@"Clause.png"];
		[clauseView addSubview:imgV];
		[imgV release];
		
		UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		closeButton.frame = CGRectMake(260, 3, 30, 30);
		[closeButton setBackgroundImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
		[closeButton addTarget:self action:@selector(closeClause) forControlEvents:UIControlEventTouchUpInside];
		[clauseView addSubview:closeButton];
		
		UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(17, 40, 285, 380)];
		textView.editable = NO;
		textView.backgroundColor = [UIColor clearColor];
		textView.text = CLAUSE;
		[clauseView addSubview:textView];
		[textView release];
	}
	[self.view addSubview:clauseView];
}

-(void) closeClause
{
	[clauseView removeFromSuperview];
}

-(BOOL) validatePhone:(NSString*) aString
{
	NSString *phoneRegex = @"(1[0-9]{10})";
	NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];   
	return [phoneTest evaluateWithObject:aString];  
}

-(void) doRegisterNow
{
	[self keyboardReturn];	
	
	if(conformClause)
	{
		NSString *email = [Trim trim:emailTF.text];
		NSString *setPassword = [Trim trim:setPasswordTF.text];
		NSString *commitPassword = [Trim trim:commitPasswordTF.text];
		NSString *realName = [Trim trim:realNameTF.text];
		NSString *mobile = [Trim trim:mobileTF.text];
		
		if(([email length] == 0) || ([setPassword length] == 0) || ([commitPassword length] == 0) || ([realName length] == 0) || ([mobile length] == 0))
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写全部注册信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else if([setPassword isEqualToString:commitPassword] == NO)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else if([self validatePhone:mobile] == FALSE)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"手机号码不符合要求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}		
		else
		{
			NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@|%@|%d|%d",email,setPassword,realName,mobile,isMale/*gender*/,soldNotice];
			NSString *encodedString = [URLEncode encodeUrlStr:parameters];
            NSLog(@"str = %@",encodedString);
			NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
			NSString *registerlUrlStr = [NSString stringWithFormat:@"%@=Register&parameters=%@&md5=%@&u=&w=",ADDRESS,encodedString,md5Str];
			NSLog(@"注册:%@",registerlUrlStr);
			
			NSURL *registerlUrl = [[NSURL alloc] initWithString:registerlUrlStr];
			NSURLRequest *request = [[NSURLRequest alloc] initWithURL:registerlUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
			loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
			[self.view addSubview:loadingView];
			registerConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
			[request release];
			[registerlUrl release];
		}
		
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您必须遵守条款才能注册成为尚品会员" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
		
}

-(void)getAccountInfo
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
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"注册请求 获得服务器 回应");
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
	NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	
	if(connection == registerConnection)
	{
		[registerConnection release];
		NSError *error = nil;
		GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
		if(error)
		{
			[document release];
			return;
		}
		
		GDataXMLElement *root = [document rootElement];
		NSString *str = [root stringValue];
        NSLog(@"%@",str);
		if([str isEqualToString:@"1"])
		{
			[MobClick event:@"Register"];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"欢迎您成为尚品会员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		[document release];
	}
	if(connection == loginConnection)
	{
		[loginConnection release];
		
		NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
		
		char flag = [str characterAtIndex:0];
		if(flag == '1')
		{
			[self getAccountInfo];
		}
		else
		{
			if(maxConnectionCount > 0)
			{
				maxConnectionCount --;
				[self doLogin];
			}
			else
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"自动登录超时，请手动登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		}
	}
	
	if(connection == myAccountConnection)
	{
		[myAccountConnection release];
		NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
		char flag = [str characterAtIndex:0];
		if(flag == '-')
		{
			usleep(500000);
			[self getAccountInfo];
		}
		else 
		{
			NSError *error = nil;
			GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
			
			if(error)
			{
				[document release];
				return;
			}
			GDataXMLElement *root = [document rootElement];
			GDataXMLElement *name = [[root elementsForName:@"name"] objectAtIndex:0];	//用户名
			
			OnlyAccount *account = [OnlyAccount defaultAccount];
			account.realName = [name stringValue];
			
			NSLog(@"real name : %@",account.realName);
			[document release];
			
			LogInViewController *loginViewController = [LogInViewController defaultLoginViewController];
			[self.view removeFromSuperview];
			[loginViewController dismissModalViewControllerAnimated:NO];
			loginViewController.haslogin = YES;
			[loginViewController.delegate didLoginSucess];
		}
		
	}
	
	
	self.receivedData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	[connection release];
	self.receivedData = nil;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}


#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
	{
		[self doLogin];
	}
}

#pragma mark -
#pragma mark 数据存储
-(void) saveUserName
{
	NSString *email = emailTF.text;
	NSString *password = commitPasswordTF.text;
	NSArray *m_array = [[NSArray alloc] initWithObjects:email,password,nil];
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]; 
	NSString *filename = [path stringByAppendingPathComponent:@"userEmail"];
	[NSKeyedArchiver archiveRootObject:m_array toFile:filename];
	[m_array release];
}
#pragma mark -
#pragma mark 登录
-(void) doLogin
{
	OnlyAccount *account = [OnlyAccount defaultAccount];
	account.account = emailTF.text;
	account.password = commitPasswordTF.text;
	ShangPinAppDelegate *shangPin = (ShangPinAppDelegate *)[UIApplication sharedApplication].delegate;
	shangPin.userName = account.account;
	shangPin.password = account.password;
	if(remoteNotification == TRUE)
	{
		remoteNotification = FALSE;
		[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	}
	[self saveUserName];
	
	NSString *parameters = [NSString stringWithFormat:@"%@|%@|0",emailTF.text,commitPasswordTF.text];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	NSString *loginUrlStr = [NSString stringWithFormat:@"%@=Login&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"登录接口:%@",loginUrlStr);
	
	NSURL *loginUrl = [[NSURL alloc] initWithString:loginUrlStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:loginUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:loadingView];
	loginConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[request release];
	[loginUrl release];
}


#pragma mark -
#pragma mark 释放相关

- (void)dealloc 
{
	[emailTF release];
	[setPasswordTF release];
	[commitPasswordTF release];
	[realNameTF release];
	[mobileTF release];
	
	[maleSelectedImgV release];
	[femaleSelectedImgV release];
	
	[clauseImgV release];
	[soldNoticeImgV release];
	self.receivedData = nil;
	[clauseView release];
    [super dealloc];
}


@end
