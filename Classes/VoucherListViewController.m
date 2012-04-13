    //
//  VoucherListViewController.m
//  ShangPin
//
//  Created by cyy on 11-3-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VoucherListViewController.h"
#import "GDataXMLNode.h"


@implementation VoucherListViewController
@synthesize receivedData;
@synthesize voucherArray,voucherCodeArray,voucherEndDate,voucherStartDate;
@synthesize voucherUrlStr;
@synthesize voucher;
@synthesize delegate;

#pragma mark -
#pragma mark 关闭  保存

- (void)returnBack
{
	selectVoucher = -1;
	self.voucher = @"";
	[self dismissModalViewControllerAnimated:YES];
}

- (void)save
{
	[delegate didSaveVoucher:self.voucher];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 键盘回收
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark 代金券列表 初始化

- (void)loadView 
{
	self.title = @"确认订单";
	UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(returnBack)];
	self.navigationItem.leftBarButtonItem = left;
	[left release];
	UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = right;
	[right release];
	
	
	
	UIView *voucherListV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
	voucherListV.backgroundColor = [UIColor blackColor];
	
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 230, 30)];
	imageView.image = [UIImage imageNamed:@"RechargeTF.png"];
	[voucherListV addSubview:imageView];
	[imageView release];
	
	voucherTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, 25, 224, 30)];
	voucherTextField.borderStyle = UITextBorderStyleNone;
	voucherTextField.font = [UIFont systemFontOfSize:16];
	voucherTextField.textColor = WORDCOLOR;
	voucherTextField.placeholder = @"代金券充值码";
	voucherTextField.text = @"";
	voucherTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	voucherTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	voucherTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	voucherTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	voucherTextField.delegate = self;
	[voucherListV addSubview:voucherTextField];
	
	UIButton *activation = [UIButton buttonWithType:UIButtonTypeCustom];
	activation.frame = CGRectMake(250.f, 25, 60, 30);
    activation.titleLabel.font = [UIFont systemFontOfSize:14];
    [activation setTitle:@"激活" forState:UIControlStateNormal];
    [activation setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [activation setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
	[activation setBackgroundImage:[UIImage imageNamed:@"LoginNormal.png"] forState:UIControlStateNormal];
	[activation setBackgroundImage:[UIImage imageNamed:@"LoginClick.png"] forState:UIControlStateHighlighted];
	[activation addTarget:self action:@selector(activation) forControlEvents:UIControlEventTouchUpInside];
	[voucherListV addSubview:activation];
	
	UILabel *voucherListLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, 20)];
	voucherListLabel.backgroundColor = [UIColor clearColor];
	voucherListLabel.font = [UIFont systemFontOfSize:16];
	voucherListLabel.textColor = WORDCOLOR;
	voucherListLabel.text = @"代金券列表";
	[voucherListV addSubview:voucherListLabel];
	[voucherListLabel release];
	
	voucherListTB = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, 320, 300) style:UITableViewStyleGrouped];
	voucherListTB.delegate = self;
	voucherListTB.dataSource = self;
	voucherListTB.backgroundColor = [UIColor clearColor];
	[voucherListV addSubview:voucherListTB];
	
	selectVoucher = -1;
	self.voucher = @"";
	self.view = voucherListV;
	[voucherListV release];
}


#pragma mark -
#pragma mark 更新代金券列表  激活代金券
-(void) voucherListConnection
{
	self.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	NSLog(@"可用代金券:%@",self.voucherUrlStr);
	NSURL *voucherUrl = [[NSURL alloc] initWithString:self.voucherUrlStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:voucherUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:loadingView];
	voucherListConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[voucherUrl release];
}


- (void)activation
{
	[self textFieldShouldReturn:voucherTextField];
	if( ([voucherTextField.text length] != 8) && ([voucherTextField.text length] != 10) && ([voucherTextField.text length] != 12))
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"激活码位数不对" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		self.navigationItem.leftBarButtonItem.enabled = NO;
		self.navigationItem.rightBarButtonItem.enabled = NO;
		OnlyAccount *account = [OnlyAccount defaultAccount];
		NSString *parameters = [NSString stringWithFormat:@"%@|%@",account.account,voucherTextField.text];
		NSString *encodedString = [URLEncode encodeUrlStr:parameters];
		NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
		
		[MobClick event:@"CouponActivate"];
		
		NSString *activate = [NSString stringWithFormat:@"%@=Activate&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
		NSLog(@"激活代金券:%@",activate);
		NSURL *activateUrl = [[NSURL alloc] initWithString:activate];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:activateUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 246)];
		[self.view addSubview:loadingView];
		activationConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[request release];
		[activateUrl release];
	}
}

#pragma mark -
#pragma mark tableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.voucherArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{		
	int row = indexPath.row;
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
	if(cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
		cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x60.png"]];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.textLabel.textColor = WORDCOLOR;
		
		cell.detailTextLabel.backgroundColor = [UIColor clearColor];
		cell.detailTextLabel.textColor = [UIColor redColor];
	}
	cell.textLabel.text = [self.voucherArray objectAtIndex:row];
	NSArray *beginDate = [[self.voucherStartDate objectAtIndex:row] componentsSeparatedByString:@" "];
	NSArray *endDate = [[self.voucherEndDate objectAtIndex:row] componentsSeparatedByString:@" "];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"有效期 %@ 至 %@",[beginDate objectAtIndex:0],[endDate objectAtIndex:0]];
	cell.accessoryType = (row == selectVoucher) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = indexPath.row;
	if([self.voucherArray count] != 0)
	{
		for(int i = 0; i < [self.voucherArray count]; i++)
		{
			if(i != row);
			{
				NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
				UITableViewCell *otherCell = [tableView cellForRowAtIndexPath:otherIndexPath];
				otherCell.accessoryType = UITableViewCellAccessoryNone;
			}
		}
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		selectVoucher = row;
		self.voucher = [self.voucherCodeArray objectAtIndex:selectVoucher];
		NSLog(@"使用的代金券:%@",self.voucher);
	}
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
	if(connection == voucherListConnection)
	{
		NSError *error = nil;
		GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
		
		if(error)
		{
			[document release];
			[voucherListConnection release];
			return;
		}
		
		GDataXMLElement *root = [document rootElement];
		voucherArray = [[NSMutableArray alloc] init];
		voucherCodeArray = [[NSMutableArray alloc] init];
        voucherEndDate = [[NSMutableArray alloc] init];
		voucherStartDate = [[NSMutableArray alloc] init];
		NSArray *array = [root elementsForName:@"voucher"];
		for(GDataXMLElement *theVoucher in array)
		{
			GDataXMLElement *type = [[theVoucher elementsForName:@"type"] objectAtIndex:0];
			[self.voucherArray addObject:[type stringValue]];
			GDataXMLElement *cashticketno = [[theVoucher elementsForName:@"cashticketno"] objectAtIndex:0];
			[self.voucherCodeArray addObject:[cashticketno stringValue]];
			GDataXMLElement *dateend = [[theVoucher elementsForName:@"dateend"] objectAtIndex:0];
			[self.voucherEndDate addObject:[dateend stringValue]];
			GDataXMLElement *datestart = [[theVoucher elementsForName:@"datestart"] objectAtIndex:0];
			[self.voucherStartDate addObject:[datestart stringValue]];
		}
		[voucherListTB reloadData];
		[document release];
		[voucherListConnection release];
		self.navigationItem.leftBarButtonItem.enabled = YES;
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
	
	if (connection == activationConnection) {
		NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
		char flag = [str characterAtIndex:0];
		if(flag == '1')
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"代金券激活成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""	message:@"激活失败,请检查输入是否正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		[activationConnection release];
		self.navigationItem.leftBarButtonItem.enabled = YES;
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
	
	self.receivedData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
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
		[self voucherListConnection];
	}
}


- (void)dealloc
{
    
    self.voucherCodeArray = nil;
    self.voucherUrlStr = nil;
	self.voucherArray = nil;
    self.voucherEndDate = nil;
    self.voucherStartDate = nil;
	self.voucher = nil;
	self.receivedData = nil;
    [super dealloc];
}


@end
