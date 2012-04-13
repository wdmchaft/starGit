//
//  MessageBoardView.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageBoardView.h"
#import "GDataXMLNode.h"
#import "Message.h"
#import "CustomLabel.h"

@implementation MessageBoardView
@synthesize messageBoardDelegate;
@synthesize mesaageArray;
@synthesize receivedData;
@synthesize myMessageTF;

#pragma mark -
#pragma mark 键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark 留言板视图 初始化

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        self.backgroundColor = [UIColor blackColor];
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 303, 47)];
		imageView.image = [UIImage imageNamed:@"MessageBoard.png"];
		[self addSubview:imageView];
		[imageView release];
		
		myMessageTF = [[UITextField alloc] initWithFrame:CGRectMake(12, 11, 299, 45)];
		myMessageTF.backgroundColor = [UIColor clearColor];
		myMessageTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		myMessageTF.font = [UIFont systemFontOfSize:16];
		myMessageTF.delegate = self;
		myMessageTF.clearButtonMode = UITextFieldViewModeWhileEditing;
		[self addSubview:myMessageTF];
		
		UILabel *limitLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 64, 130, 16)];
		limitLabel.backgroundColor = [UIColor clearColor];
		limitLabel.textColor = [UIColor redColor];
		limitLabel.font = [UIFont systemFontOfSize:14];
		limitLabel.text = @"请输入6-600字,谢谢";
		[self addSubview:limitLabel];
		[limitLabel release];
		
		UIButton *sentMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
		sentMessageButton.frame = CGRectMake(10, 64, 69, 22);
        sentMessageButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [sentMessageButton setTitle:@"发表留言" forState:UIControlStateNormal];
        [sentMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [sentMessageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[sentMessageButton setBackgroundImage:[UIImage imageNamed:@"SendMessageNormal.png"] forState:UIControlStateNormal];
		[sentMessageButton setBackgroundImage:[UIImage imageNamed:@"SendMessageClick.png"] forState:UIControlStateHighlighted];
		[sentMessageButton addTarget:self action:@selector(doSendMessage) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:sentMessageButton];
		
		UILabel *myMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 96, 69, 16)];
		myMessageLabel.textColor = WORDCOLOR;
		myMessageLabel.backgroundColor = [UIColor clearColor];
		myMessageLabel.font = [UIFont systemFontOfSize:16];
		myMessageLabel.text = @"我的留言";
		[self addSubview:myMessageLabel];
		[myMessageLabel release];
		
		//self.mesaageArray = [[NSMutableArray alloc] init];
		m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 115, 320, 367 - 115 - 121) style:UITableViewStyleGrouped];
		m_tableView.backgroundColor = [UIColor blackColor];
		m_tableView.dataSource = self;
		m_tableView.delegate = self;
		[self addSubview:m_tableView];
		
    }
    return self;
}

#pragma mark -
#pragma mark 发表留言    加载留言列表
-(void) doSendMessage
{
	if([myMessageTF isFirstResponder])
	{
		[myMessageTF resignFirstResponder];
	}
	
	if( ([myMessageTF.text length] < 6) || ([myMessageTF.text length] >= 600) )
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请确保留言内容在字数限制之内!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		OnlyAccount *account = [OnlyAccount defaultAccount];
		NSString *parameters = [NSString stringWithFormat:@"%@|%@",account.account,myMessageTF.text];
		NSString *encodedString = [URLEncode encodeUrlStr:parameters];
		NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
		
		[MobClick event:@"Guestbook"];
		
		NSString *guestbook = [NSString stringWithFormat:@"%@=Guestbook&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
		NSLog(@"留言:%@",guestbook);
		NSURL *guestbookUrl = [[NSURL alloc] initWithString:guestbook];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:guestbookUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 246)];
		[self addSubview:loadingView];
		sendMessageConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[request release];
		[guestbookUrl release];
	}
}


-(void) loadMessage
{
	NSMutableArray * nArray = [[NSMutableArray alloc] init];
    self.mesaageArray = nArray;
    [nArray release];
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@",account.account,@"1",@"20"];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	[MobClick event:@"Mymessage"];
	
	NSString *mymessage = [NSString stringWithFormat:@"%@=Mymessage&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"我的留言:%@",mymessage);
	NSURL *mymessageUrl = [[NSURL alloc] initWithString:mymessage];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:mymessageUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 246)];
	[self addSubview:loadingView];
	messageBoardConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[mymessageUrl release];
}


#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDatasource

-(float)contentHeight: (NSString *)string
{
	CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(260, 500) lineBreakMode:UILineBreakModeCharacterWrap];
	float height = size.height;
	return height;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [self.mesaageArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	if (!cell) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
		cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"303x1.png"]];

		// 我
		UILabel *me = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 20, 14)];
		me.backgroundColor = [UIColor clearColor];
		me.text = @"我:";
		me.font = [UIFont boldSystemFontOfSize:14];
		me.textColor = [UIColor colorWithRed:0.878f green:0.576f blue:0.60f alpha:1.0f];
		
		// 我的留言
		CustomLabel *myMessage = [[CustomLabel alloc] initWithFrame:CGRectMake(30, 10, 260, 14)];
		myMessage.backgroundColor = [UIColor clearColor];
		myMessage.verticalAlignment = VerticalAlignmentTop;
		myMessage.tag = 100;
		myMessage.numberOfLines = 0;
		myMessage.textColor = WORDCOLOR;
		myMessage.font = [UIFont systemFontOfSize:14.0f];
		
		// 尚品
		UILabel *sp = [[UILabel alloc] initWithFrame:CGRectMake(20, 28, 20, 14)];
		sp.backgroundColor = [UIColor clearColor];
		sp.tag = 101;
		sp.text = @"尚:";
		sp.textColor = [UIColor colorWithRed:0.878f green:0.576f blue:0.60f alpha:1.0f];
		sp.font = [UIFont boldSystemFontOfSize:14.0f];
		
		CustomLabel *spMessage = [[CustomLabel alloc] initWithFrame:CGRectMake(40, 26, 250, 14)];
		spMessage.backgroundColor = [UIColor clearColor];
		spMessage.verticalAlignment = VerticalAlignmentTop;
		spMessage.tag = 102;
		spMessage.numberOfLines = 0;
		spMessage.textColor = WORDCOLOR;
		spMessage.font = [UIFont systemFontOfSize:14.0f];
		
		[cell.contentView addSubview:me];
		[cell.contentView addSubview:myMessage];
		[cell.contentView addSubview:sp];
		[cell.contentView addSubview:spMessage];
		
		[me release];
		[myMessage release];
		[sp release];
		[spMessage release];
		
	}
	Message *message = [self.mesaageArray objectAtIndex:indexPath.row];
	
	CustomLabel *myMessage = (CustomLabel *)[cell.contentView viewWithTag:100];
	NSString *my = [NSString stringWithFormat:@"  %@   %@",message.message,message.Date];
	float height = [self contentHeight:my];
	myMessage.frame = CGRectMake(30, 10, 260, height);
	myMessage.text = my;
	
	UILabel *sp = (UILabel *)[cell.contentView viewWithTag:101];
	sp.frame = CGRectMake(20, 14 + height, 20, 14);
	
	CustomLabel *spMessage = (CustomLabel *)[cell.contentView viewWithTag:102];
	NSString *spM = [NSString stringWithFormat:@"  %@   %@",message.reply,message.Date];
	float heightSP = [self contentHeight:spM];
	spMessage.frame = CGRectMake(40, 12 + height, 250, heightSP);
	spMessage.text = spM;
	
	if([message.reply length] == 0)
	{
		sp.hidden = TRUE;
		spMessage.hidden = TRUE;
	}
	else
	{
		sp.hidden = FALSE;
		spMessage.hidden = FALSE;
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Message *message = [self.mesaageArray objectAtIndex:indexPath.row];
	NSString *my = [NSString stringWithFormat:@"  %@   %@",message.message,message.Date];
	float height = [self contentHeight:my];
	
	if([message.reply length] == 0)
	{
		return 24 + height;
	}
	else
	{
		NSString *spM = [NSString stringWithFormat:@"  %@   %@",message.reply,message.Date];
		float heightSP = [self contentHeight:spM];
		
		return (24 + height +heightSP);
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
	if(messageBoardConnection == connection)	//留言板
	{
		NSError *error = nil;
		GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
		if(error)
		{
			[document release];
			[messageBoardConnection release];
			return;
		}
		GDataXMLElement *root = [document rootElement];
		NSArray *array = [root elementsForName:@"mymessage"];	//各个留言
		for(GDataXMLElement *mymessage in array)
		{
			Message *theMessage = [[Message alloc] init];
			GDataXMLElement *date = [[mymessage elementsForName:@"date"] objectAtIndex:0];
			theMessage.Date = [date stringValue];	//留言时间
			GDataXMLElement *message = [[mymessage elementsForName:@"message"] objectAtIndex:0];
			theMessage.message = [message stringValue];	//我的留言内容
			GDataXMLElement *reply = [[mymessage elementsForName:@"reply"] objectAtIndex:0];
			theMessage.reply = [reply stringValue];		//尚品的回复
			[self.mesaageArray addObject:theMessage];
			[theMessage release];
		}
		[m_tableView reloadData];
		[messageBoardConnection release];
		[document release];
		[messageBoardDelegate didMessageBoardViewFinishLaunching];
	}
	
	if(sendMessageConnection == connection)	//发表留言
	{
		NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
		char flag = [str characterAtIndex:0];
		if(flag == '1')
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"留言发表成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""	message:@"留言发表失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		[sendMessageConnection release];
	}
	
	self.receivedData = nil;
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[messageBoardDelegate didMessageBoardViewFinishLaunching];
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
		myMessageTF.text = @"";
		[self loadMessage];
	}
}


#pragma mark -
#pragma mark 留言板释放相关

- (void)dealloc 
{
	[myMessageTF release];
	[mesaageArray release];
	[m_tableView release];
	self.receivedData = nil;
    [super dealloc];
}


@end
