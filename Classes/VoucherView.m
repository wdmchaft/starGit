//
//  VoucherView.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VoucherView.h"
#import "Voucher.h"
#import "GDataXMLNode.h"
#import "CustomLabel.h"

@implementation VoucherView
@synthesize voucherDelegate;
@synthesize rechargeTF;
@synthesize voucherArray;
@synthesize receivedData;

#pragma mark -
#pragma mark 键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark 初始化 代金券视图
- (id)initWithFrame:(CGRect)frame 
{    
    self = [super initWithFrame:frame];
    if (self) 
	{
		self.backgroundColor = [UIColor blackColor];
		
        UILabel *voucherRecharge = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 16)];
		voucherRecharge.backgroundColor = [UIColor clearColor];
		voucherRecharge.textColor = WORDCOLOR;
		voucherRecharge.font = [UIFont boldSystemFontOfSize:16];
		voucherRecharge.text = @"代金券充值";
		[self addSubview:voucherRecharge];
		[voucherRecharge release];
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 230, 30)];
		imageView.image = [UIImage imageNamed:@"RechargeTF.png"];
		[self addSubview:imageView];
		[imageView release];
		
		//代金券充值码 输入框
		rechargeTF = [[UITextField alloc] initWithFrame:CGRectMake(16, 40, 224, 23)];
		rechargeTF.borderStyle = UITextBorderStyleNone;
		rechargeTF.font = [UIFont systemFontOfSize:16];
		rechargeTF.textColor = WORDCOLOR;
		rechargeTF.placeholder = @"代金券充值码";
		rechargeTF.text = @"";
		rechargeTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		rechargeTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
		rechargeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
		rechargeTF.delegate = self;
		[self addSubview:rechargeTF];
		
		//激活按钮
		UIButton *activityButton = [UIButton buttonWithType:UIButtonTypeCustom];
		activityButton.frame = CGRectMake(250, 35, 60, 30);
        activityButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [activityButton setTitle:@"激活" forState:UIControlStateNormal];
        [activityButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [activityButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [activityButton setBackgroundImage:[UIImage imageNamed:@"LoginNormal.png"] forState:UIControlStateNormal];
        [activityButton setBackgroundImage:[UIImage imageNamed:@"LoginClick.png"] forState:UIControlStateHighlighted];
		[activityButton addTarget:self action:@selector(doActive) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:activityButton];
		
		UILabel *listLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 100, 18)];
		listLabel.backgroundColor = [UIColor clearColor];
		listLabel.textColor = WORDCOLOR;
		listLabel.font = [UIFont boldSystemFontOfSize:18];
		listLabel.text = @"代金券列表";
		[self addSubview:listLabel];
		[listLabel release];
		
		//代金券 列表
		NSMutableArray * newArray = [[NSMutableArray alloc] init];
        self.voucherArray = newArray;
        [newArray release];
		m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 95, 320, 367 - 95 - 121) style:UITableViewStyleGrouped];
		m_tableView.backgroundColor = [UIColor blackColor];
		m_tableView.dataSource = self;
		m_tableView.delegate = self;
		[self addSubview:m_tableView];
    }
    return self;
}

#pragma mark -
#pragma mark 激活代金券  加载代金券列表

-(void) doActive
{
	if([rechargeTF isFirstResponder])
	{
		[rechargeTF resignFirstResponder];
	}
	if( ([rechargeTF.text length] != 8) && ([rechargeTF.text length] != 10) && ([rechargeTF.text length] != 12))
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"激活码位数不对" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		OnlyAccount *account = [OnlyAccount defaultAccount];
		NSString *parameters = [NSString stringWithFormat:@"%@|%@",account.account,rechargeTF.text];
		NSString *encodedString = [URLEncode encodeUrlStr:parameters];
		NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
		
		[MobClick event:@"CouponActivate"];
		
		NSString *activate = [NSString stringWithFormat:@"%@=Activate&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
		NSLog(@"激活代金券:%@",activate);
		NSURL *activateUrl = [[NSURL alloc] initWithString:activate];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:activateUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 246)];
		[self addSubview:loadingView];
		activateConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[request release];
		[activateUrl release];
	}
}

-(void) loadVoucher
{
	NSMutableArray * newArray = [[NSMutableArray alloc] init];
    self.voucherArray = newArray;
    [newArray release];
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@",account.account,@"1",@"50"];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	[MobClick event:@"Coupons"];
	
	NSString *coupons = [NSString stringWithFormat:@"%@=Coupons&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"我的账户代金券:%@",coupons);
	NSURL *couponsUrl = [[NSURL alloc] initWithString:coupons];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:couponsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 246)];
	[self addSubview:loadingView];
	voucherConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[couponsUrl release];
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDatasource

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [self.voucherArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	if (!cell) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
		cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x80.png"]];
		// 代金券的名称
		CustomLabel *nameLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(10.0f, 10, 210, 40)];
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.verticalAlignment = VerticalAlignmentTop;
		nameLabel.tag = 100;
		nameLabel.numberOfLines = 0;
		nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
		nameLabel.textColor = WORDCOLOR;
		
		// 代金券的面值
		UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 40, 140.0f, 35)];
		moneyLabel.backgroundColor = [UIColor clearColor];
		moneyLabel.textAlignment = UITextAlignmentRight;
		moneyLabel.tag = 101;
		moneyLabel.textColor = [UIColor redColor];
		moneyLabel.font = [UIFont boldSystemFontOfSize:24.0f];
		
		// 代金券的有效期
		UILabel *dateLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(160.0f, 40, 130.0f, 15)];
		dateLabel1.backgroundColor = [UIColor clearColor];
		dateLabel1.tag = 102;
		dateLabel1.textColor = WORDCOLOR;
		dateLabel1.font = [UIFont systemFontOfSize:14.0f];
		
		UILabel *dateLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(160.0f, 55, 130.0f, 15)];
		dateLabel2.backgroundColor = [UIColor clearColor];
		dateLabel2.tag = 103;
		dateLabel2.textColor = WORDCOLOR;
		dateLabel2.font = [UIFont systemFontOfSize:14.0f];
		
		UILabel *isvalidLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 60, 20)];
		isvalidLabel.backgroundColor = [UIColor clearColor];
		isvalidLabel.textAlignment = UITextAlignmentCenter;
		isvalidLabel.tag = 104;
		isvalidLabel.textColor = [UIColor redColor];
		isvalidLabel.font = [UIFont systemFontOfSize:14];
		
		[cell.contentView addSubview:nameLabel];
		[cell.contentView addSubview:moneyLabel];
		[cell.contentView addSubview:dateLabel1];
		[cell.contentView addSubview:dateLabel2];
		[cell.contentView addSubview:isvalidLabel];
		
		[nameLabel release];
		[moneyLabel release];
		[dateLabel1 release];
		[dateLabel2 release];
		[isvalidLabel release];
	}
	Voucher *voucher = [self.voucherArray objectAtIndex:indexPath.row];
	
	CustomLabel *nameLabel = (CustomLabel *)[cell.contentView viewWithTag:100];
	nameLabel.text = voucher.Name;
	
	UILabel *moneyLabel = (UILabel *)[cell.contentView viewWithTag:101];
	moneyLabel.text = [NSString stringWithFormat:@"%@元",voucher.Type];
	
	NSArray *dateArray = [voucher.Date componentsSeparatedByString:@","];
	
	UILabel *dateLabel1 = (UILabel *)[cell.contentView viewWithTag:102];
	dateLabel1.text = [NSString stringWithFormat:@"有效期:%@",[dateArray objectAtIndex:0]];
	
	UILabel *dateLabel2 = (UILabel *)[cell.contentView viewWithTag:103];
	dateLabel2.text = [NSString stringWithFormat:@"       至:%@",[dateArray objectAtIndex:1]];

	UILabel *isvalidLabel = (UILabel *)[cell.contentView viewWithTag:104];
	if([voucher.isvalid isEqualToString:@"1"])
	{
		isvalidLabel.text = @"已使用";
	}
	else if([voucher.isvalid isEqualToString:@"0"])
	{
		isvalidLabel.text = @"未使用";
	}
	else
	{
		isvalidLabel.text = @"";
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80;
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
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	if(voucherConnection == connection)		//代金券列表
	{
		NSError *error = nil;
		GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
				
		if(error)
		{
			[document release];
			[voucherConnection release];
			return;
		}
		NSDateFormatter *formater = [[NSDateFormatter alloc] init];//设置日期格式 与服务器返回的时间格式一致，例如2011-2-4
		[formater setDateFormat:@"yyyy-M-d"];
		NSString *todayStr = [formater stringFromDate:[NSDate date]];
		
		GDataXMLElement *root = [document rootElement];
		NSArray *array = [root elementsForName:@"coupon"];
		for(GDataXMLElement *coupon in array)
		{
			Voucher *voucher = [[Voucher alloc] init];
			GDataXMLElement *type = [[coupon elementsForName:@"type"] objectAtIndex:0];
			voucher.Type = [type stringValue];		//代金券面值
			GDataXMLElement *name = [[coupon elementsForName:@"name"] objectAtIndex:0];
			voucher.Name = [name stringValue];		//代金券名称
			GDataXMLElement *date = [[coupon elementsForName:@"date"] objectAtIndex:0];
			voucher.Date = [date stringValue];		//代金券有效期 格式:2011-5-7,2011-6-6
			NSArray *array = [voucher.Date componentsSeparatedByString:@","];//根据","取出两部分时间
			NSString *str = [array objectAtIndex:1];//截止时间  与今天相比，看是否过期
			
			GDataXMLElement *isvalid = [[coupon elementsForName:@"isvalid"] objectAtIndex:0];
			voucher.isvalid = [isvalid stringValue];
			if([str compare:todayStr] == NSOrderedDescending)  //如果没过期
			{
				[self.voucherArray addObject:voucher];
			}
			
			[voucher release];
		}
		[formater release];
		[m_tableView reloadData];
		[voucherConnection release];
		[document release];
		[voucherDelegate didVoucherViewFinishLaunching];
	}
	
	if(activateConnection == connection)	//代金券激活
	{
		NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
		char flag = [str characterAtIndex:0];
		if(flag == '1')
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"代金券激活成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起"	message:@"激活失败,请检查输入是否正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		[activateConnection release];
	}
	
	self.receivedData = nil;
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[voucherDelegate didVoucherViewFinishLaunching];
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
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
	{
		[self loadVoucher];
	}
}

#pragma mark -
#pragma mark 代金券释放相关

- (void)dealloc 
{
	[rechargeTF release];
	[m_tableView release];
	[voucherArray release];
	self.receivedData = nil;
    [super dealloc];
}


@end
