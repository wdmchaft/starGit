    //
//  MyAlertViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyAlertViewController.h"
#import "MyPrompt.h"
#import "GDataXMLNode.h"

@implementation MyAlertViewController
@synthesize receivedData;
@synthesize promptArray;
@synthesize subjectNos;
@synthesize flags;


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
	self.title = @"我的提醒";
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
    
	UIView *myAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	myAlertView.backgroundColor = [UIColor blackColor];
	
	m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStylePlain];
	m_tableView.backgroundColor = [UIColor blackColor];
	m_tableView.dataSource = self;
	m_tableView.delegate = self;
	m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[myAlertView addSubview:m_tableView];
	
	self.view = myAlertView;
	[myAlertView release];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.promptArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"indexCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x110.png"]];

		UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 112, 50)];
		imgV.tag = 200;
		[cell.contentView addSubview:imgV];
		[imgV release];
		
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 200, 20)];
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.font = [UIFont systemFontOfSize:14];
		nameLabel.tag = 202;
		nameLabel.textColor = WORDCOLOR;
		[cell.contentView addSubview:nameLabel];
		[nameLabel release];
		
		UILabel *pushLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 70, 20)];
		pushLabel.backgroundColor = [UIColor clearColor];
		pushLabel.font = [UIFont systemFontOfSize:14];
		pushLabel.textColor = WORDCOLOR;
		pushLabel.text = @"Push提醒";
		[cell.contentView addSubview:pushLabel];
		[pushLabel release];
		
		UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(210, 30, 80, 20)];
		switchControl.tag = 201;
		[cell.contentView addSubview:switchControl];
		[switchControl release];
		
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 20)];
		dateLabel.backgroundColor = [UIColor clearColor];
		dateLabel.textAlignment = UITextAlignmentCenter;
		dateLabel.textColor = WORDCOLOR;
		dateLabel.font = [UIFont systemFontOfSize:15];
		dateLabel.tag = 199;
		[cell.contentView addSubview:dateLabel];
		[dateLabel release];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	MyPrompt *myprompt = [self.promptArray objectAtIndex:indexPath.row];
	NSArray *dateArray = [myprompt.date componentsSeparatedByString:@","];
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:199];
	dateLabel.text = [NSString stringWithFormat:@"时间:%@-%@",[dateArray objectAtIndex:0],[dateArray objectAtIndex:1]];
	
	UIImageView *imgV = (UIImageView *)[cell.contentView viewWithTag:200];
	[ImageCacheManager setImg:imgV withUrlString:myprompt.img];
	
	UISwitch *alertSwitch = (UISwitch *)[cell.contentView viewWithTag:201];
	NSLog(@"----%@",myprompt.push);
	alertSwitch.on = [myprompt.push intValue];
	
	
	
	UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:202];
	nameLabel.text = myprompt.name;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 85;
}

#pragma mark -
#pragma mark 保存
-(void) doSave
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	UITableViewCell *cell = nil;
	self.subjectNos = nil;
	self.flags = nil;
	for(int i = 0; i < [self.promptArray count]; i++)
	{
		MyPrompt *prompt = [self.promptArray objectAtIndex:i];
		cell = [m_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		UISwitch *theSwitch = (UISwitch *)[cell.contentView viewWithTag:201];
		if(self.subjectNos == nil)
		{
			self.subjectNos = prompt.promptID;
			self.flags = [NSString stringWithFormat:@"%d",theSwitch.on];
		}
		else
		{
			self.subjectNos = [NSString stringWithFormat:@"%@,%@",self.subjectNos,prompt.promptID];
			self.flags = [NSString stringWithFormat:@"%@,%@",self.flags,[NSString stringWithFormat:@"%d",theSwitch.on]];
		}
	}
	NSLog(@"\n%@\n%@",self.subjectNos,self.flags);
	[pool release];
	
	self.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@",account.account,self.subjectNos,self.flags];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	[MobClick event:[NSString stringWithFormat:@"MyPromptSave"] label:@"subjectNos"];
	
	NSString *myPromptSave = [NSString stringWithFormat:@"%@=MyPromptSave&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"我的提醒保存:%@",myPromptSave);
	NSURL *myPromptSaveUrl = [[NSURL alloc] initWithString:myPromptSave];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:myPromptSaveUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:loadingView];
	myPromptSaveConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[myPromptSaveUrl release];
}

#pragma mark -
#pragma mark 获得我的提醒列表
-(void) getMyPromptList
{
	self.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@",account.account];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	NSString *myPrompt = [NSString stringWithFormat:@"%@=MyPrompt&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"我的账户中-我的提醒:%@",myPrompt);
	NSURL *myPromptUrl = [[NSURL alloc] initWithString:myPrompt];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:myPromptUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:loadingView];
	myPromptConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[myPromptUrl release];
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
	if(myPromptConnection == connection)
	{
		NSError *error = nil;
		GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
		
		if(error)
		{
			[document release];
			[myPromptConnection release];
			return;
		}
		GDataXMLElement *root = [document rootElement];
		NSArray *array = [root elementsForName:@"myprompt"];//各个提醒
		NSMutableArray * pArray = [[NSMutableArray alloc]init];
        self.promptArray = pArray;
        [pArray release];
		for(GDataXMLElement *myprompt in array)
		{
			MyPrompt *theMyPrompt = [[MyPrompt alloc] init];
			GDataXMLElement *ID = [[myprompt elementsForName:@"id"] objectAtIndex:0];
			theMyPrompt.promptID = [ID stringValue];	//提醒的id
			GDataXMLElement *date = [[myprompt elementsForName:@"date"] objectAtIndex:0];
			theMyPrompt.date = [date stringValue];		//活动的日期
			GDataXMLElement *push = [[myprompt elementsForName:@"push"] objectAtIndex:0];
			theMyPrompt.push = [push stringValue];		//提醒的状态
			GDataXMLElement *img = [[myprompt elementsForName:@"image"] objectAtIndex:0];
			theMyPrompt.img = [img stringValue];		//活动的图片
			GDataXMLElement *name = [[myprompt elementsForName:@"name"] objectAtIndex:0];
			theMyPrompt.name = [name stringValue];		//活动名称
			
            if ([[theMyPrompt push] isEqualToString:@"1"]) {
                [self.promptArray addObject:theMyPrompt];
            }
            
			[theMyPrompt release];
		}
		NSLog(@"promptArray count= %d",[promptArray count]);
		[m_tableView reloadData];
		[document release];
		[myPromptConnection release];
		self.navigationItem.leftBarButtonItem.enabled = YES;
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
	
	if(myPromptSaveConnection == connection)
	{
		NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
		char flag = [str characterAtIndex:0];
		if(flag == '1')
		{
			if ([self.promptArray count]!=0) 
            {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"成功保存提醒设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
            }
		}
		else
		{
            if ([self.promptArray count]!=0) 
            {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""	message:@"保存提示设置失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
            }
		}
		[myPromptSaveConnection release];
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
	[m_tableView release];
	self.promptArray = nil;
	self.receivedData = nil;
	self.subjectNos = nil;
	self.flags = nil;
	
    [super dealloc];
}


@end
