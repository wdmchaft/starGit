    //
//  ForgetPasswordViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ForgetPasswordViewController.h"


@implementation ForgetPasswordViewController
@synthesize receivedData;

#pragma mark -
#pragma mark 键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


#pragma mark -
#pragma mark 初始化方法
- (void)loadView 
{
	UIView *forgetPasswordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	UIImageView * imageBJ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    imageBJ.image = [UIImage imageNamed:@"AllowBackground.jpg"];
    [forgetPasswordView addSubview:imageBJ];
    [imageBJ release];
	
    //登录窗口
    UIImageView * imageDL = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 300, 235)];
    imageDL.image = [UIImage imageNamed:@"Layer_DownRound.png"];
    imageDL.layer.masksToBounds = YES;
    imageDL.layer.cornerRadius = 6.0f;
    [forgetPasswordView addSubview:imageDL];
    [imageDL release];
    
    UIImageView * imageDLtitle = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 300, 35)];
    imageDLtitle.image = [UIImage imageNamed:@"AllowTitle.png"];
    UILabel * imageDLtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 300, 35)];
    imageDLtitleLabel.backgroundColor = [UIColor clearColor];
    imageDLtitleLabel.text = @"忘 记 密 码";
    imageDLtitleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    imageDLtitleLabel.textAlignment = UITextAlignmentCenter;
    imageDLtitleLabel.textColor = [UIColor whiteColor];
    [forgetPasswordView addSubview:imageDLtitle];
    [forgetPasswordView addSubview:imageDLtitleLabel];
    [imageDLtitle release];
    [imageDLtitleLabel release];
    
    UIImageView * imageDLtext1 = [[UIImageView alloc] initWithFrame:CGRectMake(24, 71, 272, 29)];
    imageDLtext1.image = [UIImage imageNamed:@"TextField.png"];
    imageDLtext1.layer.masksToBounds = YES;
    imageDLtext1.layer.cornerRadius = 2.0f;
    imageDLtext1.layer.borderWidth = 0.5f;
    imageDLtext1.layer.borderColor = [[UIColor colorWithRed:0.722 green:0.537 blue:0.169 alpha:1.0] CGColor];

    [forgetPasswordView addSubview:imageDLtext1];
    [imageDLtext1 release];

	
	//用户名 以 及密码 输入框
	
    emailTF = [[UITextField alloc] initWithFrame:CGRectMake(30, 73, 272, 29)];
	emailTF.backgroundColor = [UIColor clearColor];
	emailTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailTF.text = @"";
    emailTF.font = [UIFont systemFontOfSize:14.0f];
	emailTF.borderStyle = UITextBorderStyleNone;
	emailTF.placeholder = @" 注册时的Email";
	emailTF.keyboardType = UIKeyboardTypeEmailAddress;
    emailTF.keyboardAppearance = UIKeyboardAppearanceAlert;
    emailTF.returnKeyType = UIReturnKeyDone;
	emailTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	//emailTF.secureTextEntry = YES;
    emailTF.delegate = self;
	emailTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	[forgetPasswordView addSubview:emailTF];
	
	
	
	//登录  忘记密码   注册
	UIButton *getBackPassWordButton = [UIButton buttonWithType:UIButtonTypeCustom];
	getBackPassWordButton.frame =CGRectMake(25, 159, 270, 35);
    getBackPassWordButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [getBackPassWordButton setTitle:@"找回密码" forState:UIControlStateNormal];
    [getBackPassWordButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [getBackPassWordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage * d_m_image = [UIImage imageNamed:@"YellowButtonBig.png"];
    UIImage * getBackBtuImage = [d_m_image stretchableImageWithLeftCapWidth:4.0f topCapHeight:0.0f];
    [getBackPassWordButton setBackgroundImage:getBackBtuImage forState:UIControlStateNormal];
    [getBackPassWordButton setBackgroundImage:getBackBtuImage forState:UIControlStateHighlighted];
    getBackPassWordButton.showsTouchWhenHighlighted = YES;
    getBackPassWordButton.layer.masksToBounds = YES;
    getBackPassWordButton.layer.cornerRadius = 3.0f;
    getBackPassWordButton.layer.borderWidth = 0.2f;
	[getBackPassWordButton addTarget:self action:@selector(getPassword) forControlEvents:UIControlEventTouchUpInside];
	[forgetPasswordView addSubview:getBackPassWordButton];
	
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.frame = CGRectMake(25, 209, 270, 30);
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage * forgerBtuImage = [[UIImage imageNamed:@"GrayButton_mid.png"] stretchableImageWithLeftCapWidth:4.0f topCapHeight:0.0f];
    [backButton setBackgroundImage:forgerBtuImage forState:UIControlStateNormal];
	[backButton setBackgroundImage:forgerBtuImage forState:UIControlStateHighlighted];
    backButton.showsTouchWhenHighlighted = YES;
    backButton.layer.masksToBounds = YES;
    backButton.layer.cornerRadius = 3.0f;
    backButton.layer.borderWidth = 0.2f;
	[backButton addTarget:self action:@selector(backToLoginView) forControlEvents:UIControlEventTouchUpInside];
	[forgetPasswordView addSubview:backButton];
	
	
	
  	self.view = forgetPasswordView;
	[forgetPasswordView release];
}

#pragma mark -
#pragma mark 找回密码 返回登录界面
-(void) keyBoardReturn
{
	if([emailTF isFirstResponder])
	{
		[emailTF resignFirstResponder];
	}
}

-(void) getPassword
{
	[self keyBoardReturn];
	//emailTF.text = ACCOUNT;
    NSString *email = [Trim trim:emailTF.text];
	if([email length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"邮箱不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		NSString *parameters = [NSString stringWithFormat:@"%@",email];
		NSString *encodedString = [URLEncode encodeUrlStr:parameters];
		NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
		NSString *getLostPasswordlUrlStr = [NSString stringWithFormat:@"%@=GetLostPassword&parameters=%@&md5=%@&u=&w=",ADDRESS,encodedString,md5Str];
		NSLog(@"找回密码:%@",getLostPasswordlUrlStr);
		
		NSURL *getLostPasswordlUrl = [[NSURL alloc] initWithString:getLostPasswordlUrlStr];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:getLostPasswordlUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
		[self.view addSubview:loadingView];
		getPasswordConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[request release];
		[getLostPasswordlUrl release];
	}
}

-(void) backToLoginView
{
    [self.view removeFromSuperview];
     emailTF.text = nil;
}

#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"登录请求 获得服务器 回应");
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
	
	NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
	char flag = [str characterAtIndex:0];
	if(flag == '1')
	{
		[MobClick event:@"GetLostPassword"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"密码已经发送到您的注册邮箱" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
        emailTF.text = nil;
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"找回密码失败,请检查邮箱是否正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	[getPasswordConnection release];
	self.receivedData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	[getPasswordConnection release];
	self.receivedData = nil;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
	{
		[self.view removeFromSuperview];
	}
}

#pragma mark -
#pragma mark 释放相关

- (void)dealloc 
{
	self.receivedData = nil;
	[emailTF release];
    [super dealloc];
}


@end
