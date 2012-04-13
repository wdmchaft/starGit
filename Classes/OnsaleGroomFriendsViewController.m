    //
//  LimitBuyGroomFriendsViewController.m
//  ShangPin
//
//  Created by ch_int_beam on 11-2-20.
//  Copyright 2011 Beyond. All rights reserved.
//

#import "OnsaleGroomFriendsViewController.h"
#import "ContactListViewController.h"

@implementation OnsaleGroomFriendsViewController
@synthesize infoArray;
@synthesize theNumbers;
@synthesize theNames;
@synthesize delegate;
@synthesize receivedData;

#pragma mark -
#pragma mark 键盘回收

-(void)keyboardReturn
{
	[UIView beginAnimations:@"scroll" context:nil];
	[UIView setAnimationDuration:0.25];
	CGRect frame = CGRectMake(0, 0, 320, 367);
	self.view.frame = frame;
	[UIView commitAnimations];
	if([note isFirstResponder])
	{
		[note resignFirstResponder];
	}
	if([mail isFirstResponder])
	{
		[mail resignFirstResponder];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[UIView beginAnimations:@"scroll" context:nil];
	[UIView setAnimationDuration:0.25];
	CGRect frame = CGRectMake(0, 0, 320, 367);
	self.view.frame = frame;
	[UIView commitAnimations];
	[textField resignFirstResponder];
	return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	[UIView beginAnimations:@"scroll" context:nil];
	[UIView setAnimationDuration:0.25];
	CGRect frame = CGRectMake(0, -(textField.frame.origin.y -127), 320, 367);
	self.view.frame = frame; 
	[UIView commitAnimations];
	return YES;
}


#pragma mark -
#pragma mark 短信推荐 邮箱推荐
-(BOOL) validatePhone:(NSString*) aString
{
	NSString *phoneRegex = @"(1[0-9]{10})((,)1[0-9]{10})*";
	//NSString *phoneRegex = @"(1[0-9]{10}(,)*)*(1[0-9]{10})*";
	NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];   
	return [phoneTest evaluateWithObject:aString];  
}
- (void)selectNumber
{
    NSString * numstr = note.text;
    NSArray * numstrArray = [numstr componentsSeparatedByString:@","];
    for (NSString * number in numstrArray) 
    {
        NSString *phoneRegex = @"(1[0-9]{0,10})((,)1[0-9]{0,10})*";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];   
        if ([phoneTest evaluateWithObject:number]) {
            self.theNumbers = [self.theNumbers stringByAppendingFormat:@",%@",number];
            NSLog(@"theNumber = %@",self.theNumbers);
        } 
        
    }
    
}


- (void)sendSMS
{
	[self keyboardReturn];
    [self selectNumber];
	if([remark isFirstResponder])
	{
		[remark resignFirstResponder];
	}
	//NSString *mobile = [Trim trim:note.text];
    NSString *mobiles = [Trim trim:[self theNumbers]];
	if([mobiles length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"至少要有一个手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([self validatePhone:mobiles] == FALSE)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"手机格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([remark.text length] > 60)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"发送文字过长,请保证60个字之内" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		self.navigationItem.leftBarButtonItem.enabled = NO;
		OnlyAccount *account = [OnlyAccount defaultAccount];
		//
		NSString *content = [NSString stringWithFormat:@"%@ 邀请您加入尚品网，%@",account.realName,remark.text];
		NSLog(@"content = %@",content);
		//
		NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@|%@|%@",account.account,[self.infoArray objectAtIndex:4],[self.infoArray objectAtIndex:5],mobiles,content];
		NSString *encodedString = [URLEncode encodeUrlStr:parameters];
		NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
		
		[MobClick event:[NSString stringWithFormat:@"SMSrecommend"] label:[NSString stringWithFormat:@"%@-%@",[self.infoArray objectAtIndex:4],[self.infoArray objectAtIndex:5]]];

		
		NSString *recfSMSStr = [NSString stringWithFormat:@"%@=Recommendfriends&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
		NSLog(@"短信推荐:%@",recfSMSStr);
		NSURL *recfSMSUrl = [[NSURL alloc] initWithString:recfSMSStr];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:recfSMSUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
		[self.view addSubview:loadingView];
		recfSMSConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[request release];
		[recfSMSUrl release];
	}
	
}

-(void) sendEmail
{
	[self keyboardReturn];
	if([remark isFirstResponder])
	{
		[remark resignFirstResponder];
	}
	NSString *emails = [Trim trim:mail.text];
	if([emails length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"至少要有一个Email地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([remark.text length] > 60)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"发送文字过长,请保证60个字之内" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		self.navigationItem.leftBarButtonItem.enabled = NO;
		OnlyAccount *account = [OnlyAccount defaultAccount];
		//
		NSString *content = [NSString stringWithFormat:@"%@ 邀请您加入尚品网，%@",account.realName,remark.text];
		NSLog(@"content = %@",content);
		//
		NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@|%@|%@",account.account,[self.infoArray objectAtIndex:4],[self.infoArray objectAtIndex:5],emails,content];
		NSString *encodedString = [URLEncode encodeUrlStr:parameters];
		NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
		
		[MobClick event:[NSString stringWithFormat:@"Emailrecommend"] label:[NSString stringWithFormat:@"%@-%@",[self.infoArray objectAtIndex:4],[self.infoArray objectAtIndex:5]]];

		
		NSString *recfEmailStr = [NSString stringWithFormat:@"%@=RecommendfriendsWithEmail&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
		NSLog(@"Email推荐好友:%@",recfEmailStr);
		NSURL *recfEmailUrl = [[NSURL alloc] initWithString:recfEmailStr];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:recfEmailUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
		[self.view addSubview:loadingView];
		recfEmailConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[request release];
		[recfEmailUrl release];
	}	
	
}

- (void)closeIt
{
	[self keyboardReturn];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 调用通讯录
- (void)addList
{
	[self keyboardReturn];
	ContactListViewController *clVC = [[ContactListViewController alloc] init];
	clVC.oGFVC = self;
	self.delegate = self;
	[self.navigationController pushViewController:clVC animated:YES];
	[clVC release];
}
//-(void) didFinishChoosePhoneNumber:(NSString *)thePhoneNumber
-(void) didFinishChoosePhoneNumberInvite:(NSArray *)thePhoneName
{
//	if([note.text length] != 0)
//	{
//		self.theNumbers = [NSString stringWithFormat:@"%@,%@",note.text,thePhoneNumber];
//	}
//	else
//	{
//		self.theNumbers = thePhoneNumber;
//	}
//	note.text = self.theNumbers;
        
    if([note.text length] != 0)
    {
        self.theNames = [NSString stringWithFormat:@"%@,%@",note.text,[thePhoneName objectAtIndex:0]];
        self.theNumbers = [NSString stringWithFormat:@"%@,%@",theNumbers,[thePhoneName objectAtIndex:1]];
    }
    else
    {
        self.theNames = [thePhoneName objectAtIndex:0];
        self.theNumbers = [thePhoneName objectAtIndex:1];
        
    }
    note.text = self.theNames;
    
    
}


#pragma mark -
#pragma mark 推荐给朋友 初始化
- (id)init
{
	self = [super init];
    if(self)
	{
		UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(closeIt)];
		self.navigationItem.leftBarButtonItem = left;
		[left release];
		self.navigationItem.title = @"推荐给好友";
		
		UIView *limitBuyListView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
		limitBuyListView.backgroundColor = [UIColor blackColor];
		
		//商品图片
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 66, 88)];
		imageView.backgroundColor = [UIColor whiteColor];
		[limitBuyListView addSubview:imageView];

		//商品标题
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 10.0f, 230.0f, 20.0f)];
		titleLabel.font = [UIFont systemFontOfSize:14.0f];
		titleLabel.textColor = WORDCOLOR;
		titleLabel.backgroundColor = [UIColor clearColor];
		[limitBuyListView addSubview:titleLabel];
		//专柜价
		shoppePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 30.0f, 200.0f, 20.0f)];
		shoppePriceLabel.text = @"专柜价:";
		shoppePriceLabel.font = [UIFont boldSystemFontOfSize:14.0f];
		shoppePriceLabel.textColor = [UIColor whiteColor];;
		shoppePriceLabel.backgroundColor = [UIColor clearColor];
		[limitBuyListView addSubview:shoppePriceLabel];
		//贯穿线
		lineThrough = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 40.0f, 100, 1.0f)];
		lineThrough.backgroundColor = [UIColor grayColor];
		[limitBuyListView addSubview:lineThrough];
		//限时价
		VIPLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 50.0f, 200.0f, 20.0f)];
		VIPLabel.text = @"限时价:";
		VIPLabel.font = [UIFont boldSystemFontOfSize:14.0f];
		VIPLabel.textColor = [UIColor whiteColor];;
		VIPLabel.backgroundColor = [UIColor clearColor];
		[limitBuyListView addSubview:VIPLabel];
		
		UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 98, 320, 309)];
		image.image = [UIImage imageNamed:@"groomFriends.png"];
		[limitBuyListView addSubview:image];
		[image release];
		
		UIButton *addList = [UIButton buttonWithType:UIButtonTypeCustom];
		addList.frame = CGRectMake(125, 97, 56, 35);
        addList.titleLabel.font = [UIFont systemFontOfSize:11];
        [addList setTitle:@"   通讯录" forState:UIControlStateNormal];
        [addList setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; 
		[addList setBackgroundImage:[UIImage imageNamed:@"ContactNormal.png"] forState:UIControlStateNormal];
		[addList setBackgroundImage:[UIImage imageNamed:@"ContractClick.png"] forState:UIControlStateHighlighted];
		[addList addTarget:self action:@selector(addList) forControlEvents:UIControlEventTouchUpInside];
		[limitBuyListView addSubview:addList];
		//电话号码
		note = [[UITextField alloc] initWithFrame:CGRectMake(10, 127, 240, 26.0f)];
		note.placeholder = @"多个电话号码请以逗号分隔";
		note.delegate =self;
		note.backgroundColor = [UIColor clearColor];
		note.text = @"";
		note.textColor = WORDCOLOR;
		note.borderStyle = UITextBorderStyleNone;
        note.keyboardAppearance = UIKeyboardAppearanceAlert;
		note.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		note.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		note.autocapitalizationType = UITextAutocapitalizationTypeNone;
		note.clearButtonMode = UITextFieldViewModeWhileEditing;
		[limitBuyListView addSubview:note];
		
		UIButton *mobileSend = [UIButton buttonWithType:UIButtonTypeCustom];
		mobileSend.frame = CGRectMake(258, 127, 53, 27);
        mobileSend.titleLabel.font = [UIFont systemFontOfSize:14];
        [mobileSend setTitle:@"发送" forState:UIControlStateNormal];
        [mobileSend setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [mobileSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[mobileSend setBackgroundImage:[UIImage imageNamed:@"InviteSendNormal.png"] forState:UIControlStateNormal];
		[mobileSend setBackgroundImage:[UIImage imageNamed:@"InviteSendClick.png"] forState:UIControlStateHighlighted];
		[mobileSend addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
		[limitBuyListView addSubview:mobileSend];
		//邮箱
		mail = [[UITextField alloc] initWithFrame:CGRectMake(10, 195, 240, 26.0f)];
		mail.backgroundColor = [UIColor clearColor];
		mail.delegate = self;
		mail.text = @"";
		mail.placeholder = @"多个邮箱之间请以逗号分隔";
		mail.borderStyle = UITextBorderStyleNone;
		mail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		mail.keyboardType = UIKeyboardTypeEmailAddress;
        mail.keyboardAppearance = UIKeyboardAppearanceAlert;
		mail.autocapitalizationType = UITextAutocapitalizationTypeNone;
		mail.clearButtonMode = UITextFieldViewModeWhileEditing;
		[limitBuyListView addSubview:mail];
		
		UIButton *emailSend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		emailSend.frame = CGRectMake(258, 195, 53, 27);
        emailSend.titleLabel.font = [UIFont systemFontOfSize:14];
        [emailSend setTitle:@"发送" forState:UIControlStateNormal];
        [emailSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [emailSend setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[emailSend setBackgroundImage:[UIImage imageNamed:@"InviteSendNormal.png"] forState:UIControlStateNormal];
		[emailSend setBackgroundImage:[UIImage imageNamed:@"InviteSendClick.png"] forState:UIControlStateHighlighted];
		[emailSend addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
		[limitBuyListView addSubview:emailSend];
		
		//发送内容
		remark = [[UITextView alloc] initWithFrame:CGRectMake(10, 266, 300, 84.0f)];
		remark.backgroundColor = [UIColor clearColor];
        remark.keyboardAppearance = UIKeyboardAppearanceAlert;
		remark.editable = YES;
		remark.font = [UIFont systemFontOfSize:14];
		remark.text = @"正在售卖“xxxxxxx”限时限量折扣";
		remark.delegate = self;
		[limitBuyListView addSubview:remark];
		
		self.view = limitBuyListView;
		[limitBuyListView release];
		
	}
	return self;
}


#pragma mark -
#pragma mark 推荐给朋友 界面显示
-(float)contentWidth: (NSString *)string
{
	CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(260, 500) lineBreakMode:UILineBreakModeCharacterWrap];
	float width = size.width;
	return width;
}
-(void) showInfoWithArray:(NSArray *)theInfoArray
{
	self.infoArray = theInfoArray;
	[ImageCacheManager setImg:imageView withUrlString:[self.infoArray objectAtIndex:3]];
	//NSLog(@"%@",self.infoArray);
	//NSString *titleStr = [NSString stringWithFormat:@"%@",[self.infoArray objectAtIndex:0]];//[self.infoArray objectAtIndex:0];
	//NSLog(@"titlestr = %@",titleStr);
	//titleLabel.text = titleStr;
	titleLabel.text = [self.infoArray objectAtIndex:0];
	shoppePriceLabel.text = [self.infoArray objectAtIndex:1];
	float width = [self contentWidth:shoppePriceLabel.text];
	lineThrough.frame = CGRectMake(90, 40, width, 1);
	VIPLabel.text = [self.infoArray objectAtIndex:2];
	
	
	//OnlyAccount *account = [OnlyAccount defaultAccount];
	remark.text = [NSString stringWithFormat:@"正在售卖“%@”限时限量折扣",titleLabel.text];
	clearContent = TRUE;
}

#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSMutableData * nData = [[NSMutableData alloc] init];
    self.receivedData = nData;
    [nData release];
	[self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
	if(recfSMSConnection == connection)
	{
		self.navigationItem.leftBarButtonItem.enabled = YES;
		NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
		char flag = [str characterAtIndex:0];
		if(flag == '1')
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"您的短信推荐已经成功发送" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"短信推荐失败,请检查输入是否有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		[recfSMSConnection release];
		self.receivedData = nil;
		[loadingView finishLoading];
		[loadingView removeFromSuperview];
		[loadingView release];
	}
	
	if(recfEmailConnection == connection)
	{
		self.navigationItem.leftBarButtonItem.enabled = YES;
		NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
		char flag = [str characterAtIndex:0];
		if(flag == '1')
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"您的邮件推荐已经成功发送" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"邮件推荐失败,请检查输入是否有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		[recfEmailConnection release];
		self.receivedData = nil;
		[loadingView finishLoading];
		[loadingView removeFromSuperview];
		[loadingView release];
	}
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	self.navigationItem.leftBarButtonItem.enabled = YES;
	[connection release];
	self.receivedData = nil;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	if(clearContent)
	{
		//textView.text = @"";
		clearContent = !clearContent;
	}
	
	[UIView beginAnimations:@"scroll" context:nil];
	[UIView setAnimationDuration:0.25];
	CGRect frame = CGRectMake(0, -(textView.frame.origin.y -127), 320, 367);
	self.view.frame = frame; 
	[UIView commitAnimations];
	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if([text isEqualToString:@"\n"])
	{
		[textView resignFirstResponder];
		[UIView beginAnimations:@"scroll" context:nil];
		[UIView setAnimationDuration:0.25];
		CGRect frame = CGRectMake(0, 0, 320, 367);
		self.view.frame = frame; 
		[UIView commitAnimations];
		return NO;
	}
	return YES;
}

#pragma mark -
#pragma mark 释放相关

- (void)dealloc 
{
	[imageView release];
	[titleLabel release];
	[shoppePriceLabel release];
	[lineThrough release];
	[VIPLabel release];
	[note release];
	[mail release];
	[remark release];
	self.infoArray = nil;
	self.theNumbers = nil;
	self.receivedData = nil;
    [super dealloc];
}


@end
