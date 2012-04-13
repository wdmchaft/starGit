//
//  InviteRecord.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InviteRecord.h"
#import "GDataXMLNode.h"
#import "Record.h"


@implementation InviteRecord
@synthesize inviteRecordDelegate;
@synthesize recordArray;
@synthesize receivedData;

#pragma mark -
#pragma mark 邀请记录视图 初始化

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        self.backgroundColor = [UIColor blackColor];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = WORDCOLOR;
		label.text = @"我成功邀请的好友";
		[self addSubview:label];
		[label release];
        NSMutableArray * pArray = [[NSMutableArray alloc]init];
		self.recordArray = pArray;
        [pArray release];
		m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, 367 - 30 - 121) style:UITableViewStyleGrouped];
		m_tableView.backgroundColor = [UIColor clearColor];
		m_tableView.dataSource = self;
		m_tableView.delegate = self;
		[self addSubview:m_tableView];
    }
    return self;
}

#pragma mark -
#pragma mark 加载邀请记录列表

-(void) loadInviteRecord
{
	NSMutableArray * nArray = [[NSMutableArray alloc] init];
    self.recordArray = nArray;
    [nArray release];
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@",account.account,@"1",@"50"];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	[MobClick event:@"Inviterecords"];
	
	NSString *inviterecords = [NSString stringWithFormat:@"%@=Inviterecords&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"邀请记录:%@",inviterecords);
	NSURL *inviterecordsUrl = [[NSURL alloc] initWithString:inviterecords];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:inviterecordsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 246)];
	[self addSubview:loadingView];
	inviteConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[inviterecordsUrl release];
}


#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDatasource

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [self.recordArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
		cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x65.png"]];
		// 好友联系方式
		UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10, 70, 20.0f)];
		label1.backgroundColor = [UIColor clearColor];
		label1.font = [UIFont boldSystemFontOfSize:14.0f];
		label1.textColor = WORDCOLOR;
		label1.text = @"好友姓名:";
		UILabel *methodLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 210, 20.0f)];
		methodLabel.backgroundColor = [UIColor clearColor];
		methodLabel.tag = 101;
		methodLabel.textColor = WORDCOLOR;
		methodLabel.font = [UIFont boldSystemFontOfSize:14.0f];
		
		// 注册时间
		UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 60, 20)];
		label2.backgroundColor = [UIColor clearColor];
		label2.textColor = WORDCOLOR;
		label2.text = @"注册时间:";
		label2.font = [UIFont systemFontOfSize:14.0f];
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 35, 230.0f, 20)];
		dateLabel.backgroundColor = [UIColor clearColor];
		dateLabel.tag = 102;
		dateLabel.textColor = WORDCOLOR;
		dateLabel.font = [UIFont systemFontOfSize:14.0f];
		
		[cell.contentView addSubview:label1];
		[cell.contentView addSubview:methodLabel];
		[cell.contentView addSubview:label2];
		[cell.contentView addSubview:dateLabel];
		
		[label1 release];
		[methodLabel release];
		[label2 release];
		[dateLabel release];
	}
	
	Record *record = [self.recordArray objectAtIndex:indexPath.row];
	
	UILabel *methodLabel = (UILabel *)[cell.contentView viewWithTag:101];
	methodLabel.text = record.contactway;
	
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:102];
	dateLabel.text = record.time;
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 65;
}

#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"邀请记录列表 获得服务器 回应");
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
	NSError *error = nil;
	GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
	
	if(error)
	{
		[document release];
		[inviteConnection release];
		return;
	}
	GDataXMLElement *root = [document rootElement];
	NSArray *array = [root elementsForName:@"record"];//各个邀请记录
	for(GDataXMLElement *record in array)
	{
		Record *theRecord = [[Record alloc] init];
		GDataXMLElement *time = [[record elementsForName:@"time"] objectAtIndex:0];
		theRecord.time = [time stringValue];//好友注册时间
		GDataXMLElement *contactway = [[record elementsForName:@"contactway"] objectAtIndex:0];
		theRecord.contactway = [contactway stringValue];//好友联系方式
		[self.recordArray addObject:theRecord];
		[theRecord release];
	}
	
	[m_tableView reloadData];
	[document release];
	[inviteConnection release];
	self.receivedData = nil;
	[inviteRecordDelegate didInviteRecordFinishLaunching];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[inviteRecordDelegate didInviteRecordFinishLaunching];
	[inviteConnection release];
	self.receivedData = nil;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark 邀请记录 释放相关

- (void)dealloc
{
	[m_tableView release];
	[recordArray release];
	self.receivedData = nil;
    [super dealloc];
}


@end
