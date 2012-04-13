    //
//  MyOrderDetailViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyOrderDetailViewController.h"
#import "GDataXMLNode.h"
#import "CustomLabel.h"

@implementation MyOrderDetailViewController

@synthesize receivedData;
@synthesize orderID;
@synthesize delegate;

#pragma mark -
#pragma mark 返回 我的账户界面
- (void)returnBack
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 订单详情 初始化
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

    
	UIView *orderDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	orderDetailView.backgroundColor = [UIColor blackColor];
	
	//总金额
	UILabel *totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 60, 16)];
	totalMoneyLabel.backgroundColor = [UIColor clearColor];
	totalMoneyLabel.font = [UIFont boldSystemFontOfSize:16];
	totalMoneyLabel.textColor = [UIColor whiteColor];
	totalMoneyLabel.text = @"总金额:";
	[orderDetailView addSubview:totalMoneyLabel];
	[totalMoneyLabel release];

	totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 14, 100, 16)];
	totalLabel.backgroundColor = [UIColor clearColor];
	totalLabel.textColor = [UIColor whiteColor];
	totalLabel.font = [UIFont boldSystemFontOfSize:16];
	[orderDetailView addSubview:totalLabel];
	
	
	//代金券
	voucherMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 14, 70, 16)];
	voucherMoneyLabel.backgroundColor = [UIColor clearColor];
	voucherMoneyLabel.textColor = [UIColor whiteColor];
	voucherMoneyLabel.font = [UIFont boldSystemFontOfSize:16];
	voucherMoneyLabel.text = @"代金券:";
	voucherMoneyLabel.hidden = YES;
	[orderDetailView addSubview:voucherMoneyLabel];
	
	voucherLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 14, 50, 16)];
	voucherLabel.backgroundColor = [UIColor clearColor];
	voucherLabel.textColor = [UIColor whiteColor];
	voucherLabel.font = [UIFont boldSystemFontOfSize:16];
	voucherLabel.hidden = YES;
	[orderDetailView addSubview:voucherLabel];
	
	
	//支付状态
	UILabel *payStateLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 70, 16)];
	payStateLable.backgroundColor = [UIColor clearColor];
	payStateLable.textColor = [UIColor whiteColor];
	payStateLable.font = [UIFont boldSystemFontOfSize:16];
	payStateLable.text = @"支付状态:";
	[orderDetailView addSubview:payStateLable];
	[payStateLable release];
	
	payLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 150, 16)];
	payLabel.backgroundColor = [UIColor clearColor];
	payLabel.textColor = [UIColor lightGrayColor];
	payLabel.font = [UIFont boldSystemFontOfSize:16];
	[orderDetailView addSubview:payLabel];
	
	
	//订单状态
	UILabel *orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 66, 70, 16)];
	orderStateLabel.backgroundColor = [UIColor clearColor];
	orderStateLabel.textColor = [UIColor whiteColor];
	orderStateLabel.font = [UIFont boldSystemFontOfSize:16];
	orderStateLabel.text = @"订单状态:";
	[orderDetailView addSubview:orderStateLabel];
	[orderStateLabel release];
	
	orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 66, 150, 16)];
	orderLabel.backgroundColor = [UIColor clearColor];
	orderLabel.textColor = [UIColor lightGrayColor];
	orderLabel.font = [UIFont systemFontOfSize:16];
	[orderDetailView addSubview:orderLabel];
	
	//取消订单按钮
	cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	cancelButton.frame = CGRectMake(210, 64, 66, 20);
	cancelButton.hidden = YES;
	[cancelButton setBackgroundImage:[UIImage imageNamed:@"CancelNormal.png"] forState:UIControlStateNormal];
	[cancelButton setBackgroundImage:[UIImage imageNamed:@"CancelClick.png"] forState:UIControlStateHighlighted];
	[cancelButton addTarget:self action:@selector(doCancelOrder) forControlEvents:UIControlEventTouchUpInside];
	[orderDetailView addSubview:cancelButton];

	//收货详情
	addressScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 100, 300, 267)];
	addressScroll.backgroundColor = [UIColor darkGrayColor];
	addressScroll.layer.cornerRadius = 5;
	
	UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 300, 20)];
	detailLabel.textAlignment = UITextAlignmentCenter;
	detailLabel.backgroundColor = [UIColor clearColor];
	detailLabel.textColor = WORDCOLOR;
	detailLabel.font = [UIFont boldSystemFontOfSize:20];
	detailLabel.text = @"收货详情";
	[addressScroll addSubview:detailLabel];
	[detailLabel release];
	
	//收货人
	personLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 38, 280, 18)];
	personLabel.backgroundColor = [UIColor clearColor];
	personLabel.textColor = [UIColor lightGrayColor];
	personLabel.font = [UIFont systemFontOfSize:16];
	personLabel.text = @"收货人:";
	[addressScroll addSubview:personLabel];
	//收货地址
	addressLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 60, 280, 18)];
	addressLabel.backgroundColor = [UIColor clearColor];
	addressLabel.textColor = [UIColor lightGrayColor];
	addressLabel.numberOfLines = 0;
	addressLabel.verticalAlignment = VerticalAlignmentTop;
	addressLabel.font = [UIFont systemFontOfSize:16];
	addressLabel.text = @"收货地址:";
	[addressScroll addSubview:addressLabel];
	//邮政编码
	postcodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 82, 280, 18)];
	postcodeLabel.backgroundColor = [UIColor clearColor];
	postcodeLabel.textColor = [UIColor lightGrayColor];
	postcodeLabel.font = [UIFont systemFontOfSize:16];
	postcodeLabel.text = @"邮政编码:";
	[addressScroll addSubview:postcodeLabel];
	//联系电话
	phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 104, 280, 18)];
	phoneLabel.backgroundColor = [UIColor clearColor];
	phoneLabel.textColor = [UIColor lightGrayColor];
	phoneLabel.font = [UIFont systemFontOfSize:16];
	phoneLabel.text = @"联系电话:";
	[addressScroll addSubview:phoneLabel];
	//配送方式
	deliverymethodLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 126, 280, 18)];
	deliverymethodLabel.backgroundColor = [UIColor clearColor];
	deliverymethodLabel.textColor = [UIColor lightGrayColor];
	deliverymethodLabel.font = [UIFont systemFontOfSize:16];
	deliverymethodLabel.text = @"配送方式:";
	[addressScroll addSubview:deliverymethodLabel];
	//支付方式
	payMothedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 148, 280, 18)];
	payMothedLabel.backgroundColor = [UIColor clearColor];
	payMothedLabel.textColor = [UIColor lightGrayColor];
	payMothedLabel.font = [UIFont systemFontOfSize:16];
	payMothedLabel.text = @"支付方式:";
	[addressScroll addSubview:payMothedLabel];
	//备注
	memoLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 170, 280, 18)];
	memoLabel.backgroundColor = [UIColor clearColor];
	memoLabel.numberOfLines = 0;
	memoLabel.verticalAlignment = VerticalAlignmentTop;
	memoLabel.textColor = [UIColor lightGrayColor];
	memoLabel.font = [UIFont systemFontOfSize:16];
	memoLabel.text = @"备 注:";
	[addressScroll addSubview:memoLabel];
	//收货时间
	timeLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 192, 280, 18)];
	timeLabel.backgroundColor = [UIColor clearColor];
	timeLabel.numberOfLines = 0;
	timeLabel.verticalAlignment = VerticalAlignmentTop;
	timeLabel.textColor = [UIColor lightGrayColor];
	timeLabel.font = [UIFont systemFontOfSize:16];
	timeLabel.text = @"收货时间:";
	[addressScroll addSubview:timeLabel];
	
	[orderDetailView addSubview:addressScroll];

	self.view = orderDetailView;
	[orderDetailView release];
}

#pragma mark -
#pragma mark 取消订单  加载订单  

-(void) doCancelOrder
{
	self.navigationItem.leftBarButtonItem.enabled = NO;
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@|%@",account.account,self.orderID];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	[MobClick event:[NSString stringWithFormat:@"CancelOrder"] label:self.orderID];
	
	NSString *cancelOrder = [NSString stringWithFormat:@"%@=CancelOrder&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"取消订单:%@",cancelOrder);
	NSURL *cancelOrderUrl = [[NSURL alloc] initWithString:cancelOrder];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:cancelOrderUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:loadingView];
	cancelConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[cancelOrderUrl release];
}

-(void) loadOrderDetail:(NSString *) orderId
{
	self.navigationItem.leftBarButtonItem.enabled = NO;
	self.orderID = orderId;
	self.title = [NSString stringWithFormat:@"订单%@",orderId];
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@|%@",account.account,orderId];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	[MobClick event:[NSString stringWithFormat:@"Orderdetail"] label:orderId];

	
	NSString *orderdetail = [NSString stringWithFormat:@"%@=Orderdetail&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"订单明细:%@",orderdetail);
	NSURL *orderdetailUrl = [[NSURL alloc] initWithString:orderdetail];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:orderdetailUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:loadingView];
	detailConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[orderdetailUrl release];
}

-(float)contentHeight: (NSString *)string		//查看指定字符串的高度
{
	CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, 500) lineBreakMode:UILineBreakModeCharacterWrap];
	float height = size.height;
	return height;
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
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	if(detailConnection == connection)
	{
		NSError *error = nil;
		GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
		
		if(error)
		{
			[document release];
			[detailConnection release];
			return;
		}
		GDataXMLElement *root = [document rootElement];
		GDataXMLElement *orderstate = [[root elementsForName:@"orderstate"] objectAtIndex:0];
		orderLabel.text = [orderstate stringValue];		//订单状态
		
		GDataXMLElement *iscancel = [[root elementsForName:@"iscancel"] objectAtIndex:0];
		NSString *canCancel = [iscancel stringValue];
		if([canCancel isEqualToString:@"1"])
		{
			cancelButton.hidden = NO;
		}
		else
		{
			cancelButton.hidden = YES;
		}
		
		GDataXMLElement *paystate = [[root elementsForName:@"paystate"] objectAtIndex:0];
		payLabel.text = [paystate stringValue];			//支付状态
		GDataXMLElement *paymount = [[root elementsForName:@"paymount"] objectAtIndex:0];
		totalLabel.text = [paymount stringValue];		//支付总金额
		GDataXMLElement *isuseticket = [[root elementsForName:@"isuseticket"] objectAtIndex:0];
		NSString *hasVoucherUsed = [isuseticket stringValue];
		useVoucher = [hasVoucherUsed intValue];
		if(useVoucher)
		{
			voucherMoneyLabel.hidden = NO;
			voucherLabel.hidden = NO;
			GDataXMLElement *cashmount = [[root elementsForName:@"cashmount"] objectAtIndex:0];
			voucherLabel.text = [cashmount stringValue];//代金券金额
		}
		else
		{
			voucherMoneyLabel.hidden = YES;
			voucherLabel.hidden = YES;
		}
		
		//收货人地址
		GDataXMLElement *receiver = [[root elementsForName:@"receiver"] objectAtIndex:0];
		//收货人
		GDataXMLElement *name = [[receiver elementsForName:@"name"] objectAtIndex:0];
		personLabel.text = [NSString stringWithFormat:@"收货人:%@",[name stringValue]];
		//收货地址
		GDataXMLElement *address = [[receiver elementsForName:@"address"] objectAtIndex:0];
		NSString *addressStr = [NSString stringWithFormat:@"收货地址:%@",[address stringValue]];
		float addressHeight = [self contentHeight:addressStr];
		addressLabel.frame = CGRectMake(10, 60, 280, addressHeight);
		addressLabel.text = addressStr;
		//邮政编码
		GDataXMLElement *postcode = [[receiver elementsForName:@"postcode"] objectAtIndex:0];
		postcodeLabel.frame = CGRectMake(10, 64 + addressHeight, 280, 18);
		postcodeLabel.text = [NSString stringWithFormat:@"邮政编码:%@",[postcode stringValue]];
		//联系电话
		GDataXMLElement *phone = [[receiver elementsForName:@"phone"] objectAtIndex:0];
		phoneLabel.frame = CGRectMake(10, 86 + addressHeight, 280, 18);
		phoneLabel.text = [NSString stringWithFormat:@"联系电话:%@",[phone stringValue]];
		//配送方式
		GDataXMLElement *deliverymethod = [[receiver elementsForName:@"deliverymethod"] objectAtIndex:0];
		deliverymethodLabel.frame = CGRectMake(10, 108 + addressHeight, 280, 18);
		deliverymethodLabel.text = [NSString stringWithFormat:@"配送方式:%@",[deliverymethod stringValue]];
		//支付方式
		GDataXMLElement *paymode = [[receiver elementsForName:@"paymode"] objectAtIndex:0];
		payMothedLabel.frame = CGRectMake(10, 130 + addressHeight, 280, 18);
		payMothedLabel.text = [NSString stringWithFormat:@"支付方式:%@",[paymode stringValue]];
		//备注
		GDataXMLElement *memo = [[receiver elementsForName:@"memo"] objectAtIndex:0];
		NSString *memoStr = [NSString stringWithFormat:@"备注:%@",[memo stringValue]];
		float memoHeight = [self contentHeight:memoStr];
		memoLabel.frame = CGRectMake(10, 152 + addressHeight, 280, memoHeight);
		memoLabel.text = memoStr;
		//收货时间
		GDataXMLElement *time = [[receiver elementsForName:@"time"] objectAtIndex:0];
		NSString *timeStr = nil;
		switch ([[time stringValue] intValue]) 
		{
			case 1:
			{
				timeStr = [NSString stringWithFormat:@"收货时间:只工作日送货"];
				break;
			}
			case 2:
			{
				timeStr = [NSString stringWithFormat:@"收货时间:工作日、双休日与假日均可送货"];
				break;
			}
			case 3:
			{
				timeStr = [NSString stringWithFormat:@"收货时间:只双休日、假日送货"];
				break;
			}
		}
		float timeHeight = [self contentHeight:timeStr];
		timeLabel.frame = CGRectMake(10, 156 + addressHeight + memoHeight, 280, timeHeight);
		timeLabel.text = timeStr;
		
		[document release];
		[detailConnection release];
		self.navigationItem.leftBarButtonItem.enabled = YES;
	}
	
	if(cancelConnection == connection)
	{
		self.navigationItem.leftBarButtonItem.enabled = YES;
		NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
		char flag = [str characterAtIndex:0];
		if(flag == '1')
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"成功取消订单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""	message:@"未能取消订单" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		[cancelConnection release];
	}
	
	self.receivedData = nil;
	
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
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
	{
		[self returnBack];
		[delegate finishCancelOrder];
	}
}

#pragma mark -
#pragma mark 订单详情 释放相关

- (void)dealloc
{
	self.orderID = nil;
	[totalLabel release];
	[voucherMoneyLabel release];
	[voucherLabel release];
	[payLabel release];
	[orderLabel release];
	
	[addressScroll release];
	[personLabel release];
	[addressLabel release];
	[postcodeLabel release];
	[phoneLabel release];
	[deliverymethodLabel release];
	[payMothedLabel release];
	[memoLabel release];
	[timeLabel release];
	self.receivedData = nil;
	
    [super dealloc];
}


@end
