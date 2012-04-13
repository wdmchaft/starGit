    //
//  TellFriendViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TellFriendViewController.h"
#import "ContactListViewController.h"

@implementation TellFriendViewController
@synthesize subjectNo,subjectTheme;
@synthesize theNumbers;
@synthesize theNames;
@synthesize delegate;
@synthesize receivedData;

#pragma mark -
#pragma mark 关闭 发送
-(void) doClose
{
	[self keyboardReturn];
	[self dismissModalViewControllerAnimated:YES];
}


//-(BOOL) validatePhone:(NSString*) aString  //判断手机号输入是否有误
//{
//	NSString *phoneRegex = @"(1[0-9]{10})((,)1[0-9]{10})*";
//	//NSString *phoneRegex = @"(1[0-9]{10}(,)*)*(1[0-9]{10})*";
//	NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];   
//	return [phoneTest evaluateWithObject:aString];  
//}
//- (void)selectNumber
//{
//    NSString * numstr = mobilTF.text;
//    NSArray * numstrArray = [numstr componentsSeparatedByString:@","];
//    for (NSString * number in numstrArray) 
//    {
//        NSString *phoneRegex = @"(1[0-9]{0,10})((,)1[0-9]{0,10})*";
//        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];   
//        if ([phoneTest evaluateWithObject:number]) {
//            self.theNumbers = [self.theNumbers stringByAppendingFormat:@",%@",number];
//            NSLog(@"theNumber = %@",self.theNumbers);
//        } 
//        
//    }
//    
//}

-(BOOL) validatePhone:(NSString*) aString            //判断手机号输入是否有误
{
	NSString *phoneRegex = @"(^(1[3|4|5|8][0-9]{9}(,)*)*(1[3|4|5|8][0-9]{9})$)*";
	NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];   
	return [phoneTest evaluateWithObject:aString];  
}

- (void)selectNumber
{
    NSString * numstr = mobilTF.text;
    NSLog(@"mobile.text = %@",mobilTF.text);
    NSArray * numstrArray = [numstr componentsSeparatedByString:@","];
    for (NSString * number in numstrArray) 
    {
        NSString *phoneRegex = @"(^1[3|4|5|8][0-9]{9}$)";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];   
        if ([phoneTest evaluateWithObject:number]) 
        {
            
            if (theNumbers == nil) 
            {
                self.theNumbers = number;
                
            }
            else
            {
                if (theNumbers != numbersStr) {
                    self.theNumbers = [self.theNumbers stringByAppendingFormat:@",%@",number];
                } 
            }  
            NSLog(@"theNumber1 = %@",self.theNumbers);
        } 
        
    }    
}


-(void) doSend
{
	[self keyboardReturn];
    [self selectNumber];
	
    if([contentTV isFirstResponder])
	{
		[contentTV resignFirstResponder];
	}
	
    numbersStr = theNumbers;
    //防止用户自己加的逗号和系统加的重复
    NSMutableString *mobiles = (NSMutableString *)[Trim trim:[self theNumbers]];

    
    //NSString *mobiles = [Trim trim:mobilTF.text];
    //NSString *mobiles = [Trim trim:[self theNumbers]];
	if([mobiles length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"至少要输入一个手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([self validatePhone:mobiles] == FALSE)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"手机格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}	
	else if([contentTV.text length] > 60)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"发送文字过长,请保证60个字之内" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		[MobClick event:[NSString stringWithFormat:@"tellFriend"] label:self.subjectTheme]; 
		self.navigationItem.leftBarButtonItem.enabled = NO;
		OnlyAccount *account = [OnlyAccount defaultAccount];
		//
		NSString *content = [NSString stringWithFormat:@"%@ 邀请您加入尚品网，%@",account.realName,contentTV.text];
		NSLog(@"content = %@",content);
		//
		NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@|%@",account.account,mobiles,content,self.subjectNo];
		NSString *encodedString = [URLEncode encodeUrlStr:parameters];
		NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
		
		NSString *tellFriendsStr = [NSString stringWithFormat:@"%@=TellFriends&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
		NSLog(@"告诉朋友:%@",tellFriendsStr);
		NSURL *tellFriendsUrl = [[NSURL alloc] initWithString:tellFriendsStr];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:tellFriendsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
		[self.view addSubview:loadingView];
		tellFriendConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[request release];
		[tellFriendsUrl release];
	}
	
}

#pragma mark -
#pragma mark 键盘回收
-(void)keyboardReturn
{
	if([mobilTF isFirstResponder])
	{
		[mobilTF resignFirstResponder];
	}
	
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if([mobilTF isFirstResponder])
	{
		[mobilTF resignFirstResponder];
	}
	return YES;
}
#pragma mark -
#pragma mark 初始化

static TellFriendViewController *tellFriendVC = nil;
+(TellFriendViewController *) getTellFriendInstanse
{
	if(tellFriendVC == nil)
	{
		tellFriendVC = [[TellFriendViewController alloc] init];
	}
	return tellFriendVC;
}

-(void) didFinishChoosePhoneNumberInvite:(NSArray *)thePhoneName
{
	NSLog(@"%s",__FUNCTION__);
    if([theNumbers length] != 0)
	{
		//self.theNames = [NSString stringWithFormat:@"%@,%@",mobileTF.text,[thePhoneName objectAtIndex:0]];
        self.theNumbers = [NSString stringWithFormat:@"%@,%@",theNumbers,[thePhoneName objectAtIndex:1]];
	}
	else
	{
		//self.theNames = [thePhoneName objectAtIndex:0];
        self.theNumbers = [thePhoneName objectAtIndex:1];
        
	}
    if ([mobilTF.text length]!= 0) {
        self.theNames = [NSString stringWithFormat:@"%@,%@",mobilTF.text,[thePhoneName objectAtIndex:0]];
    }
    else
    {
        self.theNames = [thePhoneName objectAtIndex:0];
    }
	NSLog(@"tneNumber_tong = %@",self.theNumbers);
    NSLog(@"mobileTF.text = %@",mobilTF.text);
    mobilTF.text = self.theNames;
}




//- (void)loadView 
-(id) init
{
    self = [super init];
	if(self)
	{
		self.title = @"告诉朋友";
		UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(doClose)];	
		self.navigationItem.leftBarButtonItem = left;
		[left release];
		
		UIView *tellFrindView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
		tellFrindView.backgroundColor = [UIColor blackColor];
		
		UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
		contentView.tag = 900;
		contentView.backgroundColor = [UIColor clearColor];
		//品牌图片
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 320, 95)];
		[contentView addSubview:imageView];
		
		//好友的手机号
		UIImageView *backgroundImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 103, 320, 263)];
		backgroundImgV.image = [UIImage imageNamed:@"TellFrientBG.png"];
		[contentView addSubview:backgroundImgV];
		[backgroundImgV release];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 108, 125, 15)];
        label.backgroundColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"好友的手机号码：";
        label.textColor = WORDCOLOR;
        [contentView addSubview:label];
        [label release];
        
        UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
		contactButton.frame = CGRectMake(125, 97, 56, 35);
        contactButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [contactButton setTitle:@"   通讯录" forState:UIControlStateNormal];
        [contactButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];        
		[contactButton setBackgroundImage:[UIImage imageNamed:@"ContactNormal.png"] forState:UIControlStateNormal];
		[contactButton setBackgroundImage:[UIImage imageNamed:@"ContractClick.png"] forState:UIControlStateHighlighted];
		[contactButton addTarget:self action:@selector(doCheckPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
		[contentView addSubview:contactButton];
		
		mobilTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 129, 238, 26)];	
		mobilTF.backgroundColor = [UIColor clearColor];
		mobilTF.placeholder = @"多个电话号码请以逗号分隔";
		mobilTF.text = @"";
		mobilTF.textColor = WORDCOLOR;
		mobilTF.borderStyle = UITextBorderStyleNone;
		mobilTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        mobilTF.keyboardAppearance = UIKeyboardAppearanceAlert;
		mobilTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		mobilTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
		mobilTF.delegate = self;
		mobilTF.clearButtonMode = UITextFieldViewModeWhileEditing;
		[contentView addSubview:mobilTF];
        
		//告诉朋友
		UIButton *tellFriendSend = [UIButton buttonWithType:UIButtonTypeCustom];
		tellFriendSend.frame = CGRectMake(260, 130, 53, 27);
        tellFriendSend.titleLabel.font = [UIFont systemFontOfSize:14];
        [tellFriendSend setTitle:@"发送" forState:UIControlStateNormal];
        [tellFriendSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tellFriendSend setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[tellFriendSend setBackgroundImage:[UIImage imageNamed:@"InviteSendNormal.png"] forState:UIControlStateNormal];
		[tellFriendSend setBackgroundImage:[UIImage imageNamed:@"InviteSendClick.png"] forState:UIControlStateHighlighted];
		[tellFriendSend addTarget:self action:@selector(doSend) forControlEvents:UIControlEventTouchUpInside];
		[contentView addSubview:tellFriendSend];
		
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(8, 168, 125, 15)];
        label2.backgroundColor = [UIColor blackColor];
        label2.font = [UIFont systemFontOfSize:14];
        label2.text = @"发送内容：";
        label2.textColor = WORDCOLOR;
        [contentView addSubview:label2];
        [label2 release];
        
		contentTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 193, 290, 80)];
		contentTV.backgroundColor = [UIColor clearColor];
        contentTV.keyboardAppearance = UIKeyboardAppearanceAlert;
		contentTV.font = [UIFont systemFontOfSize:14];
		contentTV.editable = YES;
		contentTV.text = @"快来参加“XXX“限时限量折扣专场活动";
		contentTV.delegate = self;
		[contentView addSubview:contentTV];
		
		[tellFrindView addSubview:contentView];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(8, 285, 300, 15)];
        label3.backgroundColor = [UIColor blackColor];
        label3.font = [UIFont systemFontOfSize:13];
        label3.text = @"注：此短信不会产生任何费用，由尚品网代为发送";
        label3.textColor = [UIColor redColor];
        [contentView addSubview:label3];
        [label3 release];
        
		[contentView release];
		
		self.view = tellFrindView;
		[tellFrindView release];
		
	}
	return self;
}

-(void) showImageViewWithUrl:(NSString *)theUrl andId:(NSString *)theID andTheme:(NSString *)theTheme
{
	self.subjectNo = theID;
	self.subjectTheme = theTheme;
	if(self.subjectTheme == nil)
	{
		self.subjectTheme = @"";
	}
	[ImageCacheManager setImg:imageView	withUrlString:theUrl];
	
	//OnlyAccount *account = [OnlyAccount defaultAccount];
	contentTV.text = [NSString stringWithFormat:@"快来参加“%@“限时限量折扣专场活动",self.subjectTheme];
	clearContent = TRUE;
}


#pragma mark -
#pragma mark 选取电话号码
-(void) doCheckPhoneNumber
{
	[self keyboardReturn];
	ContactListViewController *clVC = [[ContactListViewController alloc] init];
	clVC.tellfVC = self;
	self.delegate = self;
	[self.navigationController pushViewController:clVC animated:YES];
	[clVC release];
}

//-(void) didFinishChoosePhoneNumber:(NSString *)thePhoneNumber
//-(void) didFinishChoosePhoneNumberInvite:(NSArray *)thePhoneName
//{
////	if([mobilTF.text length] != 0)
////	{
////		self.theNumbers = [NSString stringWithFormat:@"%@,%@",mobilTF.text,thePhoneNumber];
////	}
////	else
////	{
////		self.theNumbers = thePhoneNumber;
////	}
////	mobilTF.text = self.theNumbers;
//    if([mobilTF.text length] != 0)
//	{
//		self.theNames = [NSString stringWithFormat:@"%@,%@",mobilTF.text,[thePhoneName objectAtIndex:0]];
//        self.theNumbers = [NSString stringWithFormat:@"%@,%@",theNumbers,[thePhoneName objectAtIndex:1]];
//	}
//	else
//	{
//		self.theNames = [thePhoneName objectAtIndex:0];
//        self.theNumbers = [thePhoneName objectAtIndex:1];
//        
//	}
//	mobilTF.text = self.theNames;
//
//    
//}




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
	NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
	char flag = [str characterAtIndex:0];
	if(flag == '1')
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"您的短信通知已经成功发送" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"短信通知失败,请检查输入是否有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	self.receivedData = nil;
	[tellFriendConnection release];
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	self.navigationItem.leftBarButtonItem.enabled = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	self.navigationItem.leftBarButtonItem.enabled = YES;
	[tellFriendConnection release];
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
	CGRect frame = CGRectMake(0, -(textView.frame.origin.y -129), 320, 460);
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
		CGRect frame = CGRectMake(0, 0, 320, 460);
		self.view.frame = frame; 
		[UIView commitAnimations];
		return NO;
	}
	return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	[UIView beginAnimations:@"scroll" context:nil];
	[UIView setAnimationDuration:0.25];
	CGRect frame = CGRectMake(0, 0, 320, 460);
	self.view.frame = frame; 
	[UIView commitAnimations];
}

- (void)dealloc 
{
	[imageView release];
	[mobilTF release];
	[contentTV release];
	self.subjectNo = nil;
	self.theNumbers = nil;
	self.receivedData = nil;
    [super dealloc];
}


@end
