    //
//  AddressViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddressViewController.h"
#import "GDataXMLNode.h"
#import "Address.h"
#import "ProvinceViewController.h"

@implementation AddressViewController
@synthesize receivedData;
@synthesize consigneeid;
@synthesize provinceid;
@synthesize cityid;
@synthesize areaid;
@synthesize delegate;
@synthesize promptStr;
#pragma mark -
#pragma mark 键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField.tag<3005) {
        [textField resignFirstResponder];
        UITextField * textFieldDawn = (UITextField *)[addressView viewWithTag:[textField tag]+1];
        [textFieldDawn becomeFirstResponder];
         return NO;
    }
    else{
        [UIView beginAnimations:@"scroll" context:nil];
        [UIView setAnimationDuration:0.25];
        CGRect frame = CGRectMake(0, 0, 320, 480);
        self.view.frame = frame;
        [UIView commitAnimations];
        [textField resignFirstResponder];
        return YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	float y = textField.frame.origin.y;
	if(y >= 130&&y<=252)
	{
        [UIView beginAnimations:@"scroll" context:nil];
		[UIView setAnimationDuration:0.25];
        [addressView setContentOffset:CGPointMake(addressView.contentOffset.x, y-94) animated:YES];
//		CGRect frame = CGRectMake(0, -(textField.frame.origin.y -130), 320, 480);
//		self.view.frame = frame; 
        [UIView commitAnimations];
	}
//	else
//	{
//		NSLog(@"zidongyidong____2");
//        [UIView beginAnimations:@"scroll" context:nil];
//		[UIView setAnimationDuration:0.25];
////		CGRect frame = CGRectMake(0, 0, 320, 480);
////		self.view.frame = frame; 
//		[addressView setContentOffset:CGPointMake(0, 0) animated:YES];
//        [UIView commitAnimations];
//	}
	return YES;
}

#pragma mark -
#pragma mark 返回 收货地址列表
- (void)returnBack
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 初始化方法
static AddressViewController *AVC = nil;
+(AddressViewController *)defaultAVC
{
	if(AVC == nil)
	{
		AVC = [[AddressViewController alloc] init];
	}
	return AVC;
}

- (void)loadView 
{
	self.title = @"收货地址";
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
	
//	UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
//	addressView.backgroundColor = [UIColor blackColor];
    addressView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	addressView.backgroundColor = [UIColor blackColor];
    addressView.contentSize = CGSizeMake(320, 490);
    addressView.showsVerticalScrollIndicator = NO;
    addressView.showsHorizontalScrollIndicator = NO;
    //addressView.contentOffset = CGPointMake(0, 80);
	
	
    
    UIImageView *bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 287)];
	bgImgV.image = [UIImage imageNamed:@"AddressBG.png"];
	[addressView addSubview:bgImgV];
	[bgImgV release];
	
	//收货人姓名
	receiverTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 14, 220, 26)];
	receiverTF.backgroundColor = [UIColor clearColor];
	receiverTF.borderStyle = UITextBorderStyleNone;
    receiverTF.returnKeyType = 	UIReturnKeyNext;
	receiverTF.textColor = WORDCOLOR;
	receiverTF.text = @"";
	receiverTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	receiverTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    receiverTF.tag = 3001;
	receiverTF.delegate = self;
	[addressView addSubview:receiverTF];
	
	UIButton *chossesAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
	chossesAddressButton.frame = CGRectMake(90, 53, 220, 35);
	[chossesAddressButton addTarget:self action:@selector(doChooseAddress) forControlEvents:UIControlEventTouchUpInside];
	[addressView addSubview:chossesAddressButton];
	
	//配送城市
	cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 91, 220, 26)];
	cityLabel.backgroundColor = [UIColor clearColor];
	cityLabel.textColor = WORDCOLOR;
	cityLabel.text = @"";
	[addressView addSubview:cityLabel];
	//详细地址
	addressTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 134, 220, 26)];
	addressTF.backgroundColor = [UIColor clearColor];
	addressTF.borderStyle = UITextBorderStyleNone;
    addressTF.returnKeyType = UIReturnKeyNext;
	addressTF.textColor = WORDCOLOR;
	addressTF.text = @"";
	addressTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	addressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    addressTF.tag = 3002;
	addressTF.delegate = self;
	[addressView addSubview:addressTF];
	//邮政编码
	postCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 174, 220, 26)];
	postCodeTF.backgroundColor = [UIColor clearColor];
	postCodeTF.borderStyle = UITextBorderStyleNone;
    postCodeTF.returnKeyType = UIReturnKeyNext;
	postCodeTF.textColor = WORDCOLOR;
	postCodeTF.text = @"";
	postCodeTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	postCodeTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	postCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    postCodeTF.tag = 3003;
	postCodeTF.delegate = self;
	[addressView addSubview:postCodeTF];

	//手机号码
	mobileTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 214, 220, 26)];
	mobileTF.backgroundColor = [UIColor clearColor];
	mobileTF.borderStyle = UITextBorderStyleNone;
    mobileTF.returnKeyType = UIReturnKeyNext;
	mobileTF.textColor = WORDCOLOR;
	mobileTF.text = @"";
	mobileTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	mobileTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	mobileTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    mobileTF.tag = 3004;
	mobileTF.delegate = self;
	[addressView addSubview:mobileTF];
	//电话号码
	phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 252.5f, 220, 26)];
	phoneTF.backgroundColor = [UIColor clearColor];
	phoneTF.borderStyle = UITextBorderStyleNone;
    phoneTF.returnKeyType = UIReturnKeyDone;
	phoneTF.textColor = WORDCOLOR;
	phoneTF.text = @"";
	phoneTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	phoneTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTF.tag = 3005;
	phoneTF.delegate = self;
	[addressView addSubview:phoneTF];
	
    self.promptStr = @"修改";
	self.view = addressView;
	[addressView release];
}

#pragma mark -
#pragma mark 选择省市县
-(void) doChooseAddress
{
	ProvinceViewController *proVC = [[ProvinceViewController alloc] init];
	proVC.aVC = self;
	self.delegate = self;
	[self.navigationController pushViewController:proVC animated:YES];
	[proVC release];
}

-(BOOL) validatePostcode:(NSString*) aString
{
	NSString *PostcodeRegex = @"([0-9]{6})";
	NSPredicate *PostcodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PostcodeRegex];   
	return [PostcodeTest evaluateWithObject:aString];  
}

-(BOOL) validatePhone:(NSString*) aString
{
	NSString *phoneRegex = @"(1[0-9]{10})";
	NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];   
	return [phoneTest evaluateWithObject:aString];  
}

#pragma mark -
#pragma mark 保存   显示收货地址
-(void) doSave
{
	NSString *name = [Trim trim:receiverTF.text];
	NSString *city = [Trim trim:cityLabel.text];
	NSString *address = [Trim trim:addressTF.text];
	NSString *postcode = [Trim trim:postCodeTF.text];
	NSString *phone = [Trim trim:phoneTF.text];
	NSString *mobile = [Trim trim:mobileTF.text];
	if([name length] == 0 || [city length] == 0 || [address length] == 0 || [postcode length] == 0 || [mobile length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"为方便为您送货,请填写正确信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([self validatePostcode:postcode] == FALSE)
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
		self.navigationItem.leftBarButtonItem.enabled = NO;
		self.navigationItem.rightBarButtonItem.enabled = NO;
		OnlyAccount *account = [OnlyAccount defaultAccount];
		NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@",self.consigneeid,account.account,name,self.provinceid,self.cityid,self.areaid,address,postcode,mobile,phone];
		NSLog(@"parameters = %@",parameters);
		NSString *encodedString = [URLEncode encodeUrlStr:parameters];
		NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
		
		[MobClick event:[NSString stringWithFormat:@"DeliveryAddressSave"] label:self.consigneeid]; 
		
		NSString *deliveryAddressSave = [NSString stringWithFormat:@"%@=DeliveryAddressSave&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
		NSLog(@"我的账户中保存收货地址（有更新和创建新地址两种可能）:%@",deliveryAddressSave);
		NSURL *deliveryAddressSaveUrl = [[NSURL alloc] initWithString:deliveryAddressSave];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:deliveryAddressSaveUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
		[self.view addSubview:loadingView];
		saveAddressConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[request release];
		[deliveryAddressSaveUrl release];
	}
}

-(void) showDetailAddress:(Address *)theAddress
{
	self.consigneeid = theAddress.consigneeid;
	NSLog(@"self.consigneeid = %@",consigneeid);
	if(self.consigneeid == nil)
	{
		self.consigneeid = @"";
	}
	NSArray *array = [theAddress.city componentsSeparatedByString:@"-"];
	if([array count] == 3)
	{
		self.provinceid = [NSString stringWithFormat:@"%d",[NameValue findProvinceValueFromName:[array objectAtIndex:0]]];
		self.cityid = [NSString stringWithFormat:@"%d",[NameValue findCityValueFromName:[array objectAtIndex:1]]];
		self.areaid = [NSString stringWithFormat:@"%d",[NameValue findAreaValueFromName:[array objectAtIndex:2]]];
		cityLabel.text = [NameValue findAddressWithValue:theAddress.city];
	}
	else
	{
		self.provinceid = @"";
		self.cityid = @"";
		self.areaid = @"";
		cityLabel.text = @"";
	}
	receiverTF.text = theAddress.Name;
	addressTF.text = theAddress.address;
	postCodeTF.text = theAddress.postcode;
	if([theAddress.phone isEqualToString:@"(null)"])
	{
		theAddress.phone = @"";
	}
	phoneTF.text = theAddress.phone;
	mobileTF.text = theAddress.mobile;
}

-(void) showBlank
{
	self.consigneeid = @"";
	self.provinceid = @"";
	self.cityid = @"";
	self.areaid = @"";
	receiverTF.text = @"";
	cityLabel.text = @"";
	addressTF.text = @"";
	postCodeTF.text = @"";
	phoneTF.text = @"";
	mobileTF.text = @"";
}

-(void)changePrompt
{
    self.promptStr = @"添加";
}

#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"保存收货地址 获得服务器 回应");
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
		//NSString *pro = [NSString stringWithFormat:@"成功%@收货地址",self.promptStr];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"成功%@收货地址",self.promptStr] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改收货地址失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	[saveAddressConnection release];
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	self.receivedData = nil;
    self.promptStr = @"修改";
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	[saveAddressConnection release];
	self.receivedData = nil;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	
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
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
}

#pragma mark -
#pragma mark AddressVCDelegate
-(void) didFinishChooseAddressArray:(NSArray *)infoArray
{
	self.provinceid = [infoArray objectAtIndex:0];
	self.cityid = [infoArray objectAtIndex:1];
	self.areaid = [infoArray objectAtIndex:2];
	cityLabel.text = [infoArray objectAtIndex:3];
	NSLog(@"%@-%@-%@",self.provinceid,self.cityid,self.areaid);
}
#pragma mark -
#pragma mark 释放相关

- (void)dealloc 
{
	[receiverTF release];
	[cityLabel release];
	[addressTF release];
	[postCodeTF release];
	[phoneTF release];
	[mobileTF release];
	
	self.receivedData = nil;
	self.consigneeid = nil;
	self.provinceid = nil;
	self.cityid = nil;
	self.areaid = nil;
    [super dealloc];
}


@end
