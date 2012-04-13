    //
//  InviteViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InviteViewController.h"
#import "ContactListViewController.h"
#import "GDataXMLNode.h"
#import "InvRecordViewController.h"

@implementation InviteViewController
@synthesize theNumbers;
@synthesize theNames;
@synthesize delegate;
@synthesize receivedData;
@synthesize emailPromptLabel;
@synthesize moilePromptLabel;

#pragma mark -
#pragma mark 键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	[UIView beginAnimations:@"scroll" context:nil];
	[UIView setAnimationDuration:0.25];
	CGRect frame = CGRectMake(0, 0, 320, 367);
	self.view.frame = frame; 
	[UIView commitAnimations];
	return YES;
}

-(void) keyBoardReturn
{
	if([mobileTF isFirstResponder])
	{
		[mobileTF resignFirstResponder];
	}
	if([emailTF isFirstResponder])
	{
		[emailTF resignFirstResponder];
	}
	if([contentTV isFirstResponder])
	{
		[contentTV resignFirstResponder];
	}
	[UIView beginAnimations:@"scroll" context:nil];
	[UIView setAnimationDuration:0.25];
	CGRect frame = CGRectMake(0, 0, 320, 367);
	self.view.frame = frame; 
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark 初始化

- (id)init
{	
	self = [super init];
    if(self)
	{
        
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 415)];
		aView.backgroundColor = [UIColor blackColor];
		
		clearContent = TRUE;
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoTittle.png"]];
        logoImageView.center = CGPointMake(160, [logoImageView center].y);
        self.navigationItem.titleView = logoImageView;
        [logoImageView release];
		
		inviteView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 415)];
		inviteView.contentSize = CGSizeMake(320, 440);

        //浅色背景图片
        UIImage * imageq = [UIImage imageNamed:@"Inv_light_Lable.png"];
        UIImage *imagemobil = [imageq stretchableImageWithLeftCapWidth:1.0f topCapHeight:0.0f];
        //发送背景图片
        UIImage * imageSent = [UIImage imageNamed:@"YellowButtonBig.png"];
        UIImage *imageSentBack = [imageSent stretchableImageWithLeftCapWidth:1.0f topCapHeight:0.0f];
        

        
		UILabel *mobilLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 32)];
		mobilLabel.textColor = [UIColor colorWithRed:0.486f green:0.486f blue:0.486 alpha:1.0f];//WORDCOLOR;
		mobilLabel.font = [UIFont systemFontOfSize:14.0f];
        mobilLabel.backgroundColor = [UIColor colorWithPatternImage:imagemobil];
        mobilLabel.textAlignment = UITextAlignmentCenter;
		mobilLabel.text = @"短信邀请";
        mobilLabel.layer.masksToBounds = YES;
        mobilLabel.layer.cornerRadius = 0.0f;
        mobilLabel.layer.borderWidth = 2.0f;
        mobilLabel.layer.borderColor = [[UIColor colorWithRed:0.29f green:0.29f blue:0.29f alpha:1] CGColor];

		[inviteView addSubview:mobilLabel];
		[mobilLabel release];
		
		//添加号码
		UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
		contactButton.frame = CGRectMake(92, 8, 30, 30);
        UIImageView * addButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(98, 16, 18, 18)];
        addButtonView.center = CGPointMake(addButtonView.center.x, mobilLabel.center.y);
        addButtonView.image = [UIImage imageNamed:@"Add.png"];
		[contactButton addTarget:self action:@selector(doCheckPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
		[inviteView addSubview:addButtonView];
        [inviteView addSubview:contactButton];
		[addButtonView release];
        
		//手机号码输入框的背景图
		UIImageView *mobileImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 300, 50)];
		mobileImg.image = [UIImage imageNamed:@"InviteBG.png"];
        //mobileImg.alpha = 1.0f;
		[inviteView addSubview:mobileImg];
		[mobileImg release];
		moilePromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 53, 290, 24)];
        moilePromptLabel.textColor = [UIColor colorWithRed:0.694f green:0.690f blue:0.675f alpha:1.0f];
        moilePromptLabel.backgroundColor = [UIColor clearColor];
        moilePromptLabel.text = @"可点击加号添加通讯录好友";
        moilePromptLabel.font = [UIFont systemFontOfSize:13.0f];
        [inviteView addSubview:moilePromptLabel];
        [moilePromptLabel release];
        
        
		//好友手机号码输入框
		mobileTF = [[UITextView alloc] initWithFrame:CGRectMake(15, 53, 290, 48)];
		mobileTF.backgroundColor = [UIColor clearColor];
		//mobileTF.placeholder = @"多个电话号码请以逗号分隔";
		mobileTF.text = @"";
        mobileTF.tag = 300;
		mobileTF.textColor = WORDCOLOR;
		//mobileTF.borderStyle = UITextBorderStyleNone;
		mobileTF.font = [UIFont systemFontOfSize:13];
		//mobileTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		mobileTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        mobileTF.keyboardAppearance = UIKeyboardAppearanceAlert;
        mobileTF.returnKeyType = UIReturnKeyDone;
		mobileTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
		mobileTF.delegate = self;
		//mobileTF.clearButtonMode = UITextFieldViewModeWhileEditing;
		[inviteView addSubview:mobileTF];
		
		UIButton *mobileSend = [UIButton buttonWithType:UIButtonTypeCustom];
		mobileSend.frame = CGRectMake(258, 17, 50, 25);
        mobileSend.titleLabel.font = [UIFont systemFontOfSize:14];
        [mobileSend setTitle:@"发送" forState:UIControlStateNormal];
        [mobileSend setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [mobileSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[mobileSend setBackgroundImage:imageSentBack forState:UIControlStateNormal];
		[mobileSend setBackgroundImage:imageSentBack forState:UIControlStateHighlighted];
        mobileSend.layer.masksToBounds = YES;
        mobileSend.layer.cornerRadius = 2.0f;
        mobileSend.showsTouchWhenHighlighted = YES;
		[mobileSend addTarget:self action:@selector(doSMSInvite) forControlEvents:UIControlEventTouchUpInside];
		[inviteView addSubview:mobileSend];
		
		
		UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 108, 70, 32)];
		emailLabel.textColor = [UIColor colorWithRed:0.486f green:0.486f blue:0.486 alpha:1.0f];
		emailLabel.font = [UIFont systemFontOfSize:14];
		emailLabel.backgroundColor = [UIColor colorWithPatternImage:imagemobil];
        emailLabel.textAlignment = UITextAlignmentCenter;
        emailLabel.layer.masksToBounds = YES;
        emailLabel.layer.cornerRadius = 0.0f;
        emailLabel.layer.borderWidth = 2.0f;
        emailLabel.layer.borderColor = [[UIColor colorWithRed:0.29f green:0.29f blue:0.29f alpha:1] CGColor];
		emailLabel.text = @"邮件邀请";
		[inviteView addSubview:emailLabel];
		[emailLabel release];
		
//        UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
//		emailButton.frame = CGRectMake(92, 108, 30, 30);
//        UIImageView * addButtonEView = [[UIImageView alloc] initWithFrame:CGRectMake(98, 115, 18, 18)];
//        addButtonEView.center = CGPointMake(addButtonEView.center.x, emailLabel.center.y);
//        addButtonEView.image = [UIImage imageNamed:@"Add.png"];
//		[emailButton addTarget:self action:@selector(selectedEmailTextView) forControlEvents:UIControlEventTouchUpInside];
//		[inviteView addSubview:addButtonEView];
//        [inviteView addSubview:emailButton];
//		[addButtonEView release];

		//电子邮箱输入框的背景图
		UIImageView *emailImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 148, 300, 60)];
		emailImg.image = [UIImage imageNamed:@"InviteBG.png"];
		[inviteView addSubview:emailImg];
		[emailImg release];
        emailPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 151, 290, 24)];
        emailPromptLabel.textColor = [UIColor colorWithRed:0.694f green:0.690f blue:0.675f alpha:1.0f];
        emailPromptLabel.backgroundColor = [UIColor clearColor];
        emailPromptLabel.text = @"多个邮箱之间请以逗号分隔";
        emailPromptLabel.font = [UIFont systemFontOfSize:13.0f];
        [inviteView addSubview:emailPromptLabel];
        [emailPromptLabel release];

        //好友邮箱输入框
		emailTF = [[UITextView alloc] initWithFrame:CGRectMake(15, 151, 290, 54)];
		emailTF.backgroundColor = [UIColor clearColor];
		emailTF.textColor = WORDCOLOR;
		emailTF.text = @"";
        emailTF.tag = 301;
        emailTF.font = [UIFont systemFontOfSize:16];
		emailTF.keyboardType = UIKeyboardTypeDefault;
        emailTF.keyboardAppearance = UIKeyboardAppearanceAlert;
        emailTF.returnKeyType = UIReturnKeyDone;
		emailTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
		emailTF.delegate = self;
        [inviteView addSubview:emailTF];
		
		
        UIButton *emailSend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		emailSend.frame = CGRectMake(258, 115, 50, 25);
        emailSend.titleLabel.font = [UIFont systemFontOfSize:14];
        [emailSend setTitle:@"发送" forState:UIControlStateNormal];
        [emailSend setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [emailSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[emailSend setBackgroundImage:imageSentBack forState:UIControlStateNormal];
		[emailSend setBackgroundImage:imageSentBack forState:UIControlStateHighlighted];
        emailSend.layer.masksToBounds = YES;
        emailSend.layer.cornerRadius = 2.0f;
        emailSend.showsTouchWhenHighlighted = YES;
		[emailSend addTarget:self action:@selector(doEmailSend) forControlEvents:UIControlEventTouchUpInside];
		[inviteView addSubview:emailSend];
		
		UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 216, 70, 32)];
		contentLabel.textColor = [UIColor colorWithRed:0.486f green:0.486f blue:0.486 alpha:1.0f];;
		contentLabel.font = [UIFont systemFontOfSize:14];
		contentLabel.backgroundColor = [UIColor colorWithPatternImage:imagemobil];
		contentLabel.text = @"发送内容";
        contentLabel.textAlignment = UITextAlignmentCenter;
        contentLabel.layer.masksToBounds = YES;
        contentLabel.layer.cornerRadius = 0.0f;
        contentLabel.layer.borderWidth = 2.0f;
        contentLabel.layer.borderColor = [[UIColor colorWithRed:0.29f green:0.29f blue:0.29f alpha:1] CGColor];

		[inviteView addSubview:contentLabel];
		[contentLabel release];
		
		UIImageView *contentImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 256, 300, 60)];
		contentImgV.image = [UIImage imageNamed:@"InviteBG.png"];
		[inviteView addSubview:contentImgV];
		[contentImgV release];
		
		//发送内容
		contentTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 259, 290, 54)];
		contentTV.backgroundColor = [UIColor clearColor];
		contentTV.font = [UIFont systemFontOfSize:13];
		//contentTV.editable = NO;
		contentTV.delegate = self;
		contentTV.text = @"一个很棒的奢侈品私卖平台，所有商品款式经典、限时限量折扣！只有被邀请才能加入哦！";
        contentTV.keyboardAppearance = UIKeyboardAppearanceAlert;
        contentTV.returnKeyType = UIReturnKeyDone;
		[inviteView addSubview:contentTV];
		
		
		UILabel *directMethod = [[UILabel alloc] initWithFrame:CGRectMake(10, 325, 250, 16)];
		directMethod.textColor = [UIColor whiteColor];
		directMethod.font = [UIFont systemFontOfSize:13];
		directMethod.backgroundColor = [UIColor clearColor];
		directMethod.text = @"您可将上述内容分享给QQ/MSN好友";
		[inviteView addSubview:directMethod];
		[directMethod release];
		
        UIButton * inv_recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        inv_recordButton.frame = CGRectMake(10, 346, 300, 32);
        inv_recordButton.backgroundColor = [UIColor clearColor];
        inv_recordButton.layer.masksToBounds = YES;
        inv_recordButton.layer.cornerRadius = 2.0f;
        inv_recordButton.layer.borderWidth = 0.4f;
        inv_recordButton.layer.borderColor = [[UIColor whiteColor]CGColor];
        [inv_recordButton setTitle:@"邀请记录" forState:UIControlStateNormal];
        [inv_recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [inv_recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        //[inv_recordButton setTitle:@"邀请记录" forState:UIControlStateHighlighted];
        [inv_recordButton setBackgroundImage:imageSentBack forState:UIControlStateNormal];
		[inv_recordButton setBackgroundImage:imageSentBack forState:UIControlStateHighlighted];

        inv_recordButton.showsTouchWhenHighlighted = YES;
        [inv_recordButton addTarget:self action:@selector(seeRecord) forControlEvents:UIControlEventTouchUpInside];
        [inviteView addSubview:inv_recordButton];
        
//		UILabel *methodOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 423, 50, 14)];
//		methodOneLabel.textColor = [UIColor whiteColor];
//		methodOneLabel.font = [UIFont systemFontOfSize:14];
//		methodOneLabel.backgroundColor = [UIColor clearColor];
//		methodOneLabel.text = @"方式一:";
//		[inviteView addSubview:methodOneLabel];
//		[methodOneLabel release];
//		
//		codeTF = [[UITextField alloc] initWithFrame:CGRectMake(60, 426, 200, 14)];
//		codeTF.textColor = [UIColor whiteColor];
//		codeTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//		codeTF.borderStyle = UITextBorderStyleNone;
//		codeTF.font = [UIFont systemFontOfSize:14];
//		codeTF.backgroundColor = [UIColor clearColor];
//		codeTF.enabled = NO;
//		codeTF.text = @"邀请码";
//		[inviteView addSubview:codeTF];
//		
//		UILabel *methodOneDes = [[UILabel alloc] initWithFrame:CGRectMake(10, 450, 300, 35)];
//		methodOneDes.textColor = WORDCOLOR;
//		methodOneDes.font = [UIFont systemFontOfSize:14];
//		methodOneDes.backgroundColor = [UIColor clearColor];
//		methodOneDes.numberOfLines = 0;
//		methodOneDes.text = @"您可以直接告诉好友上述邀请码,让好友登录shangpin.com,激活邀请码,注册为尚品会员";
//		[inviteView addSubview:methodOneDes];
//		[methodOneDes release];
//		
//		UILabel *methodTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 495, 200, 14)];
//		methodTwoLabel.textColor = [UIColor whiteColor];
//		methodTwoLabel.font = [UIFont systemFontOfSize:14];
//		methodTwoLabel.backgroundColor = [UIColor clearColor];
//		methodTwoLabel.text = @"方法二:邀请连接";
//		[inviteView addSubview:methodTwoLabel];
//		[methodTwoLabel release];
//		
//		linkTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 519, 300, 60)];
//		linkTV.textColor = [UIColor whiteColor];
//		linkTV.font = [UIFont systemFontOfSize:14];
//		linkTV.editable = NO;
//		linkTV.scrollEnabled = YES;
//		linkTV.backgroundColor = [UIColor clearColor];
//		linkTV.text = @"";
//		[inviteView addSubview:linkTV];
//		
//		UILabel *methodTwoDes = [[UILabel alloc] initWithFrame:CGRectMake(10, 589, 300, 14)];
//		methodTwoDes.textColor = WORDCOLOR;
//		methodTwoDes.font = [UIFont systemFontOfSize:14];
//		methodTwoDes.backgroundColor = [UIColor clearColor];
//		methodTwoDes.text = @"复制该链接后,通过QQ,MSN告知给您的好友";
//		[inviteView addSubview:methodTwoDes];
//		[methodTwoDes release];
//		
		
        self.delegate = self;
		
		[aView addSubview:inviteView];
		[inviteView release];
		self.view = aView;
		
		[aView release];
		
	}
	return self;
}

- (void)seeRecord{
    InvRecordViewController * invRecordVC = [[InvRecordViewController alloc] init];
    [self.navigationController pushViewController:invRecordVC animated:YES];
    [invRecordVC release];


}


-(void) viewDidLoad
{
	[super viewDidLoad];
	
	[self showInviteView];
}

-(void) showInviteView
{
	mobileTF.text = @"";
	emailTF.text = @"";
	OnlyAccount *account = [OnlyAccount defaultAccount];
	linkTV.scrollEnabled = YES;
	clearContent = TRUE;
	contentTV.text = [NSString stringWithFormat:@"一个很棒的奢侈品私卖平台，所有商品款式经典、限时限量折扣！只有被邀请才能加入哦！"];
    if(inviteInfoConnection == nil)
    {
        NSString *parameters = [NSString stringWithFormat:@"%@",account.account];
        NSString *encodedString = [URLEncode encodeUrlStr:parameters];
        NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
        NSString *inviteInfoStr = [NSString stringWithFormat:@"%@=GetInviteInfo&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
        NSLog(@"邀请好友:%@",inviteInfoStr);
   
        NSURL *inviteInfoStrUrl = [[NSURL alloc] initWithString:inviteInfoStr];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:inviteInfoStrUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
        loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:loadingView];
        inviteInfoConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [request release];
        [inviteInfoStrUrl release];
    }
	
}


#pragma mark -
#pragma mark 通讯录
-(void) doCheckPhoneNumber
{
	ContactListViewController *clVC = [[ContactListViewController alloc] init];
	clVC.inviteVC = self;
	[self.navigationController pushViewController:clVC animated:YES];
	[clVC release];
}

//-(void) didFinishChoosePhoneNumber:(NSString *)thePhoneNumber
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
    if ([mobileTF.text length]!= 0) {
        self.theNames = [NSString stringWithFormat:@"%@,%@",mobileTF.text,[thePhoneName objectAtIndex:0]];
    }
    else
    {
        self.theNames = [thePhoneName objectAtIndex:0];
    }
	NSLog(@"tneNumber_tong = %@",self.theNumbers);
    NSLog(@"mobileTF.text = %@",mobileTF.text);
    mobileTF.text = self.theNames;
}


//添加邮箱+号按钮
-(void)selectedEmailTextView{
    [emailTF becomeFirstResponder];

}

-(void) doEmailSend
{
    
	[self keyBoardReturn];
	NSString *emails = [Trim trim:emailTF.text];
	if([emails length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"至少要有一个Email地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([contentTV.text length] > 60)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"发送文字过长,请保证60个字之内" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}	
	else
	{
		OnlyAccount *account = [OnlyAccount defaultAccount];
		//
		NSString *content = [NSString stringWithFormat:@"%@ 邀请您加入尚品网，%@",account.realName,contentTV.text];
		NSLog(@"content = %@",content);
		//
		NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@",account.account,emails,content];
		NSString *encodedString = [URLEncode encodeUrlStr:parameters];
		NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
		
		[MobClick event:@"InvitefriendsWithEmail"];

		
		NSString *invitefriendsWithEmailStr = [NSString stringWithFormat:@"%@=InvitefriendsWithEmail&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
		NSLog(@"邀请好友注册通过Email:%@",invitefriendsWithEmailStr);
		NSURL *invitefriendsWithEmailUrl = [[NSURL alloc] initWithString:invitefriendsWithEmailStr];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:invitefriendsWithEmailUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
		[self.view addSubview:loadingView];
		inviteWithEmailConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[request release];
		[invitefriendsWithEmailUrl release];
	}	
}


-(BOOL) validatePhone:(NSString*) aString
{
	NSString *phoneRegex = @"(^(1[3|4|5|8][0-9]{9}(,)*)*(1[3|4|5|8][0-9]{9})$)*";
	NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];   
	return [phoneTest evaluateWithObject:aString];  
}

- (void)selectNumber
{
    NSString * numstr = mobileTF.text;
    NSLog(@"mobile.text = %@",mobileTF.text);
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

-(void) doSMSInvite
{
	[self keyBoardReturn];
    [self selectNumber];
	numbersStr = theNumbers;
    //防止用户自己加的逗号和系统加的重复
    NSMutableString *mobiles = (NSMutableString *)[Trim trim:[self theNumbers]];
    
    [mobiles stringByReplacingOccurrencesOfString:@",," withString:@","];
    if([mobiles length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"至少要有一个手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([self validatePhone:mobiles] == FALSE)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"手机格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([contentTV.text length] > 60)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"发送文字过长,请保证60个字之内" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}	
	else
	{
		OnlyAccount *account = [OnlyAccount defaultAccount];
		//
		NSString *content = [NSString stringWithFormat:@"%@ 邀请您加入尚品网，%@",account.realName,contentTV.text];
		NSLog(@"content = %@",content);
		//
		NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@",account.account,mobiles,content];
		NSString *encodedString = [URLEncode encodeUrlStr:parameters];
		NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
		
		[MobClick event:@"InvitefriendsWithSMS"];
		
		NSString *invitefriendsWithSMSStr = [NSString stringWithFormat:@"%@=InvitefriendsWithSMS&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
		//NSLog(@"短信邀请好友，修改?:%@",invitefriendsWithSMSStr);
		NSURL *invitefriendsWithSMSUrl = [[NSURL alloc] initWithString:invitefriendsWithSMSStr];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:invitefriendsWithSMSUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
		[self.view addSubview:loadingView];
		inviteWithSMSConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[request release];
		[invitefriendsWithSMSUrl release];
	}
    //self.theNumbers = nil;
}



#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
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
	
	if(inviteInfoConnection == connection)
	{
        [inviteInfoConnection release];
        inviteInfoConnection = nil;
		NSError *error = nil;
		GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
		
		if(error)
		{
			[document release];
			return;
		}
		GDataXMLElement *root = [document rootElement];
		GDataXMLElement *code = [[root elementsForName:@"code"] objectAtIndex:0];
		codeTF.text = [NSString stringWithFormat:@"邀请码 %@",[Trim trim:[code stringValue]]];
		GDataXMLElement *link = [[root elementsForName:@"link"] objectAtIndex:0];
		linkTV.text = [Trim trim:[link stringValue]];
		linkTV.scrollEnabled = NO;
		
		[document release];
	}
	
	if(inviteWithSMSConnection == connection)
	{
		NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
		char flag = [str characterAtIndex:0];
		if(flag == '1')
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"您的短信邀请已经成功发送" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"短信邀请失败,请检查输入是否有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		[inviteWithSMSConnection release];
	}
	
	if(inviteWithEmailConnection == connection)
	{
		NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
		char flag = [str characterAtIndex:0];
		if(flag == '1')
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"您的邮件邀请已经成功发送" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"邮件邀请失败,请检查输入是否有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		[inviteWithEmailConnection release];
	}
	self.receivedData = nil;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[connection release];
	self.receivedData = nil;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
	CGRect frame = CGRectMake(0, -(textView.frame.origin.y -53), 320, 367);
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

//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    NSLog(@"YYYYYYYYYYYYYYYYY  %s",__FUNCTION__);
//    [self selectNumber];
//}


//控制电话和邮箱的输入栏提示文字的隐藏和显示
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == (UITextView *)[inviteView viewWithTag:300])
    {
        moilePromptLabel.alpha = 0.0f;
    }
    if(textView == (UITextView *)[inviteView viewWithTag:301])
    {
        emailPromptLabel.alpha = 0.0f;
    }
   
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"%s",__FUNCTION__);    
    if (textView == (UITextView *)[inviteView viewWithTag:300])
    {
        if ([textView.text isEqualToString:@""]) {
            moilePromptLabel.alpha = 1.0f;
        }
    }else{
        if ([textView.text isEqualToString:@""]) {
            emailPromptLabel.alpha = 1.0f;
        }
    }

    return YES;
}

-(void) hideMobileLabel
{
    moilePromptLabel.alpha = 0.0f;
}

#pragma mark -
#pragma mark 释放相关

- (void)dealloc 
{
	self.receivedData = nil;
	self.theNumbers = nil;
	[mobileTF release];
	[emailTF release];
	[contentTV release];
	[codeTF release];
	[linkTV release];
    [super dealloc];
}


@end
