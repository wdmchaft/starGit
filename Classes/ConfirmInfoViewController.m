    //
//  ConfirmInfoViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConfirmInfoViewController.h"
#import "GDataXMLNode.h"

@implementation ConfirmInfoViewController
@synthesize voucherUrlStr;
@synthesize receivedData;
@synthesize productNo,consigneeId,receiveName,proviceId,cityId,areaId,address,postcode,phone,mobile,paymode,time,voucher,memo;

#pragma mark  -
#pragma mark textfield delegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
	[UIView beginAnimations:@"up" context:nil];
	[UIView setAnimationDuration:.25f];
	
	self.view.frame = CGRectMake(0, -140, 320, 400);
	
	[UIView commitAnimations];
	
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	[UIView beginAnimations:@"up" context:nil];
	[UIView setAnimationDuration:.25f];
	self.view.frame = CGRectMake(0,0, 320, 400);
	[UIView commitAnimations];
	
	return YES;
}

#pragma mark -
#pragma mark 返回收货人信息  代金券
- (void)returnBack
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void) useVoucher
{
	if(vlVC == nil)
	{
		vlVC = [[VoucherListViewController alloc] init];
		vlVC.voucherUrlStr = self.voucherUrlStr;
		vlVC.delegate = self;
	}
	UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vlVC];	
	nv.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	nv.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[self presentModalViewController:nv animated:YES];
	[vlVC voucherListConnection];
	[nv release];
	
}

#pragma mark -
#pragma mark 确认订单 初始化

- (void)loadView
{
	self.title = @"确认订单";
	//返回按钮
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

    
	//使用代金券
//	UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"使用代金券" style:UIBarButtonItemStylePlain target:self action:@selector(useVoucher)];
//	self.navigationItem.rightBarButtonItem = right;
//	[right release];
	
	UIView *confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	confirmView.backgroundColor = [UIColor clearColor];
	
	confirmTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, 320, 250) style:UITableViewStyleGrouped];
	confirmTableView.delegate = self;
	confirmTableView.dataSource = self;
	confirmTableView.backgroundColor = [UIColor clearColor];
	[confirmView addSubview:confirmTableView];
	
	UIImageView *memoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 259, 300, 26)];
	memoImgV.image = [UIImage imageNamed:@"Remark.png"];
	[confirmView addSubview:memoImgV];
	[memoImgV release];
	
	memoTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 260, 295, 24)];
	memoTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	memoTF.font = [UIFont systemFontOfSize:16];
	memoTF.borderStyle = UITextBorderStyleNone;
    memoTF.keyboardAppearance = UIKeyboardAppearanceAlert;
	memoTF.textColor = WORDCOLOR;
	memoTF.placeholder = @"备注";
	memoTF.text = @"";
	memoTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
	memoTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	memoTF.delegate = self;
	[confirmView addSubview:memoTF];
	
	
	self.paymode = @"2";
	self.time = @"1";
	self.voucher = @"";
	
	UIButton *refreOrder = [UIButton buttonWithType:UIButtonTypeCustom];
	refreOrder.frame = CGRectMake(10, 300, 300, 33);
	[refreOrder setBackgroundImage:[UIImage imageNamed:@"ReferOrderNormal.png"] forState:UIControlStateNormal];
	[refreOrder setBackgroundImage:[UIImage imageNamed:@"ReferOrderClick.png"] forState:UIControlStateHighlighted];
	[refreOrder addTarget:self action:@selector(refreOrder) forControlEvents:UIControlEventTouchUpInside];
	[confirmView addSubview:refreOrder];
	
	self.view = confirmView;
	[confirmView release];
}

#pragma mark -
#pragma mark tableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == 0)
	{
		return 1;
	}
	else
	{
		return 3;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{		
	int section = indexPath.section;
	int row = indexPath.row;
	
	static NSString *cellIdentifier = @"indexCell";
	static NSString *cellIdentifier2 = @"indexCell2";
	if(section == 0)
	{
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if(cell == nil)
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
			cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x40.png"]];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			cell.textLabel.text = @"货到付款";
			cell.textLabel.backgroundColor = [UIColor clearColor];
			cell.textLabel.textColor = WORDCOLOR;
		}
		return cell;
	}
	else
	{
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
		if(cell == nil)
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2] autorelease];
			cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x40.png"]];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			cell.textLabel.backgroundColor = [UIColor clearColor];
			cell.textLabel.textColor = WORDCOLOR;	
			cell.accessoryType = (row == selectTime) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
			switch(row)
			{
				case 0:
				{
					cell.textLabel.text = @"只工作日送货";
					break;
				}
				case 1:
				{
					cell.textLabel.text = @"工作日、双休日与假日均可送货";
					break;
				}
				case 2:
				{
					cell.textLabel.text = @"只双休日、假日送货";
					break;
				}
			}
		}
		return cell;

	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{	
	NSString *headerString = nil;
	
	switch (section) 
	{
		case 0:
			headerString = @"   确认您的支付方式";
			break;
		case 1:
			headerString = @"   您希望什么时间收货";
			break;
	}
	
	UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20.0f)];
	headerLabel.text = headerString;
	headerLabel.font = [UIFont systemFontOfSize:18.0f];
	headerLabel.textColor = WORDCOLOR;
	headerLabel.backgroundColor = [UIColor clearColor];
	
	return [headerLabel autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = indexPath.section;
	int row = indexPath.row;
	
	if(section == 1)
	{
		for(int i = 0; i < 3; i++)
		{
			if(i != row);
			{
				NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
				UITableViewCell *otherCell = [tableView cellForRowAtIndexPath:otherIndexPath];
				otherCell.accessoryType = UITableViewCellAccessoryNone;
			}
		}
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		selectTime = row;
		self.time = [NSString stringWithFormat:@"%d",selectTime+1];
		NSLog(@"收货时间：%@",self.time);
	}
}

#pragma mark -
#pragma mark 提交订单

- (void)refreOrder
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	self.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	self.memo = memoTF.text;
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@",
							self.productNo,self.consigneeId,account.account,self.receiveName,self.proviceId
							,self.cityId,self.areaId,self.address,self.postcode,self.phone,self.mobile,self.paymode,self.time,self.voucher,self.memo];
	NSLog(@"%@",parameters);
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	[MobClick event:[NSString stringWithFormat:@"SubmitOrder"] label:self.productNo];
	
	NSString *activate = [NSString stringWithFormat:@"%@=SubmitOrder&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"提交订单:%@",activate);
	NSURL *activateUrl = [[NSURL alloc] initWithString:activate];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:activateUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	[self.view addSubview:loadingView];
	submitConnect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[activateUrl release];
	
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
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
	NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
		
	NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
	char flag = [str characterAtIndex:0];
	if(flag == '1')
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"订单提交成功" message:@"您可到\"我的尚品\"查看订单详情" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""	message:@"抱歉，订单提交失败,请重新下单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	[submitConnect release];
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	self.receivedData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];	
	[submitConnect release];
	self.receivedData = nil;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
    self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;

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
#pragma mark 代金券

-(void)didSaveVoucher:(NSString *)theVoucher
{
	self.voucher = theVoucher;
	NSLog(@"self.voucher = %@",self.voucher);
}

#pragma mark -
#pragma mark 确认界面 释放相关

- (void)dealloc 
{
	[confirmTableView release];
	[memoTF release];
	[vlVC release];
	
	self.voucherUrlStr = nil;
    self.receivedData = nil;
	
	self.productNo = nil;
	self.consigneeId = nil;
	self.proviceId = nil;
	self.cityId = nil;
	self.areaId = nil;
	self.receiveName = nil;
	self.address = nil;
	self.postcode = nil;
	self.phone = nil;
	self.mobile = nil;
	self.paymode = nil;
	self.time = nil;
	self.voucher = nil;
	self.memo = nil;
	
	[super dealloc];
}


@end
