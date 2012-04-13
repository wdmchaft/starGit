//
//  WillSaleView.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WillSaleView0.h"
#import "CustomTableViewCell.h"
#import "Willsale.h"

@implementation WillSaleView0
@synthesize willSaleArray;
@synthesize willsaleDelegate;
@synthesize receivedData;

#pragma mark -
#pragma mark 初始化 即将出售

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{    
    self = [super initWithFrame:frame style:style];
    if (self) 
	{
        self.willSaleArray = [[NSMutableArray alloc] init];
		self.backgroundColor = [UIColor blackColor];
		self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark -
#pragma mark 加入提醒  告诉朋友
-(void) addAlert:(UIButton *)tap
{
	int row = tap.tag;
	Willsale *willsale = [self.willSaleArray objectAtIndex:row];
	
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
	[self.superview addSubview:loadingView];
	myPromptSaveConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[myPromptSaveUrl release];
}

-(void) tellFriend:(UIButton *)tap
{
	int row = tap.tag;
	Willsale *willsale = [self.willSaleArray objectAtIndex:row];
	[willsaleDelegate doTellFriendWillSale:willsale];
	
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.willSaleArray count];
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
	
	Willsale *willsale = [self.willSaleArray objectAtIndex:indexPath.row];
	
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
	self.receivedData = nil;
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[myPromptSaveConnection release];
	self.receivedData = nil;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}


#pragma mark -
#pragma mark 释放相关
- (void)dealloc
{
	self.receivedData = nil;
	[willSaleArray release];
    [super dealloc];
}


@end
