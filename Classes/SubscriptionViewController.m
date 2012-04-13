    //
//  SubscriptionViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "CustomLabel.h"
#import "GDataXMLNode.h"


@implementation SubscriptionViewController
@synthesize receivedData;

//保存用户设置的数据到沙盒
-(void) saveArchives
{
	NSArray *dataArray = [NSArray arrayWithObjects: 
						  [NSNumber numberWithInt: m_valueArray[0]],
						  [NSNumber numberWithInt: m_valueArray[1]],
						  nil];
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]; 
	NSString *archiverFileName = [path stringByAppendingPathComponent:@"setvalue"];
	[NSKeyedArchiver archiveRootObject: dataArray toFile: archiverFileName];
}

//从沙盒中读取用户数据
-(void) getArchivers
{
	NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]; 
	NSString *fileName = [Path stringByAppendingPathComponent:@"setvalue"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:fileName])
	{
		NSArray *dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile: fileName];
		for(int i = 0; i < 2; i++)
		{
			m_valueArray[i] = [[dataArray objectAtIndex: i] intValue];
		}
	}
}
#pragma mark -
#pragma mark 返回 我的账户界面
- (void)returnBack
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 初始化

- (void)loadView 
{
	self.title = @"尚品订阅";
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.frame = CGRectMake(0, 0, 53, 29);
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton setTitle:@"  返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	[backButton setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	self.navigationItem.leftBarButtonItem = backItem;
	[backItem release];
	
	UIBarButtonItem *saveBI = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(doSave)];
	self.navigationItem.rightBarButtonItem = saveBI;
    [saveBI release];
	
	UIView *subscriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	subscriptionView.backgroundColor = [UIColor blackColor];
	
	//陈述   邮箱   手机号
	CustomLabel *descriptionLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
	descriptionLabel.backgroundColor = [UIColor clearColor];
	descriptionLabel.textColor = WORDCOLOR;
	descriptionLabel.text = @"   担心错过精彩的售卖活动？留下您的Email与手机号，在活动开始之前，尚品网会及时通知您！";
	descriptionLabel.numberOfLines = 0;
	descriptionLabel.font = [UIFont systemFontOfSize:14];
	descriptionLabel.verticalAlignment = VerticalAlignmentTop;
	[subscriptionView addSubview:descriptionLabel];
	[descriptionLabel release];
	
	
	UILabel *emailNoticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 165, 20)];
	emailNoticeLabel.backgroundColor = [UIColor clearColor];
	emailNoticeLabel.textColor = WORDCOLOR;
	emailNoticeLabel.font = [UIFont systemFontOfSize:14];
	emailNoticeLabel.text = @"我接收邮件通知的Email:";
	[subscriptionView addSubview:emailNoticeLabel];
	[emailNoticeLabel release];
	
	emailLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(170, 75, 135, 40)];
	emailLabel.backgroundColor = [UIColor clearColor];
	emailLabel.textColor = [UIColor whiteColor];
	emailLabel.numberOfLines = 0;
	emailLabel.verticalAlignment = VerticalAlignmentTop;
	emailLabel.font = [UIFont systemFontOfSize:14];
	[subscriptionView addSubview:emailLabel];
	
	UILabel *mobileNoticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 165, 20)];
	mobileNoticeLabel.backgroundColor = [UIColor clearColor];
	mobileNoticeLabel.textColor = WORDCOLOR;
	mobileNoticeLabel.font = [UIFont systemFontOfSize:14];
	mobileNoticeLabel.text = @"我接收短信通知的手机号:";
	[subscriptionView addSubview:mobileNoticeLabel];
	[mobileNoticeLabel release];
	
	mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, 55, 135, 20)];
	mobileLabel.backgroundColor = [UIColor clearColor];
	mobileLabel.textColor = [UIColor whiteColor];
	mobileLabel.font = [UIFont systemFontOfSize:14];
	[subscriptionView addSubview:mobileLabel];
	
	noticeTimeArray = [[NSArray alloc] initWithObjects:@"不再提醒",@"每日提醒",@"每周提醒",@"每月提醒",nil];
	//[self getArchivers];
	
	//通知方式 以及频率
	m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 115, 320, 252) style:UITableViewStyleGrouped];
	m_tableView.backgroundColor = [UIColor clearColor];
	m_tableView.dataSource = self;
	m_tableView.delegate = self;
	[subscriptionView addSubview:m_tableView];
	
	self.view = subscriptionView;
	[subscriptionView release];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section == 0)
	{
		return @"短信通知";
	}
	else
	{
		return @"邮件通知";
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [noticeTimeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = indexPath.section;
	
	static NSString *cellIdentifier = @"indexCell";
	static NSString *cellIdentifier2 = @"indexCell2";
	UITableViewCell *cell;
	
	if(section == 0)
	{
		cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if(cell == nil)
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
			cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x40.png"]];
		}
	}
	else
	{
		cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
		if(cell == nil)
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2] autorelease];
			cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x40.png"]];
		}
	}
	
	cell.textLabel.textColor = WORDCOLOR;
	cell.textLabel.text = [noticeTimeArray objectAtIndex:indexPath.row];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	cell.accessoryType = (indexPath.row == m_valueArray[indexPath.section]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = indexPath.row;
	int section = indexPath.section;
	
	for(int i = 0; i < 4; i++)
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
	
	m_valueArray[indexPath.section] = indexPath.row;
}

#pragma mark -
#pragma mark 保存
-(void) doSave
{
	mobileType = m_valueArray[0];
	emailType = m_valueArray[1];
	NSLog(@"mobileType = %d  emailType = %d",mobileType,emailType);
	//[self saveArchives];
	self.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@",account.account,[NSString stringWithFormat:@"%d",emailType],[NSString stringWithFormat:@"%d",mobileType]];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	[MobClick event:[NSString stringWithFormat:@"SetSubscribe"] label:[NSString stringWithFormat:@"mobile-%d email-%d",mobileType,emailType]];

	
	NSString *setSubscribe = [NSString stringWithFormat:@"%@=SetSubscribe&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"设置提醒周期:%@",setSubscribe);
	NSURL *setSubscribeUrl = [[NSURL alloc] initWithString:setSubscribe];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:setSubscribeUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:loadingView];
	subscribeSaveConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[setSubscribeUrl release];
}

#pragma mark -
#pragma mark 获得尚品订阅的相关信息
-(void) getSubscribeInfo
{
	self.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@",account.account];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	NSString *subscribe = [NSString stringWithFormat:@"%@=Subscribe&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"提醒设置显示:%@",subscribe);
	NSURL *subscribeUrl = [[NSURL alloc] initWithString:subscribe];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:subscribeUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:loadingView];
	subscribeConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[subscribeUrl release];
}

#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"我的提醒 获得服务器 回应");
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
	if(subscribeConnection == connection)
	{
		NSError *error = nil;
		GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
		
		if(error)
		{
			[document release];
			[subscribeConnection release];
			return;
		}
		GDataXMLElement *root = [document rootElement];
		
		GDataXMLElement *email = [[root elementsForName:@"email"] objectAtIndex:0];
		emailLabel.text = [email stringValue];		//接收订阅的邮箱地址
		GDataXMLElement *etype = [[root elementsForName:@"etype"] objectAtIndex:0];
		emailType = [[etype stringValue] intValue];	//邮件接收频率
		GDataXMLElement *mobile = [[root elementsForName:@"mobile"] objectAtIndex:0];
		mobileLabel.text = [mobile stringValue];	//接收订阅的手机号码
		GDataXMLElement *mtype = [[root elementsForName:@"mtype"] objectAtIndex:0];
		mobileType = [[mtype stringValue] intValue];//短信接收频率
		NSLog(@"emailType = %d mobileType = %d",emailType,mobileType);
		m_valueArray[0] = mobileType;
		m_valueArray[1] = emailType;
		[document release];
		[m_tableView reloadData];
		[subscribeConnection release];
		self.navigationItem.leftBarButtonItem.enabled = YES;
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
	
	if(subscribeSaveConnection == connection)
	{
		NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
		char flag = [str characterAtIndex:0];
		if(flag == '1')
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"成功保存订阅设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""	message:@"保存订阅设置失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		[subscribeSaveConnection release];
		self.navigationItem.leftBarButtonItem.enabled = YES;
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
	
	self.receivedData = nil;
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
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
#pragma mark 释放相关

- (void)dealloc 
{
	[emailLabel release];
	[mobileLabel release];
	[m_tableView release];
	[noticeTimeArray release];
	self.receivedData = nil;
    [super dealloc];
}


@end
