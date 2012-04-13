//
//  SuggestVC.m
//  ShangPin
//
//  Created by 唐彬琪 on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SuggestVC.h"
#import "GDataXMLNode.h"
#import "Message.h"
#import "OneMessage.h"
#import "CustomLabel.h"


@implementation SuggestVC
@synthesize mesaageArray;
@synthesize receivedData;


- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(void) keyBoardReturn
{
	if([bottomTextView isFirstResponder])
	{
		[bottomTextView resignFirstResponder];
	}
}




// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    NSLog(@"%s",__FUNCTION__);
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MoreBackGround.png"]];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    titleLabel.center = CGPointMake(160, titleLabel.center.y);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"建议反馈";
    titleLabel.textColor = [UIColor colorWithRed:0.894f green:0.753f blue:0.373f alpha:1.0f];
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
   
//    UIButton * submitButton = [UIButton buttonWithType:UIButtonTypeCustom];               //提交按钮
//    submitButton.frame = CGRectMake(255, 7, 50, 30);
//    [submitButton setBackgroundImage:[UIImage imageNamed:@"Submit.png"] forState:UIControlStateNormal];
//    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
//    [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    submitButton.showsTouchWhenHighlighted = YES;
//    submitButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
//    [submitButton addTarget:self action:@selector(submitMessage) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * rightNavigationButton = [[UIBarButtonItem alloc]initWithCustomView:submitButton];
//    self.navigationItem.rightBarButtonItem = rightNavigationButton;
//    [rightNavigationButton release];
  
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(submitMessage)];
    self.navigationItem.rightBarButtonItem = submitButton;
    [submitButton release];

    
    //self.navigationItem.hidesBackButton = YES; 
//    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];                //返回按钮
//    backButton.frame = CGRectMake(10, 7, 50, 30);
//    [backButton setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
//    backButton.showsTouchWhenHighlighted = YES;
//    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * leftNavigationButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = leftNavigationButton;
//    [leftNavigationButton release];

    UIBarButtonItem *backBI = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    self.navigationItem.leftBarButtonItem = backBI;
    [backBI release];

    
    
    UILabel * suggestLabel1 = [[UILabel alloc] init];
    suggestLabel1.backgroundColor = [UIColor clearColor];
    suggestLabel1.text = @"感谢您对尚品提出宝贵意见\n我们将竭诚为您服务";
    suggestLabel1.textColor = [UIColor whiteColor];
    suggestLabel1.textAlignment = UITextAlignmentCenter;
    suggestLabel1.numberOfLines = 2;
    suggestLabel1.font = [UIFont systemFontOfSize:15.0f];
    suggestLabel1.frame = CGRectMake(40, 0, 240, 55);
    [self.view addSubview:suggestLabel1];
    [suggestLabel1 release];

    UIImageView * bottomView0 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 55, 300, 140)];
    bottomView0.image = [UIImage imageNamed:@"Layer_Down_zhijiao.png"];
    bottomView0.layer.masksToBounds = YES;
    bottomView0.layer.cornerRadius = 3.0f;
    bottomView0.layer.borderWidth = 0.5f;
    bottomView0.layer.borderColor = [[UIColor whiteColor]CGColor];
    [self.view addSubview:bottomView0];
    [bottomView0 release];
    
    UIImageView * bottomView1 = [[UIImageView alloc] initWithFrame:CGRectMake(25, 65, 270, 105)];
    bottomView1.image = [[UIImage imageNamed:@"TextField.png"]stretchableImageWithLeftCapWidth:0.0f topCapHeight:14.0f];
    bottomView1.layer.masksToBounds = YES;
    bottomView1.layer.cornerRadius = 3.0f;
    bottomView1.layer.borderWidth = 0.5f;
    bottomView1.layer.borderColor = [[UIColor whiteColor]CGColor];
    [self.view addSubview:bottomView1];
    [bottomView1 release];
    
    bottomTextView = [[UITextView alloc] initWithFrame:CGRectMake(25, 65, 270, 105)];
    bottomTextView.backgroundColor = [UIColor clearColor];
    bottomTextView.text = @"";
    bottomTextView.editable = TRUE;
    bottomTextView.font = [UIFont fontWithName:@"Arial" size:13.0f];
    bottomTextView.textColor = [UIColor blackColor];
    bottomTextView.returnKeyType = UIReturnKeyDone;
    bottomTextView.keyboardType = UIKeyboardTypeEmailAddress;
    bottomTextView.keyboardAppearance = UIKeyboardAppearanceAlert;
    bottomTextView.scrollEnabled = YES;
    bottomTextView.delegate = self;
    [self.view addSubview:bottomTextView];
    [bottomTextView release];
    
    UILabel * promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 175, 270, 20)];
    promptLabel.backgroundColor = [UIColor clearColor];
    promptLabel.text = @"您的建议请在100字以内";
    promptLabel.textColor = WORDCOLOR;//[UIColor redColor];
    promptLabel.font = [UIFont fontWithName:@"Arial" size:13.0f];
    [self.view addSubview:promptLabel];
    [promptLabel release];
        
    
    mesaageArray = [[NSMutableArray alloc] init];
    suggestTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 205, 290, 150) style:UITableViewStylePlain];
    suggestTableView.backgroundColor = [UIColor clearColor];                           
    suggestTableView.separatorStyle = UITableViewCellSeparatorStyleNone;            //去掉cell的分割线;
    suggestTableView.delegate = self;
    suggestTableView.dataSource = self;
    

    
    [self loadMessage];


}

- (void)addView
{
    if ([self.mesaageArray count]>0) {
        UIImageView * bottomTableView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 200, 300, 160)];
        bottomTableView.image = [UIImage imageNamed:@"Layer_Down_zhijiao.png"];
        bottomTableView.layer.masksToBounds = YES;
        bottomTableView.layer.cornerRadius = 3.0f;
        [self.view addSubview:bottomTableView];
        [bottomTableView release];
        //在添加背景图之后，添加tableview，防止被覆盖
        [self.view addSubview:suggestTableView];

    }

}



#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

-(float)contentHeight: (NSString *)string
{
	CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(260, 500) lineBreakMode:UILineBreakModeCharacterWrap];
	float height = size.height;
	return height;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"%s",__FUNCTION__);
   	Message *message = [self.mesaageArray objectAtIndex:indexPath.row];
	NSString *my = [NSString stringWithFormat:@"  %@ ",message.message];
	float height = [self contentHeight:my];
    return  40 + height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return  [self.mesaageArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s",__FUNCTION__);
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
//        UIImage * cellImage = [[UIImage imageNamed:@"cell_backGround_1.png"] stretchableImageWithLeftCapWidth:2.0f topCapHeight:0.0f];
//        UIImageView * cellIView = [[UIImageView alloc] initWithImage:cellImage];
//        cellIView.frame = cell.frame;
//        cell.backgroundView = cellIView;
//        [cellIView release];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //署名
        UILabel *signature = [[UILabel alloc] initWithFrame:CGRectMake(10, 28, 260, 14)];
		signature.backgroundColor = [UIColor clearColor];
        signature.tag = 101;
        NSLog(@"%d",indexPath.row);
        signature.text = @"";
		signature.font = [UIFont systemFontOfSize:14.0f];
        signature.textAlignment = UITextAlignmentRight;
		signature.textColor = [UIColor colorWithRed:0.78 green:0.588 blue:0.29 alpha:1.0f];
		
		// 我的建议
		CustomLabel *myMessage = [[CustomLabel alloc] initWithFrame:CGRectMake(10, 10, 260, 14)];
		myMessage.backgroundColor = [UIColor clearColor];
		myMessage.verticalAlignment = VerticalAlignmentTop;
        myMessage.textAlignment = UITextAlignmentLeft;
		myMessage.tag = 100;
		myMessage.numberOfLines = 0;
		myMessage.textColor = WORDCOLOR;
		myMessage.font = [UIFont systemFontOfSize:14.0f];
		
        
        //下边框视图
        UIImage * cellImage_line = [[UIImage imageNamed:@"cell_line.png"] stretchableImageWithLeftCapWidth:5.0f topCapHeight:0.0f];
        UIImageView * cellIView_line = [[UIImageView alloc] initWithImage:cellImage_line];
        cellIView_line.tag = 102;
        NSLog(@"%f",cell.frame.size.height);
        cellIView_line.frame = CGRectMake(5, cell.backgroundView.frame.size.height-1.0f, 280.0f, 2.0f);

        [cell.contentView addSubview:cellIView_line];
		[cell.contentView addSubview:signature];
		[cell.contentView addSubview:myMessage];
		
        [cellIView_line release];
		[signature release];
		[myMessage release];
        
        
    }
    
    OneMessage *message = [self.mesaageArray objectAtIndex:indexPath.row];
	
	//根据建议内容调整cell子视图的frame
    CustomLabel *myMessage = (CustomLabel *)[cell.contentView viewWithTag:100];
	NSString *my = [NSString stringWithFormat:@"  %@ ",message.message];
	float height = [self contentHeight:my];
	myMessage.frame = CGRectMake(10, 10, 260, height);
	myMessage.text = my;
	
	UILabel *signature = (UILabel *)[cell.contentView viewWithTag:101];
	signature.frame = CGRectMake(10, 18 + height, 260, 14);
    if (message.isme) {
        NSString * sigText =[NSString stringWithFormat:@"我的建议: %@",message.Date];
        signature.text = sigText;
    }else{
        NSString * sigText =[NSString stringWithFormat:@"尚品回复: %@",message.Date];
        signature.text = sigText;
    }
    
    UIImageView * cellView_line = (UIImageView *)[cell.contentView viewWithTag:102];    //根据cell的实际大小调整下边线视图的位置
    cellView_line.frame = CGRectMake(10, height+38.0f, 270.0f, 2.0f);

    return cell;
}



#pragma mark -
#pragma mark UIURLConnection delegate

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
		NSArray *array = [root elementsForName:@"mymessage"];	//各个建议
		for(GDataXMLElement *mymessage in array)
		{
			OneMessage *theMessage = [[OneMessage alloc] init];
			GDataXMLElement *date = [[mymessage elementsForName:@"date"] objectAtIndex:0];
			theMessage.Date = [date stringValue];	//建议时间
			GDataXMLElement *message = [[mymessage elementsForName:@"message"] objectAtIndex:0];
			theMessage.message = [message stringValue];	//我的建议内容
            theMessage.isme = YES;
			[self.mesaageArray addObject:theMessage];
            [theMessage release];
            GDataXMLElement *reply = [[mymessage elementsForName:@"reply"] objectAtIndex:0];
            if ([[reply stringValue] length]!=0) {
                OneMessage * theMessage1 = [[OneMessage alloc] init];
                theMessage1.Date = [date stringValue];
                theMessage1.message = [reply stringValue];		//尚品的回复
                theMessage1.isme = NO;
                [self.mesaageArray addObject:theMessage1];
                [theMessage1 release];
            }
		}
		NSLog(@"messaggeArray = %d",[self.mesaageArray count]);
        [suggestTableView reloadData];
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
	[self addView];
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






/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/


-(void)submitMessage{
 	if([bottomTextView isFirstResponder])
	{
		[bottomTextView resignFirstResponder];
	}
	
	if( ([bottomTextView.text length] < 1) || ([bottomTextView.text length] >= 100) )
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请确保留言内容在字数限制之内!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		OnlyAccount *account = [OnlyAccount defaultAccount];
		NSString *parameters = [NSString stringWithFormat:@"%@|%@",account.account,bottomTextView.text];
		NSString *encodedString = [URLEncode encodeUrlStr:parameters];
		NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
		
		[MobClick event:@"Guestbook"];
		
		NSString *guestbook = [NSString stringWithFormat:@"%@=Guestbook&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
		NSLog(@"留言:%@",guestbook);
		NSURL *guestbookUrl = [[NSURL alloc] initWithString:guestbook];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:guestbookUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
		loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 246)];
		[self.view addSubview:loadingView];
		sendMessageConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[request release];
		[guestbookUrl release];
	}

}

-(void) loadMessage
{
    NSMutableArray * meArray = [[NSMutableArray alloc]init];
    self.mesaageArray = meArray;
    [meArray release];
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
	[self.view addSubview:loadingView];
	messageBoardConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[mymessageUrl release];
}



#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
	{
		bottomTextView.text = @"";
		[self loadMessage];
	}
}



-(void)backButton{
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark -
#pragma mark UITextViewDelegate
//输入字符不能超过100个
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (1 == range.length) {//按下回格键
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]) {//按下return键
        //这里隐藏键盘，不做任何处理
        [textView resignFirstResponder];
        return NO;
        //return YES;
    }else {
        if ([textView.text length] < 100) {//判断字符个数
            return YES;
        }  
    }
    return NO;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end


