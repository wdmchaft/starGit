    //
//  EditPasswordViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditPasswordViewController.h"


@implementation EditPasswordViewController
@synthesize receivedData;


#pragma mark -
#pragma mark 键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

-(void) keyboardReturn
{
	if([originPasswordTF isFirstResponder])
	{
		[originPasswordTF resignFirstResponder];
	}
	if([newPasswordTF isFirstResponder])
	{
		[newPasswordTF resignFirstResponder];
	}
	if([commitPwdTF isFirstResponder])
	{
		[commitPwdTF resignFirstResponder];
	}
}


#pragma mark -
#pragma mark 返回 我的账户界面-个人信息
- (void)returnBack
{
	[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark 初始化

- (void)loadView
{
	//返回按钮
//	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	backButton.frame = CGRectMake(0, 0, 53, 29);
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [backButton setTitle:@" 返回" forState:UIControlStateNormal];
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

    
    UIBarButtonItem *saveBI = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(doSave)];
	self.navigationItem.rightBarButtonItem = saveBI;
    [saveBI release];
	
	UIView *editPasswordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	editPasswordView.backgroundColor = [UIColor blackColor];
	
	self.title = @"修改密码";
	
	//原始密码
	UILabel *originPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, 80, 35)];
	originPasswordLabel.backgroundColor = [UIColor clearColor];
	originPasswordLabel.text = @"原始密码:";
	originPasswordLabel.textColor = WORDCOLOR;
	[editPasswordView addSubview:originPasswordLabel];
	[originPasswordLabel release];
	UIImageView *originPwdImgV = [[UIImageView alloc] initWithFrame:CGRectMake(90, 25, 220, 27)];
	originPwdImgV.image = [UIImage imageNamed:@"EditPasswordTF.png"];
	[editPasswordView addSubview:originPwdImgV];
	[originPwdImgV release];
	originPasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 27, 210, 26)];
	originPasswordTF.backgroundColor = [UIColor clearColor];
	originPasswordTF.borderStyle = UITextBorderStyleNone;
	originPasswordTF.textColor = WORDCOLOR;
	originPasswordTF.text = @"";
	originPasswordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	originPasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	originPasswordTF.secureTextEntry = YES;
	originPasswordTF.delegate = self;
	[editPasswordView addSubview:originPasswordTF];
	//新密码
	UILabel *newPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 67, 80, 26)];
	newPasswordLabel.backgroundColor = [UIColor clearColor];
	newPasswordLabel.textColor = WORDCOLOR;
	newPasswordLabel.text = @"新密码:";
	[editPasswordView addSubview:newPasswordLabel];
	[newPasswordLabel release];
	UIImageView *newPasswordImgV = [[UIImageView alloc] initWithFrame:CGRectMake(90, 70, 220, 27)];
	newPasswordImgV.image = [UIImage imageNamed:@"EditPasswordTF.png"];
	[editPasswordView addSubview:newPasswordImgV];
	[newPasswordImgV release];
	newPasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 72, 210, 26)];
	newPasswordTF.backgroundColor = [UIColor clearColor];
	newPasswordTF.borderStyle = UITextBorderStyleNone;
	newPasswordTF.textColor = WORDCOLOR;
	newPasswordTF.text = @"";
	newPasswordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	newPasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	newPasswordTF.secureTextEntry = YES;
	newPasswordTF.delegate = self;
	[editPasswordView addSubview:newPasswordTF];
	//确认密码
	UILabel *commitPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 112, 90, 35)];
	commitPasswordLabel.backgroundColor = [UIColor clearColor];
	commitPasswordLabel.textColor = WORDCOLOR;
	commitPasswordLabel.text = @"确认密码:";
	[editPasswordView addSubview:commitPasswordLabel];
	[commitPasswordLabel release];
	UIImageView *commitPasswordImgV = [[UIImageView alloc] initWithFrame:CGRectMake(90, 116, 220, 27)];
	commitPasswordImgV.image = [UIImage imageNamed:@"EditPasswordTF.png"];
	[editPasswordView addSubview:commitPasswordImgV];
	[commitPasswordImgV release];
	commitPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 118, 210, 26)];
	commitPwdTF.backgroundColor = [UIColor clearColor];
	commitPwdTF.borderStyle = UITextBorderStyleNone;
	commitPwdTF.textColor = WORDCOLOR;
	commitPwdTF.text = @"";
	commitPwdTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	commitPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	commitPwdTF.secureTextEntry = YES;
	commitPwdTF.delegate = self;
	[editPasswordView addSubview:commitPwdTF];
	
	self.view = editPasswordView;
	[editPasswordView release];
}

#pragma mark -
#pragma mark 保存
-(void) doSave
{
	[self keyboardReturn];
	NSString *originPassword = [Trim trim:originPasswordTF.text];
	NSString *newPassword = [Trim trim:newPasswordTF.text];
	NSString *commitPassword = [Trim trim:commitPwdTF.text];
	if(([originPassword length] == 0) || ([newPassword length] == 0) || ([commitPassword length] == 0))
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请填写全部信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([newPassword isEqualToString:commitPassword] == NO)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"新密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		self.navigationItem.leftBarButtonItem.enabled = NO;
		self.navigationItem.rightBarButtonItem.enabled = NO;
		OnlyAccount *account = [OnlyAccount defaultAccount];
		NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@",account.account,newPassword,originPassword];
		NSString *encodedString = [URLEncode encodeUrlStr:parameters];
		NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
		
		[MobClick event:@"ModifyPassword"];
		
		NSString *modifyPassword = [NSString stringWithFormat:@"%@=ModifyPassword&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
		NSLog(@"修改密码:%@",modifyPassword);
		NSURL *modifyPasswordUrl = [[NSURL alloc] initWithString:modifyPassword];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:modifyPasswordUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
		[self.view addSubview:loadingView];
		editPwdConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[request release];
		[modifyPasswordUrl release];
	}
}

#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"修改密码 获得服务器 回应");
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
	NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	
	NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
	char flag = [str characterAtIndex:0];
	if(flag == '1')
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"密码修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改失败,请查证后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	[editPwdConnection release];
	self.receivedData = nil;
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	[editPwdConnection release];
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
		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark -
#pragma mark 释放相关
- (void)dealloc 
{
	[originPasswordTF release];
	[newPasswordTF release];
	[commitPwdTF release];
	self.receivedData = nil;
    [super dealloc];
}


@end
