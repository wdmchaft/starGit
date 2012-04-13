//
//  InvRecordViewController.m
//  ShangPin
//
//  Created by 唐彬琪 on 11-8-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "InvRecordViewController.h"
#import "GDataXMLNode.h"
#import "Record.h"


@implementation InvRecordViewController
@synthesize recordArray;
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

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView * mainView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    mainView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MoreBackGround.png"]];
    
    //self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"成功邀请好友";
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];                //返回按钮
    backButton.frame = CGRectMake(10, 7, 50, 30);
    [backButton setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    backButton.showsTouchWhenHighlighted = YES;
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftNavigationButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftNavigationButton;
    [leftNavigationButton release];

    
    
    //浅色背景图片
//    UIImage * imageq = [UIImage imageNamed:@"Inv_light_Lable.png"];
//    UIImage *imagemobil = [imageq stretchableImageWithLeftCapWidth:1.0f topCapHeight:0.0f];

//    UILabel *scucessRecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 118, 30)];
//    scucessRecordLabel.textColor = [UIColor colorWithRed:0.486f green:0.486f blue:0.486 alpha:1.0f];
//    scucessRecordLabel.font = [UIFont systemFontOfSize:14];
//    scucessRecordLabel.backgroundColor = [UIColor colorWithPatternImage:imagemobil];
//    scucessRecordLabel.textAlignment = UITextAlignmentCenter;
//    scucessRecordLabel.layer.masksToBounds = YES;
//    scucessRecordLabel.layer.cornerRadius = 2.0f;
//    scucessRecordLabel.layer.borderWidth = 0.4f;
//    scucessRecordLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
//    scucessRecordLabel.text = @"成功邀请的好友";
//    [self.view addSubview:scucessRecordLabel];
//    [scucessRecordLabel release];

    //recordArray = [[NSMutableArray alloc] init];
    recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStylePlain];
    recordTableView.delegate = self;
    recordTableView.dataSource = self;
    recordTableView.backgroundColor = [UIColor clearColor];
    recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mainView addSubview:recordTableView];
    self.view = mainView;
    [mainView release];
    [self loadRecordList];
    
}


- (void)loadRecordList{
	recordArray = [[NSMutableArray alloc] init];
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@",account.account,@"1",@"50"];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	[MobClick event:@"Inviterecords"];
	
	NSString *inviterecords = [NSString stringWithFormat:@"%@=Inviterecords&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"邀请记录:%@",inviterecords);
	NSURL *inviterecordsUrl = [[NSURL alloc] initWithString:inviterecords];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:inviterecordsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	[self.view addSubview:loadingView];
	recordConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[inviterecordsUrl release];

}


- (void)backButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;


}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.recordArray count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        UIImage * image0 = [UIImage imageNamed:@"Inv_cell_BackGround.png"];
        UIImage * image1 = [image0 stretchableImageWithLeftCapWidth:3.0f topCapHeight:0.0f];
        UIImageView * backView = [[UIImageView alloc] initWithImage:image1];
        backView.frame  = cell.frame;
        cell.backgroundView = backView;
        
        UIImageView * avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        avatarView.image = [UIImage imageNamed:@"NoneGender.png"];
        avatarView.tag = 200;
        [cell.contentView addSubview:avatarView];
        
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, 15)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = @"";
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:14.0f];
        nameLabel.tag = 201;
        [cell.contentView addSubview:nameLabel];
        
        UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 200, 15)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.text = @"";
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.font = [UIFont systemFontOfSize:14.0f];
        timeLabel.tag = 202;
        [cell.contentView addSubview:timeLabel];
       
        
        [backView release];
        [avatarView release];
        [nameLabel release];
        [timeLabel release];
        
    }
    Record * newRecord = [self.recordArray objectAtIndex:indexPath.row];
    UILabel * nameLabel =(UILabel *)[cell.contentView viewWithTag:201];
    nameLabel.text = newRecord.contactway;
    
    UILabel * timeLabel =(UILabel *)[cell.contentView viewWithTag:202];
    timeLabel.text = newRecord.time;
    
    
    
    cell.userInteractionEnabled = NO;
    return cell;
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
		[recordConnection release];
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
	
	[recordTableView reloadData];
	[document release];
	[recordConnection release];
	self.receivedData = nil;
	//[inviteRecordDelegate didInviteRecordFinishLaunching];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	//[inviteRecordDelegate didInviteRecordFinishLaunching];
	[recordConnection release];
	self.receivedData = nil;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
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
