    //
//  ConsigneeInfoViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConsigneeInfoViewController.h"
#import "ConfirmInfoViewController.h"
#import "Receiver.h"
#import "AddressListViewController.h"
#import "ProvinceViewController.h"

@implementation ConsigneeInfoViewController
@synthesize receiverArray;
@synthesize voucherUrlStr;
@synthesize defaultReceiver;
@synthesize consigneeid;
@synthesize provinceid;
@synthesize cityid;
@synthesize areaid;
@synthesize delegate;
@synthesize proNO;

#pragma mark -
#pragma mark UITextFieldDelegate

//- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
//{
//	if (textField.frame.origin.y > 135) {
//		[UIView beginAnimations:@"up" context:nil];
//		[UIView setAnimationDuration:.25f];
//		
//		self.view.frame = CGRectMake(0,- (textField.frame.origin.y - 158), 320, 400);
//		
//		[UIView commitAnimations];
//	}
//	
//	return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	[UIView beginAnimations:@"down" context:nil];
	[UIView setAnimationDuration:.25f];
	
	self.view.frame = CGRectMake(0, 0, 320, 400);
	
	[UIView commitAnimations];
	
	return YES;
}



#pragma mark -
#pragma mark 返回商品详情
- (void)returnBack
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 收货人信息 初始化

- (void)loadView
{
	self.navigationItem.title = @"收货人信息";
	
//	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	backButton.frame = CGRectMake(0, 0, 53, 29);
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [backButton setTitle:@"  返回" forState:UIControlStateNormal];
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

    
	//其他地址 按钮
	UIBarButtonItem *otherAddressBI = [[UIBarButtonItem alloc] initWithTitle:@"其他地址" style:UIBarButtonItemStyleBordered target:self action:@selector(otherAddressList)];
	self.navigationItem.rightBarButtonItem = otherAddressBI;
    [otherAddressBI release];
	
	UIScrollView *consigneeView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	consigneeView.backgroundColor = [UIColor blackColor];
    consigneeView.contentSize = CGSizeMake(320, 537);
    consigneeView.showsVerticalScrollIndicator = NO;
    consigneeView.showsHorizontalScrollIndicator = NO;
    //consigneeView.contentOffset = CGPointMake(0, 100);
	
	UIImageView *infoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 303)];
	infoImg.image = [UIImage imageNamed:@"consigneeInfo.png"];
	[consigneeView addSubview:infoImg];
	[infoImg release];
	
	//收货人姓名
	receiverTF = [[UITextField alloc] initWithFrame:CGRectMake(115, 15, 195, 24)];
	receiverTF.backgroundColor = [UIColor clearColor];
	receiverTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	receiverTF.font = [UIFont systemFontOfSize:16];
	receiverTF.borderStyle = UITextBorderStyleNone;
    receiverTF.keyboardAppearance = UIKeyboardAppearanceAlert;
	receiverTF.textColor = WORDCOLOR;
	receiverTF.text = @"";
	receiverTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	receiverTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	receiverTF.delegate = self;
	[consigneeView addSubview:receiverTF];
	//选择省市县的按钮
	UIButton *chossesAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
	chossesAddressButton.frame = CGRectMake(10, 55, 300, 30);
	[chossesAddressButton addTarget:self action:@selector(doChooseAddress) forControlEvents:UIControlEventTouchUpInside];
	[consigneeView addSubview:chossesAddressButton];
	//配送城市
	cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 91, 277, 29)];
	cityLabel.font = [UIFont systemFontOfSize:16];
	cityLabel.backgroundColor = [UIColor clearColor];
	cityLabel.textColor = WORDCOLOR;
	cityLabel.text = @"";
	[consigneeView addSubview:cityLabel];
	//详细地址
	addressTF = [[UITextField alloc] initWithFrame:CGRectMake(102, 138, 208, 25)];
	addressTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	addressTF.font = [UIFont systemFontOfSize:16];
	addressTF.backgroundColor = [UIColor clearColor];
	addressTF.borderStyle = UITextBorderStyleNone;
    addressTF.keyboardAppearance = UIKeyboardAppearanceAlert;
	addressTF.textColor = WORDCOLOR;
	addressTF.text = @"";
	addressTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	addressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	addressTF.delegate = self;
	[consigneeView addSubview:addressTF];
	//邮政编码
	postCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(102, 183, 208, 24)];
	postCodeTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	postCodeTF.font = [UIFont systemFontOfSize:16];
	postCodeTF.backgroundColor = [UIColor clearColor];
	postCodeTF.borderStyle = UITextBorderStyleNone;
    postCodeTF.keyboardAppearance = UIKeyboardAppearanceAlert;
	postCodeTF.textColor = WORDCOLOR;
	postCodeTF.text = @"";
	postCodeTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	postCodeTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	postCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	postCodeTF.delegate = self;
	[consigneeView addSubview:postCodeTF];
	//手机号码
	mobileTF = [[UITextField alloc] initWithFrame:CGRectMake(76, 215, 234, 24)];
	mobileTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	mobileTF.font = [UIFont systemFontOfSize:16];
	mobileTF.backgroundColor = [UIColor clearColor];
    mobileTF.keyboardAppearance = UIKeyboardAppearanceAlert;
	mobileTF.borderStyle = UITextBorderStyleNone;
	mobileTF.textColor = WORDCOLOR;
	mobileTF.text = @"";
	mobileTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	mobileTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	mobileTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	mobileTF.delegate = self;
	[consigneeView addSubview:mobileTF];
	//固定电话
	phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(102, 250, 208, 24)];
	phoneTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	phoneTF.font = [UIFont systemFontOfSize:16];
	phoneTF.backgroundColor = [UIColor clearColor];
	phoneTF.borderStyle = UITextBorderStyleNone;
    phoneTF.keyboardAppearance = UIKeyboardAppearanceAlert;
	phoneTF.textColor = WORDCOLOR;
	phoneTF.text = @"";
	phoneTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	phoneTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	phoneTF.delegate = self;
	[consigneeView addSubview:phoneTF];
	
	
	UIButton *confirmConsigneeInfo = [UIButton buttonWithType:UIButtonTypeCustom];
	confirmConsigneeInfo.frame = CGRectMake(10,300,300,33);
	[confirmConsigneeInfo setBackgroundImage:[UIImage imageNamed:@"ConfirmBtnNormal.png"] forState:UIControlStateNormal];
	[confirmConsigneeInfo setBackgroundImage:[UIImage imageNamed:@"ConfirmBtnClick.png"] forState:UIControlStateHighlighted];
	[confirmConsigneeInfo addTarget:self action:@selector(confirmConsigneeInfo) forControlEvents:UIControlEventTouchUpInside];
	[consigneeView addSubview:confirmConsigneeInfo];

	self.view = consigneeView;
	[consigneeView release];
}

#pragma mark -
#pragma mark 默认收获地址  切换到选中地址
-(void) defaultReceiverInfo
{
	for(Receiver *theReceiver in self.receiverArray)
	{
		if([theReceiver.isdefault isEqualToString:@"true"])
		{
			self.defaultReceiver = theReceiver;
			break;
		}
	}
	receiverTF.text = self.defaultReceiver.Name;
	cityLabel.text = [NameValue findAddressWithValue:self.defaultReceiver.city];
	NSArray *array = [self.defaultReceiver.city componentsSeparatedByString:@"-"];
	self.provinceid = [array objectAtIndex:0];
	self.cityid = [array objectAtIndex:1];
	self.areaid = [array objectAtIndex:2];
	addressTF.text = self.defaultReceiver.address;
	postCodeTF.text = self.defaultReceiver.postcode;
	mobileTF.text = self.defaultReceiver.mobile;
	if([self.defaultReceiver.phone isEqualToString:@"(null)"])
	{
		self.defaultReceiver.phone = @"";
	}
	phoneTF.text = self.defaultReceiver.phone;
	self.consigneeid = self.defaultReceiver.consigneeid;
	NSLog(@"consigneeid ＝ %@",self.consigneeid);
	if(self.consigneeid == nil)
	{
		self.consigneeid = @"";
	}
	NSLog(@"consigneeid ＝ %@",self.consigneeid);
}



-(void) changeToChoosedReceiver:(Receiver *)receiver
{
	self.defaultReceiver = receiver;
	receiverTF.text = self.defaultReceiver.Name;
	cityLabel.text = [NameValue findAddressWithValue:self.defaultReceiver.city];
	addressTF.text = self.defaultReceiver.address;
	postCodeTF.text = self.defaultReceiver.postcode;
	mobileTF.text = self.defaultReceiver.mobile;
	if([self.defaultReceiver.phone isEqualToString:@"(null)"])
	{
		self.defaultReceiver.phone = @"";
	}
	phoneTF.text = self.defaultReceiver.phone;
	self.consigneeid = self.defaultReceiver.consigneeid;
	NSLog(@"consigneeid ＝ %@",self.consigneeid);
}
#pragma mark -
#pragma mark 改变省市县地址
- (void)doChooseAddress
{
	NSLog(@"%s",__FUNCTION__);
    ProvinceViewController *proVC = [[ProvinceViewController alloc] init];
	proVC.ciVC = self;
	self.delegate = self;
	[self.navigationController pushViewController:proVC animated:YES];
	[proVC release];
}

#pragma mark -
#pragma mark 收货人的其他地址
-(void) otherAddressList
{
	AddressListViewController *addressListVC = [[AddressListViewController alloc] init];
	addressListVC.addressArray = self.receiverArray;
	addressListVC.CIVC = self;
	[self.navigationController pushViewController:addressListVC animated:YES];
	addressListVC.navigationItem.rightBarButtonItem = nil;
	[addressListVC showList];
	[addressListVC release];	
}

-(BOOL) validatePhone:(NSString*) aString
{
	NSString *phoneRegex = @"(1[0-9]{10})";
	NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];   
	return [phoneTest evaluateWithObject:aString];  
}

-(BOOL) validatePostcode:(NSString*) aString
{
	NSString *PostcodeRegex = @"([0-9]{6})";
	NSPredicate *PostcodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PostcodeRegex];   
	return [PostcodeTest evaluateWithObject:aString];  
}


#pragma mark -
#pragma mark 确认收货信息
- (void)confirmConsigneeInfo
{
	NSString *receiverName = [Trim trim:receiverTF.text];
	NSString *city = [Trim trim:cityLabel.text];
	NSString *address = [Trim trim:addressTF.text];
	NSString *postCode = [Trim trim:postCodeTF.text];
	NSString *mobile = [Trim trim:mobileTF.text];
	NSString *phone = [Trim trim:phoneTF.text];
	if([receiverName length] == 0 || [city length] == 0 || [address length] == 0 || [postCode length] == 0 || [mobile length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"为方便为您送货,请填写正确信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([self validatePostcode:postCode] == FALSE)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"邮政编码不符合要求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([self validatePhone:mobile] == FALSE)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"手机号码不符合要求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([phone length] != 0 && ([phone characterAtIndex:0] != '0'))
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"电话号码必须以0开头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		ConfirmInfoViewController *confirmVC = [[ConfirmInfoViewController alloc] init];
		confirmVC.voucherUrlStr = self.voucherUrlStr;
		confirmVC.productNo = self.proNO;
		confirmVC.consigneeId = self.consigneeid;
		confirmVC.receiveName = receiverName;
		confirmVC.proviceId = self.provinceid;
		confirmVC.cityId = self.cityid;
		confirmVC.areaId = self.areaid;
		confirmVC.address = address;
		confirmVC.postcode = postCode;
		confirmVC.mobile = mobile;
		confirmVC.phone = phone;
		[self.navigationController pushViewController:confirmVC animated:YES];
		[confirmVC release];
	}
}


#pragma mark -
#pragma mark ConsigneeVCDelegate
-(void) didFinishChooseAddressWithArray:(NSArray *)infoArray
{
	self.provinceid = [infoArray objectAtIndex:0];
	self.cityid = [infoArray objectAtIndex:1];
	self.areaid = [infoArray objectAtIndex:2];
	cityLabel.text = [infoArray objectAtIndex:3];
	NSLog(@"%@-%@-%@",self.provinceid,self.cityid,self.areaid);
}
#pragma mark -
#pragma mark 收货地址 释放相关

- (void)dealloc
{
	[receiverTF release];
	[cityLabel release];
	[addressTF release];
	[postCodeTF release];
	[mobileTF release];
	[phoneTF release];
	self.consigneeid = nil;
	self.provinceid = nil;
	self.cityid = nil;
	self.areaid = nil;
	self.proNO = nil;
	self.receiverArray = nil;
	self.voucherUrlStr = nil;
	self.defaultReceiver = nil;
	
    [super dealloc];
}


@end
