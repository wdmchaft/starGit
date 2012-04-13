//
//  WillSaleView0.m
//  ShangPin
//
//  Created by 唐彬琪 on 11-8-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WillSaleView.h"
#import "CustomTableViewCell.h"
#import "Willsale.h"

@implementation WillSaleView
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
        self.willSaleArray = [[[NSMutableArray alloc] init] autorelease];
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
        
        cell.addRemindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cell.addRemindButton.frame = CGRectMake(275, 30, 30, 30);
        cell.addRemindButton.showsTouchWhenHighlighted = YES;
        
        UIImageView * addButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SellAndRemind.png"]];
        addButtonView.frame = CGRectMake(5, 5, 19, 24);
        [cell.addRemindButton addSubview:addButtonView];
        [addButtonView release];
        [cell.contentView addSubview:cell.addRemindButton];

	}
	//cell.m_imageView.image = nil;
	
	Willsale *willsale = [self.willSaleArray objectAtIndex:indexPath.row];
    cell.act_imageView.image = [UIImage imageNamed:@"shang.png"];
	[ImageCacheManager setImg:cell.act_imageView  withUrlString:willsale.img];
    cell.brandName.text = willsale.title;
    cell.activityName.text = willsale.Name;
    cell.activityTime.text = willsale.date;

//    UIImageView * invButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tellFriends.png"]];
//    invButtonView.frame = CGRectMake(5, 5, 20, 20);
//    [cell.invButton addSubview:invButtonView];
//    [invButtonView release];
//	[cell.invButton addTarget:self action:@selector(tellFriend:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImageView * addButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SellAndRemind.png"]];
//    addButtonView.frame = CGRectMake(5, 5, 20, 19);
//    [cell.addRemindButton addSubview:addButtonView];
//    [addButtonView release];
    cell.addRemindButton.tag = indexPath.row;
	[cell.addRemindButton addTarget:self action:@selector(addAlert:) forControlEvents:UIControlEventTouchUpInside];

	
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您好,活动即将开始,敬请关注！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"我的提醒 获得服务器 回应");
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
	NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
	char flag = [str characterAtIndex:0];
	if(flag == '1')
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"恭喜您，已经成功加入提醒" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""	message:@"加入提醒失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}


#pragma mark -
#pragma mark 释放相关
- (void)dealloc
{
	self.receivedData = nil;
	//[willSaleArray release];
    [super dealloc];
}


@end
