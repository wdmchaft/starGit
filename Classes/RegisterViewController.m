//
//  NewRegisterVC.m
//  ShangPin
//
//  Created by 唐彬琪 on 11-7-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "ShangPinAppDelegate.h"
#import "LogInViewController.h"
#import "GDataXMLNode.h"
#include <unistd.h>

@implementation RegisterViewController
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
		if([mobileTF isFirstResponder])
	{
		[mobileTF resignFirstResponder];
	}
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//	[UIView beginAnimations:@"scroll" context:nil];
//	[UIView setAnimationDuration:0.25];
//	CGRect frame = CGRectMake(0, 0, 320, 480);
//	self.view.frame = frame;
//	[UIView commitAnimations];
//	[textField resignFirstResponder];
//	return YES;
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField.tag<2003) {
        [textField resignFirstResponder];
        UITextField * textFieldDawn = (UITextField *)[backGroundView viewWithTag:[textField tag]+1];
        [textFieldDawn becomeFirstResponder];
        return NO;
    }
    else{
//        [UIView beginAnimations:@"scroll" context:nil];
//        [UIView setAnimationDuration:0.25];
//        CGRect frame = CGRectMake(0, 0, 320, 480);
//        self.view.frame = frame;
//        [UIView commitAnimations];
        [textField resignFirstResponder];
        return YES;
    }
}


//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//	if (textField.frame.origin.y>150) 
//    {
//    [UIView beginAnimations:@"scroll" context:nil];
//	[UIView setAnimationDuration:0.25];
//	CGRect frame = CGRectMake(0, -(textField.frame.origin.y -14), 320, 480);
//	self.view.frame = frame; 
//	[UIView commitAnimations];
//    }
//    return YES;
//}




- (void)dealloc
{
    [emailTF release];
	[setPasswordTF release];
	[mobileTF release];
	
//	[maleSelectedImgV release];
//	[femaleSelectedImgV release];
	
//	[clauseImgV release];
//	[soldNoticeImgV release];
	self.receivedData = nil;
	[clauseView release];
    [super dealloc];

}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
#pragma mark -
#pragma mark 初始化
static RegisterViewController *registerVC = nil;
+(RegisterViewController *) defaultRegisterViewController
{
	if(registerVC == nil)
	{
		registerVC = [[RegisterViewController alloc] init];
	}
	return registerVC;
}


- (void)loadView
{
    maxConnectionCount = 5;					//登录的最大次数限制
    
    UIView *registerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	//loginView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginBG.png"]];
	
	//背景图片
    UIImageView *imageBJ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	imageBJ.image = [UIImage imageNamed:@"AllowBackground.jpg"];
    imageBJ.alpha = 1.0f;
	[registerView addSubview:imageBJ];
	[imageBJ release];
    remoteNotification  = TRUE;
    //登录窗口
     
    backGroundView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    backGroundView.contentSize = CGSizeMake(320, 661);
    backGroundView.backgroundColor = [UIColor clearColor];
    backGroundView.showsVerticalScrollIndicator = NO;
    backGroundView.showsHorizontalScrollIndicator = NO;
    [registerView addSubview:backGroundView];
    [backGroundView release];

    UIImageView * imageDL = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 300, 391)];
    UIImage * imagere = [UIImage imageNamed:@"Layer_DownRound.png"];
    imageDL.image = [imagere stretchableImageWithLeftCapWidth:0.0f topCapHeight:20.0f];
    //imageDL.backgroundColor = [UIColor colorWithRed:0.882 green:0.882 blue:0.882 alpha:0.7];
    imageDL.layer.masksToBounds = YES;
    imageDL.layer.cornerRadius = 8.0f;
    [backGroundView addSubview:imageDL];
    [imageDL release];

    
    
    UIImageView * imageDLtitle = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 300, 35)];
    imageDLtitle.image = [UIImage imageNamed:@"AllowTitle.png"];
    UILabel * imageDLtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 300, 35)];
    imageDLtitleLabel.backgroundColor = [UIColor clearColor];
    imageDLtitleLabel.text = @"会 员 注 册";
    imageDLtitleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    imageDLtitleLabel.textAlignment = UITextAlignmentCenter;
    imageDLtitleLabel.textColor = [UIColor whiteColor];
    
    [backGroundView addSubview:imageDLtitle];
    [backGroundView addSubview:imageDLtitleLabel];
    [imageDLtitle release];
    [imageDLtitleLabel release];
    //注册窗口关闭按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.frame = CGRectMake(272.5, 22.5, 35, 35);
    UIImageView * backButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close.png"]];
    backButtonView.frame = CGRectMake(7, 9, 20, 20);
    [backButton addSubview:backButtonView];
    [backButtonView release];
	[backButton addTarget:self action:@selector(backToLoginView) forControlEvents:UIControlEventTouchUpInside];
    backButton.showsTouchWhenHighlighted = YES;
	[backGroundView addSubview:backButton];

    
    //注册邮件输入框
    UIImageView * imageDLtext1 = [[UIImageView alloc] initWithFrame:CGRectMake(24, 71, 272, 29)];
    imageDLtext1.image = [UIImage imageNamed:@"TextField.png"];
    imageDLtext1.layer.masksToBounds = YES;
    imageDLtext1.layer.cornerRadius = 2.0f;
    imageDLtext1.layer.borderWidth = 0.5f;
    imageDLtext1.layer.borderColor = [[UIColor colorWithRed:0.722 green:0.537 blue:0.169 alpha:1.0] CGColor];
    [backGroundView addSubview:imageDLtext1];
    [imageDLtext1 release];
    emailTF = [[UITextField alloc] initWithFrame:CGRectMake(26, 71, 272, 29)];
    emailTF.backgroundColor = [UIColor clearColor];
    emailTF.font = [UIFont systemFontOfSize:14.0f];
    emailTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  
    emailTF.text = @"";
	emailTF.borderStyle = UITextBorderStyleNone;
	emailTF.placeholder = @" 请填写您的常用邮箱";
    emailTF.returnKeyType = UIReturnKeyNext;
	emailTF.keyboardType = UIKeyboardTypeEmailAddress;
    emailTF.keyboardAppearance = UIKeyboardAppearanceAlert;
	emailTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	//emailTF.secureTextEntry = YES;
    emailTF.delegate = self;
	emailTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailTF.tag = 2001;
    [backGroundView addSubview:emailTF];

    
    //注册密码输入框
    UIImageView * imageDLtext2 = [[UIImageView alloc] initWithFrame:CGRectMake(24, 113, 272, 29)];
    imageDLtext2.image = [UIImage imageNamed:@"TextField.png"];
    imageDLtext2.layer.masksToBounds = YES;
    imageDLtext2.layer.cornerRadius = 2.0f;
    imageDLtext2.layer.borderWidth = 0.5f;
    imageDLtext2.layer.borderColor = [[UIColor colorWithRed:0.722 green:0.537 blue:0.169 alpha:1.0] CGColor];
    [backGroundView addSubview:imageDLtext2];
    [imageDLtext2 release];
    setPasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(26, 113, 272, 29)];
    setPasswordTF.backgroundColor = [UIColor clearColor];
    setPasswordTF.font = [UIFont systemFontOfSize:14.0f];
    setPasswordTF.text = @"";
    setPasswordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    setPasswordTF.placeholder = @" 请输入6—16位密码";
    setPasswordTF.borderStyle = UITextBorderStyleNone;
    setPasswordTF.keyboardType = UIKeyboardTypeEmailAddress;
    setPasswordTF.keyboardAppearance = UIKeyboardAppearanceAlert;
    setPasswordTF.returnKeyType = UIReturnKeyNext;
    setPasswordTF.secureTextEntry = YES;
    setPasswordTF.delegate = self;
    setPasswordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    setPasswordTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    setPasswordTF.tag = 2002;
    [backGroundView addSubview:setPasswordTF];
    
    UIImageView * imageDLtext3 = [[UIImageView alloc] initWithFrame:CGRectMake(24, 155, 272, 29)];
    imageDLtext3.image = [UIImage imageNamed:@"TextField.png"];
    imageDLtext3.layer.masksToBounds = YES;
    imageDLtext3.layer.cornerRadius = 2.0f;
    imageDLtext3.layer.borderWidth = 0.5f;
    imageDLtext3.layer.borderColor = [[UIColor colorWithRed:0.722 green:0.537 blue:0.169 alpha:1.0] CGColor];
    [backGroundView addSubview:imageDLtext3];
    [imageDLtext3 release];
    mobileTF = [[UITextField alloc] initWithFrame:CGRectMake(26, 155, 272, 29)];
    mobileTF.backgroundColor = [UIColor clearColor];
    mobileTF.font = [UIFont systemFontOfSize:14.0f];
    mobileTF.text = @"";
    mobileTF.placeholder = @" 手机号(仅用于售卖通知提醒)";
    mobileTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mobileTF.borderStyle = UITextBorderStyleNone;
    mobileTF.keyboardAppearance = UIKeyboardAppearanceAlert;
    mobileTF.returnKeyType = 	UIReturnKeyNext;
    mobileTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    //mobileTF.secureTextEntry = YES;
    mobileTF.delegate = self;
    mobileTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    mobileTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    mobileTF.tag = 2003;
    [backGroundView addSubview:mobileTF];

   
    //性别选择,是否接受售卖通知选择
    UILabel * sexLabel = [[UILabel alloc] init];
    sexLabel.text = @"性别";
    sexLabel.font = [UIFont systemFontOfSize:14];
    sexLabel.textColor = [UIColor whiteColor];
    sexLabel.frame = CGRectMake(30, 194, 80, 32);
    sexLabel.backgroundColor = [UIColor clearColor];
    [backGroundView addSubview:sexLabel];
    [sexLabel release];
    
    //isMale = FALSE;
    NSArray * segmentArray = [[NSArray alloc] initWithObjects:@"女士",@"男士", nil];
    sexSegmentedCtl = [[UISegmentedControl alloc] initWithItems:segmentArray];
    sexSegmentedCtl.frame = CGRectMake(167.5, 194, 127.5, 32);
    sexSegmentedCtl.segmentedControlStyle = UISegmentedControlStyleBezeled;
    sexSegmentedCtl.tintColor = [UIColor colorWithRed:0.518 green:0.518 blue:0.518 alpha:1.0];
    //sexSegmentedCtl.selectedSegmentIndex = 0;
    //sexSegmentedCtl.momentary = YES;
    sexSegmentedCtl.tag = 100;
    [sexSegmentedCtl addTarget:self action:@selector(doChooseGender:) forControlEvents:UIControlEventValueChanged];
    
    /*
    for (UIView * aview  in [sexSegmentedCtl subviews]) {
        
        //[aview removeFromSuperview];
        NSLog(@"aview = %@ ",aview);
        for (UIView * bview  in [aview subviews]){
        NSLog(@"bview = %@ ",bview);
            if ([bview isKindOfClass:[UILabel class]]) {
                UILabel * LABEL_b = (UILabel *)bview;
                LABEL_b.backgroundColor = [UIColor clearColor];
                LABEL_b.textColor = [UIColor colorWithRed:0.42f green:0.424f blue:0.431f alpha:1.0f];
                //[bview removeFromSuperview];
            }
            if ([bview isKindOfClass:[UIImageView class]]) {
                UIImageView * IMAGE_b = (UIImageView *)bview;
                IMAGE_b.image = nil;
                [bview removeFromSuperview];
            }
                       
        }
    }
*/ 
    //sexSegmentedCtl.tintColor = [UIColor colorWithRed:0.875 green:0.882 blue:0.894 alpha:1.0];
    [backGroundView addSubview:sexSegmentedCtl];
    [segmentArray release];
    //[sexSegmentedCtl release];
    

    UILabel * noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = @"售卖通知";
    noticeLabel.font = [UIFont systemFontOfSize:14];
    noticeLabel.textColor = [UIColor whiteColor];
    noticeLabel.frame = CGRectMake(30, 233, 100, 32);
    noticeLabel.backgroundColor = [UIColor clearColor];
    [backGroundView addSubview:noticeLabel];
    [noticeLabel release];
    
    soldNotice = TRUE;
    NSArray * noticeArray = [[NSArray alloc] initWithObjects:@"开启",@"关闭", nil];
    UISegmentedControl * npticeSegmentedCtl = [[UISegmentedControl alloc] initWithItems:noticeArray];
    npticeSegmentedCtl.frame = CGRectMake(167.5, 233, 127.5, 32);
    npticeSegmentedCtl.segmentedControlStyle = UISegmentedControlStyleBezeled;
    npticeSegmentedCtl.tag = 101;
    npticeSegmentedCtl.selectedSegmentIndex = 0;

    [npticeSegmentedCtl addTarget:self action:@selector(doChooseGender:) forControlEvents:UIControlEventValueChanged];
    /*
     for (UIView * aview  in [sexSegmentedCtl subviews]) {
     
     //[aview removeFromSuperview];
     NSLog(@"aview = %@ ",aview);
     for (UIView * bview  in [aview subviews]){
     NSLog(@"bview = %@ ",bview);
     if ([bview isKindOfClass:[UILabel class]]) {
     UILabel * LABEL_b = (UILabel *)bview;
     LABEL_b.backgroundColor = [UIColor clearColor];
     LABEL_b.textColor = [UIColor colorWithRed:0.42f green:0.424f blue:0.431f alpha:1.0f];
     //[bview removeFromSuperview];
     }
     if ([bview isKindOfClass:[UIImageView class]]) {
     UIImageView * IMAGE_b = (UIImageView *)bview;
     IMAGE_b.image = nil;
     [bview removeFromSuperview];
     }
     
     }
     }
     */ 
    npticeSegmentedCtl.tintColor = [UIColor colorWithRed:0.518 green:0.518 blue:0.518 alpha:1.0];
    [backGroundView addSubview:npticeSegmentedCtl];
    [noticeArray release];
    [npticeSegmentedCtl release];

    
    
 
    
    
    
    
//    UILabel * fuwuLabel = [[UILabel alloc] init];
//    fuwuLabel.text = @"服务条款";
//    fuwuLabel.font = [UIFont systemFontOfSize:14];
//    fuwuLabel.textColor = [UIColor whiteColor];
//    fuwuLabel.frame = CGRectMake(30, 259, 100, 32);
//    fuwuLabel.backgroundColor = [UIColor clearColor];
//    [registerView addSubview:fuwuLabel];
//    [fuwuLabel release];
   
    UIImage * lightImage = [[UIImage imageNamed:@"RegBuuton_light_mid.png"] stretchableImageWithLeftCapWidth:1.0f topCapHeight:0.0f];
    UIImage * darkImage = [[UIImage imageNamed:@"GrayButton_mid.png"] stretchableImageWithLeftCapWidth:1.0f topCapHeight:0.0f];
    
    
    conformClause = YES;
    UIImageView * selImageView = [[UIImageView alloc] initWithFrame:CGRectMake(26, 283, 15, 15)];
    selImageView.image = [UIImage imageNamed:@"CheckBox.png"];
    selImageView.layer.masksToBounds = YES;
    selImageView.layer.cornerRadius = 3.0f;
    selImageView.layer.borderWidth = 0.1f;
    selImageView.layer.borderColor = [[UIColor blackColor]CGColor];
    [backGroundView addSubview:selImageView];
    [selImageView release];

    clauseImgV = [[UIImageView alloc] initWithFrame:CGRectMake(26, 283, 15, 15)];
    clauseImgV.image = [UIImage imageNamed:@"CheckMark.png"];
    [backGroundView addSubview:clauseImgV];

    UIButton * selButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selButton.frame = CGRectMake(19, 277, 30, 30);
    [selButton addTarget:self action:@selector(doConformClause) forControlEvents:UIControlEventTouchUpInside];
    [backGroundView addSubview:selButton];

    
    UILabel * readSawLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 274, 180, 32)];
    readSawLabel.text = @"我已阅读和接受服务款";
    readSawLabel.backgroundColor = [UIColor clearColor];
    readSawLabel.textColor = [UIColor whiteColor];
    readSawLabel.font = [UIFont systemFontOfSize:14.0f];
    [backGroundView addSubview:readSawLabel];
    [readSawLabel release];
    
    UIButton *readButton = [UIButton buttonWithType:UIButtonTypeCustom];
	readButton.frame = CGRectMake(227.5, 274, 67.5, 32);
    readButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [readButton setTitle:@"阅 读" forState:UIControlStateNormal];
    [readButton setTitle:@"阅 读" forState:UIControlStateHighlighted];
    [readButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [readButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [readButton setBackgroundImage:lightImage forState:UIControlStateNormal];
	[readButton setBackgroundImage:darkImage forState:UIControlStateHighlighted];
    readButton.showsTouchWhenHighlighted = YES;
    readButton.layer.masksToBounds = YES;
    readButton.layer.cornerRadius = 5.0f;
    readButton.layer.borderWidth = 1.0f;
    readButton.layer.borderColor = [[UIColor colorWithRed:0.412 green:0.416 blue:0.416 alpha:1.0f]CGColor];
	[readButton addTarget:self action:@selector(doRead:) forControlEvents:UIControlEventTouchUpInside];
	[backGroundView addSubview:readButton];

    
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	registerButton.frame =CGRectMake(25, 316, 270, 35);
    registerButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [registerButton setTitle:@"立即成为会员" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage * d_m_image = [UIImage imageNamed:@"YellowButtonBig.png"];
    UIImage * loginBtuImage = [d_m_image stretchableImageWithLeftCapWidth:4.0f topCapHeight:0.0f];
    [registerButton setBackgroundImage:loginBtuImage forState:UIControlStateNormal];
    [registerButton setBackgroundImage:loginBtuImage forState:UIControlStateHighlighted];
    registerButton.showsTouchWhenHighlighted = YES;
    registerButton.layer.masksToBounds = YES;
    registerButton.layer.cornerRadius = 3.0f;
    registerButton.layer.borderWidth = 0.2f;
	[registerButton addTarget:self action:@selector(doRegisterNow) forControlEvents:UIControlEventTouchUpInside];
	[backGroundView addSubview:registerButton];

    
  

    UILabel * huiyuanLabel = [[UILabel alloc] init];
    NSString * str = @"我已经是尚品会员";
    huiyuanLabel.text =str;// @"我已经是尚品会员";
    huiyuanLabel.font = [UIFont systemFontOfSize:14];
    huiyuanLabel.textColor = [UIColor whiteColor];
    CGSize  sizeA = [str sizeWithFont:huiyuanLabel.font];
    huiyuanLabel.frame = CGRectMake(30, 366, sizeA.width, 32);
    huiyuanLabel.backgroundColor = [UIColor clearColor];
    [backGroundView addSubview:huiyuanLabel];
    [huiyuanLabel release];
    
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
	loginButton.frame = CGRectMake(167.5, 366, 127.5, 32);
    loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginButton setTitle:@"登  录" forState:UIControlStateNormal];
    [loginButton setTitle:@"登  录" forState:UIControlStateHighlighted];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:darkImage forState:UIControlStateNormal];
	[loginButton setBackgroundImage:lightImage forState:UIControlStateHighlighted];
    loginButton.showsTouchWhenHighlighted = YES;
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 3.0f;
    loginButton.layer.borderWidth = 1.0f;
    loginButton.layer.borderColor = [[UIColor colorWithRed:0.412 green:0.416 blue:0.416 alpha:1.0f]CGColor];
	[loginButton addTarget:self action:@selector(backToLoginView) forControlEvents:UIControlEventTouchUpInside];
	[backGroundView addSubview:loginButton];

    self.view = registerView;
    [registerView release];
}

-(void) backToLoginView
{
    [self.view removeFromSuperview];
    emailTF.text = nil;
    setPasswordTF.text = nil;
    mobileTF.text = nil;
    genderValue = -1;
    sexSegmentedCtl.selectedSegmentIndex = UISegmentedControlNoSegment;
    //sexSegmentedCtl.selectedSegmentIndex = 2;
    doSelectSex = FALSE;
    
    //用户邮箱输入框重新找回焦点
    LogInViewController *loginViewController = [LogInViewController defaultLoginViewController];
    [loginViewController.userNameTF becomeFirstResponder];
    
    NSLog(@"返回登陆界面");
    //sexSegmentedCtl.momentary = YES;
 }

#pragma mark -
#pragma mark 性别选择   是否接受条款   是否接收售卖通知
-(void) doChooseGender:(UISegmentedControl *)choosedButton		//设置性别与售卖通知
{
    int flag = choosedButton.tag;
	if(flag == 100) //性别选择
	{
		doSelectSex = TRUE;
        if (choosedButton.selectedSegmentIndex == 0) 
        {
            genderValue = 0;
        }
        else
        {
            genderValue = 1;
        }
       NSLog(@"ismale:%d",genderValue); 		
    
	}
	else //if(flag == 101)		//售卖通知
	{
		if (choosedButton.selectedSegmentIndex == 0) 
        {
            soldNotice = YES;
        }
        else
        {
            soldNotice = NO;
        }
        NSLog(@"notice:%d",soldNotice);
	}
	[self keyboardReturn];
	
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
//
//-(void) doSoldNotice			//是否接尚品售卖收邮件通知
//{
//	if(soldNotice)
//	{
//		soldNoticeImgV.hidden = YES;
//		soldNotice = NO;
//	}
//	else
//	{
//		soldNoticeImgV.hidden = NO;
//		soldNotice = YES;
//	}
//	[self keyboardReturn];
//	NSLog(@"soldNotice = %d",soldNotice);
//}



#pragma mark -
#pragma mark 阅读条款   立即注册

-(void) doRead:(id)sender
{
	[self keyboardReturn];
	if(clauseView == nil)
	{
		clauseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
		clauseView.backgroundColor = [UIColor blackColor];
				
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        imgV.image = [UIImage imageNamed:@"AllowBackground.jpg"];
        imgV.alpha = 1.0f;
        [clauseView addSubview:imgV];
        [imgV release];
        
        //条款窗口
        UIImageView * imageDL = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 300, 413)];
        UIImage * imagere = [UIImage imageNamed:@"Layer_DownRound.png"];
        imageDL.image = [imagere stretchableImageWithLeftCapWidth:0.0f topCapHeight:20.0f];
        //imageDL.backgroundColor = [UIColor colorWithRed:0.882 green:0.882 blue:0.882 alpha:0.7];
        imageDL.layer.masksToBounds = YES;
        imageDL.layer.cornerRadius = 8.0f;
        [clauseView addSubview:imageDL];
        [imageDL release];
        
        UIImageView * imageDLtitle = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 300, 30)];
        imageDLtitle.image = [UIImage imageNamed:@"AllowTitle.png"];
        [clauseView addSubview:imageDLtitle];
        [imageDLtitle release];
        UILabel * sawLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 300, 30)];
        sawLabel.text = @"注 册 会 员 条 款";
        sawLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        sawLabel.backgroundColor = [UIColor clearColor];
        sawLabel.textAlignment = UITextAlignmentCenter;
        sawLabel.textColor = [UIColor whiteColor];
         [clauseView addSubview:sawLabel];
         [sawLabel release];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(280, 30, 20, 20);
        [closeButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeClause) forControlEvents:UIControlEventTouchUpInside];
        closeButton.showsTouchWhenHighlighted = YES;
        [clauseView addSubview:closeButton];


		UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(17, 60, 285, 365)];
		textView.editable = NO;
        textView.font = [UIFont systemFontOfSize:13];
		textView.backgroundColor = [UIColor clearColor];
		textView.text = CLAUSE;
		[clauseView addSubview:textView];
		[textView release];
        
        //接受条款
//        conformClause = YES;
//        UIImageView * sawView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 410, 300, 40)];
//        UIImage * imagesaw = [UIImage imageNamed:@"登录_登陆框背景_下边框圆角.png"];
//        sawView.image = [imagesaw stretchableImageWithLeftCapWidth:0.0f topCapHeight:130.0f];
//        sawView.layer.masksToBounds = YES;
//        sawView.layer.cornerRadius = 8.0f;
//        [clauseView addSubview:sawView];
//        [sawView release];
//        UILabel * sawLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 410, 200, 40)];
//        sawLabel.text = @"我已阅读并遵守相关条款";
//        sawLabel.textColor = [UIColor whiteColor];
//        sawLabel.backgroundColor = [UIColor clearColor];
//        sawLabel.font = [UIFont systemFontOfSize:15.0f];
//        [clauseView addSubview:sawLabel];
//        [sawLabel release];
//        UIImageView * selImageView = [[UIImageView alloc] initWithFrame:CGRectMake(273, 420, 20, 20)];
//        selImageView.backgroundColor = [UIColor whiteColor];//colorWithRed:<#(CGFloat)#> green:<#(CGFloat)#> blue:<#(CGFloat)#> alpha:<#(CGFloat)#>]
//        selImageView.layer.masksToBounds = YES;
//        selImageView.layer.cornerRadius = 3.0f;
//        selImageView.layer.borderWidth = 1.0f;
//        selImageView.layer.borderColor = [[UIColor blackColor]CGColor];
//        [clauseView addSubview:selImageView];
//        [selImageView release];
        
//        clauseImgV = [[UIImageView alloc] initWithFrame:CGRectMake(273, 420, 20, 20)];
//        clauseImgV.image = [UIImage imageNamed:@"CheckMark.png"];
//        [clauseView addSubview:clauseImgV];

//        UIButton * selButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        selButton.frame = CGRectMake(273, 420, 30, 30);
//        [selButton addTarget:self action:@selector(doConformClause) forControlEvents:UIControlEventTouchUpInside];
//        [clauseView addSubview:selButton];
        
	}
	[self.view addSubview:clauseView];
}

-(void)closeClause
{
    [clauseView removeFromSuperview];
}

-(BOOL) validatePhone:(NSString*) aString
{
	NSString *phoneRegex = @"(1[0-9]{10})";
	NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];   
	return [phoneTest evaluateWithObject:aString];  
}


#pragma mark -
#pragma mark 数据存储
-(void) saveUserName
{
	NSString *email = emailTF.text;
	NSString *password = setPasswordTF.text;
    
    //    NSNumber * sexSegmentedCtlNum = [[NSNumber alloc] initWithUnsignedInteger:sexSegmentedCtl.selectedSegmentIndex];
    //    NSString *gender = [sexSegmentedCtlNum stringValue];
    NSDate * loginDate  =  [NSDate date];
	NSMutableArray *m_array = [[NSMutableArray alloc] initWithObjects:email,password,loginDate,nil];
    //    [sexSegmentedCtlNum release];
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]; 
	NSString *filename = [path stringByAppendingPathComponent:@"userEmail"];
	[NSKeyedArchiver archiveRootObject:m_array toFile:filename];
	[m_array release];
}

//发送登陆成功的通知    接收类为MyAccountViewController
- (void)loginSuccessNotice
{
    NSNotificationCenter * noticeCenter2 = [NSNotificationCenter defaultCenter];
    NSString * const LoginSuccess = @"LoginSuccess";
    [noticeCenter2 postNotificationName:LoginSuccess object:self];
    NSLog(@"登录成功通知");
    
}



-(void) doRegisterNow
{
	
   
    [self keyboardReturn];	
	
    [self saveUserName];    
	
    if(conformClause)
	{
		NSString *email = [Trim trim:emailTF.text];
		NSString *setPassword = [Trim trim:setPasswordTF.text];
//		NSString *commitPassword = [Trim trim:commitPasswordTF.text];
		NSString *realName = @"";//[Trim trim:realNameTF.text];
		NSString *mobile = [Trim trim:mobileTF.text];
		
		if(([email length] == 0) || ([setPassword length] == 0) || ([mobile length] == 0))
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写全部注册信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
/*提示用户选择性别*/

		else if(doSelectSex == FALSE)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请您选择性别" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
 
		else if([self validatePhone:mobile] == FALSE)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"对不起,您的手机号码不符合要求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}		
		else
		{
			NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@|%@|%d|%d",email,setPassword,realName,mobile,genderValue/*gender*/,soldNotice];
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
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提醒" message:@"您必须遵守条款才能注册成为尚品会员" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
   
}

-(void)getAccountInfo
{
	
    NSLog(@"HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH------次");
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
	NSLog(@" 获得服务器 回应");
	NSMutableData * nData = [[NSMutableData alloc] init];
    self.receivedData = nData;
    [nData release];
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
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"恭喜您成为尚品会员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 510;
			[alert show];
			[alert release];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 511;
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
            //[self loginSuccessNotice];
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
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"自动登录超时，请手动登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
			usleep(10000000);
			[self getAccountInfo];
            NSLog(@"这是重新开始发送请求吗？  str = %@",str);
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
            
            GDataXMLElement * gender = [[root elementsForName:@"gender"] objectAtIndex:0];   //用户性别
            account.gender = [gender stringValue];//NSNumber
            
            GDataXMLElement  * level = [[root elementsForName:@"level"]objectAtIndex:0];
            account.leavelStr = [level stringValue];
            
            NSLog(@"用户性别 ：%@",account.gender);
			
			NSLog(@"real name : %@",account.realName);
			[document release];
			
            [self loginSuccessNotice];
            
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
		[self doLogin];
	}
}

#pragma mark -
#pragma mark 登录
-(void) doLogin
{
	OnlyAccount *account = [OnlyAccount defaultAccount];
	account.account = emailTF.text;
	account.password = setPasswordTF.text;
	ShangPinAppDelegate *shangPin = (ShangPinAppDelegate *)[UIApplication sharedApplication].delegate;
	shangPin.userName = account.account;
	shangPin.password = account.password;
	if(remoteNotification == TRUE)
	{
		remoteNotification = FALSE;
		[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	}
	//[self saveUserName];
	
	NSString *parameters = [NSString stringWithFormat:@"%@|%@|0",emailTF.text,setPasswordTF.text];
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
    
    emailTF.text = nil;
    setPasswordTF.text = nil;
    mobileTF.text = nil;
    sexSegmentedCtl.selectedSegmentIndex = UISegmentedControlNoSegment;
    //sexSegmentedCtl.selectedSegmentIndex = 2;
    genderValue = -1;
    doSelectSex = FALSE;
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
