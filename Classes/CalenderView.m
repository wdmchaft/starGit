//
//  CalenderView0.m
//  ShangPin
//
//  Created by 唐彬琪 on 11-8-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//



#import "CalenderView.h"
#import "DateButton.h"
#import "Calender.h"
#import "Willsale.h"
#import "CustomTableViewCell.h"
#import "GDataXMLNode.h"


@implementation CalenderView
@synthesize calenderDelegate;
@synthesize calenderArray;
@synthesize activityArray;
@synthesize receivedData;

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
			button.tag = 700+i;
			[button addTarget:self action:@selector(getPresellList:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:button];
        }
        //self.activityArray = [[NSMutableArray alloc] init];
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
//	NSString *parameters = [NSString stringWithFormat:@"%@|%@",account.account,tapButton.dateStr];
    NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@",account.account,tapButton.dateStr,account.gender];
    NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	NSString *presellCalenderlistStr = [NSString stringWithFormat:@"%@=PresellCalenderlist&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"获取某天的售卖活动:%@",presellCalenderlistStr);
	
	NSURL *presellCalenderlistStrUrl = [[NSURL alloc] initWithString:presellCalenderlistStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:presellCalenderlistStrUrl];
	loadingView = [[LoadingView alloc] initWithFrame:m_tableView.frame];
	[self addSubview:loadingView];
	pcListConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[presellCalenderlistStrUrl release];	
	
	NSLog(@"%@",tapButton.dateStr);
}

-(void) showFirstDayProductList
{
	DateButton *dataButton = (DateButton *)[self viewWithTag:701];
	[self getPresellList:dataButton];
}

//时间字符串处理
- (NSString *)changeStr:(NSString*)string
{
    //NSString * newStr = [NSString string];
    //NSLog(@"zong_str = %@",string);
    if (string != nil) 
    {
        NSArray * strArray = [string componentsSeparatedByString:@"|"];
        
        NSMutableString * str = [NSMutableString stringWithString:[strArray objectAtIndex:0]];//[strArray objectAtIndex:0];   
        if([str length]>5)
        {
            //NSLog(@"str = %@",str);
            [str deleteCharactersInRange:NSMakeRange(0, 5)];
            [str deleteCharactersInRange:NSMakeRange([str length]-3, 3)];
            str = (NSMutableString *)[str stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            str = (NSMutableString *)[str stringByReplacingOccurrencesOfString:@" " withString:@"日"];
        }
        NSMutableString * str1 = [NSMutableString stringWithString:[strArray objectAtIndex:1]]; 
        if ([str1 length]>5)
        {
            //NSLog(@"str1 = %@",str1);
            [str1 deleteCharactersInRange:NSMakeRange(0, 5)];
            [str1 deleteCharactersInRange:NSMakeRange([str length]-3, 3)];
            str1 = (NSMutableString *)[str1 stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            str1 = (NSMutableString *)[str1 stringByReplacingOccurrencesOfString:@" " withString:@"日"];
        }
        
        NSString * newStr = [NSString stringWithFormat:@"%@-%@",str,str1];
        return newStr;
    }
    return nil;
}




#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDataSource

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
        cell.addRemindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cell.addRemindButton.frame = CGRectMake(275, 30, 30, 30);
        cell.addRemindButton.showsTouchWhenHighlighted = YES;
        
        UIImageView * addButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SellAndRemind.png"]];
        addButtonView.frame = CGRectMake(5, 5, 19, 24);
        [cell.addRemindButton addSubview:addButtonView];
        [addButtonView release];
        [cell.contentView addSubview:cell.addRemindButton];

	}
	
	Willsale *willsale = [self.activityArray objectAtIndex:indexPath.row];
	cell.act_imageView.image = [UIImage imageNamed:@"shang.png"];
	[ImageCacheManager setImg:cell.act_imageView  withUrlString:willsale.img];
    
    cell.brandName.text = willsale.title;
    cell.activityName.text = willsale.Name;
    NSString * dateStr = [self changeStr:willsale.date];
    cell.activityTime.text = dateStr;

    
    
//    UIImageView * invButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tellFriends.png"]];
//    invButtonView.frame = CGRectMake(5, 5, 20, 20);
//    [cell.invButton addSubview:invButtonView];
//    [invButtonView release];
	[cell.invButton addTarget:self action:@selector(tellFriend:) forControlEvents:UIControlEventTouchUpInside];
    
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
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您好，活动即将开始，敬请关注！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
	loadingView = [[LoadingView alloc] initWithFrame:m_tableView.frame];
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
	if(myPromptSaveConnection == connection)
	{
		NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
		char flag = [str characterAtIndex:0];
		if(flag == '1')
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"已经成功加入提醒" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
		self.activityArray = [[[NSMutableArray alloc] init] autorelease];
		for(GDataXMLElement *element in calenderList)
		{
			Willsale *willsale = [[Willsale alloc] init];
			GDataXMLElement *ID = [[element elementsForName:@"id"] objectAtIndex:0];
			willsale.ID = [ID stringValue];	
			/*
             添加接口后,修改部分
            */ 
            GDataXMLElement *date = [[element elementsForName:@"date"]objectAtIndex:0];
            willsale.date = [date stringValue];
            GDataXMLElement *title = [[element elementsForName:@"title"]objectAtIndex:0];
            willsale.title = [title stringValue];
            GDataXMLElement *text = [[element elementsForName:@"text"]objectAtIndex:0];
            willsale.text = [text stringValue];

            
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
