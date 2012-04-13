//
//  CalenderView.m
//  TestCalender
//
//  Created by cyy on 11-3-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalenderView0.h"
#import "DateButton.h"
#import "Calender.h"
#import "Willsale.h"
#import "CustomTableViewCell.h"
#import "GDataXMLNode.h"

@implementation CalenderView0
@synthesize calenderDelegate;
@synthesize calenderArray;
@synthesize activityArray;
@synthesize receivedData;


//初始化方法
- (id)initWithFrame:(CGRect)frame andArray:(NSMutableArray *)array
{
    
    self = [super initWithFrame:frame];
    if (self) 
	{
		self.calenderArray = array;
		self.backgroundColor = [UIColor blackColor];
		
		for(int i = 0; i < 7; i++)
		{
			Calender *calender = [self.calenderArray objectAtIndex:i];
			CGRect rect = CGRectMake(i * 45.9, 0, 49.5, 30);
			DateButton *button = [[DateButton alloc] initWithFrame:rect dateStr:calender.date andFlag:calender.hot];
			button.tag = 100+i;
			[button addTarget:self action:@selector(getPresellList:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:button];
		}
		
		self.activityArray = [[NSMutableArray alloc] init];
		m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, 367-30) style:UITableViewStylePlain];
		m_tableView.backgroundColor = [UIColor blackColor];
		m_tableView.delegate = self;
		m_tableView.dataSource = self;
		m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self addSubview:m_tableView];
	}
    return self;
}

-(void) getPresellList:(DateButton *)tapButton
{
	for(UIView *aView in self.subviews)
	{
		if([aView isKindOfClass:[DateButton class]])
		{
			if(tapButton.tag != aView.tag)
			{
				[(DateButton *)aView setBackgroundImage:[UIImage imageNamed:@"DateButtonNormal.png"] forState:UIControlStateNormal];
			}
			else
			{
				[(DateButton *)aView setBackgroundImage:[UIImage imageNamed:@"DateButtonClick.png"] forState:UIControlStateNormal];
			}
		}
	}
	
	
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@|%@",account.account,tapButton.dateStr];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	NSString *presellCalenderlistStr = [NSString stringWithFormat:@"%@=PresellCalenderlist&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"获取某天的售卖活动:%@",presellCalenderlistStr);
	
	NSURL *presellCalenderlistStrUrl = [[NSURL alloc] initWithString:presellCalenderlistStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:presellCalenderlistStrUrl];
	loadingView = [[LoadingView alloc] initWithFrame:self.frame];
	[self addSubview:loadingView];
	pcListConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[presellCalenderlistStrUrl release];	
	
	NSLog(@"%@",tapButton.dateStr);
}

#pragma mark -
#pragma mark 
-(void) showFirstDayProductList
{
	DateButton *dataButton = (DateButton *)[self viewWithTag:101];
	[self getPresellList:dataButton];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.activityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"indexCell";
	CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil)
	{
		cell = [[[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	//cell.m_imageView.image = nil;
	
	Willsale *willsale = [self.activityArray objectAtIndex:indexPath.row];
	
	[ImageCacheManager setImg:cell.m_imageView  withUrlString:willsale.img];
    cell.leftButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [cell.leftButton setTitle:@"加入提醒" forState:UIControlStateNormal];
    [cell.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cell.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[cell.leftButton setBackgroundImage:[UIImage imageNamed:@"AddAlertNormal.png"] forState:UIControlStateNormal];
	[cell.leftButton setBackgroundImage:[UIImage imageNamed:@"AddAlertClick.png"] forState:UIControlStateHighlighted];
	cell.leftButton.tag = indexPath.row;
	[cell.leftButton addTarget:self action:@selector(addAlert:) forControlEvents:UIControlEventTouchUpInside];
	
    
    cell.rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [cell.rightButton setTitle:@"告诉好友" forState:UIControlStateNormal];
    [cell.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cell.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[cell.rightButton setBackgroundImage:[UIImage imageNamed:@"AddAlertNormal.png"] forState:UIControlStateNormal];
	[cell.rightButton setBackgroundImage:[UIImage imageNamed:@"AddAlertClick.png"] forState:UIControlStateHighlighted];
	cell.rightButton.tag = indexPath.row;
	[cell.rightButton addTarget:self action:@selector(tellFriend:) forControlEvents:UIControlEventTouchUpInside];
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您好，活动即将开始，敬请关注！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark 加入提醒  告诉朋友
-(void) addAlert:(UIButton *)tap
{
	int row = tap.tag;
	Willsale *willsale = [self.activityArray objectAtIndex:row];
	
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@",account.account,willsale.ID,@"1"];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	[MobClick event:[NSString stringWithFormat:@"MyPrompt"] label:willsale.Name];
	
	NSString *myPromptSave = [NSString stringWithFormat:@"%@=MyPromptSave&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"我的提醒保存:%@",myPromptSave);
	NSURL *myPromptSaveUrl = [[NSURL alloc] initWithString:myPromptSave];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:myPromptSaveUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:self.frame];
	[self addSubview:loadingView];
	myPromptSaveConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[myPromptSaveUrl release];
}

-(void) tellFriend:(UIButton *)tap
{
	int row = tap.tag;
	Willsale *willsale = [self.activityArray objectAtIndex:row];
	[calenderDelegate doTellFriendCalender:willsale];
}


#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"我的提醒 获得服务器 回应");
	self.receivedData = [[NSMutableData alloc] init];
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
	if(myPromptSaveConnection == connection)
	{
		NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
		char flag = [str characterAtIndex:0];
		if(flag == '1')
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"您已经成功加入提醒" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"对不起"	message:@"加入提醒失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		[myPromptSaveConnection release];
	}
	
	if(pcListConnection == connection)
	{
		NSError *error = nil;
		GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
		if(error)
		{
			[document release];
			[pcListConnection release];
			return;
		}
		GDataXMLElement *root = [document rootElement];
		NSArray *calenderList = [root elementsForName:@"activity"];
		self.activityArray = [[NSMutableArray alloc] init];
		for(GDataXMLElement *element in calenderList)
		{
			Willsale *willsale = [[Willsale alloc] init];
			GDataXMLElement *ID = [[element elementsForName:@"id"] objectAtIndex:0];
			willsale.ID = [ID stringValue];	
			GDataXMLElement *name = [[element elementsForName:@"name"] objectAtIndex:0];
			willsale.Name = [name stringValue];
			GDataXMLElement *img = [[element elementsForName:@"img"] objectAtIndex:0];
			willsale.img = [img stringValue];		
			[self.activityArray addObject:willsale];
			[willsale release];
		}
		[m_tableView reloadData];
		
		[document release];
		[pcListConnection release];
	}
	
	self.receivedData = nil;
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[connection release];
	self.receivedData = nil;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}



- (void)dealloc 
{
    [super dealloc];
}


@end
