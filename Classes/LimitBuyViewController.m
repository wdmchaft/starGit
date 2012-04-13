    //
//  LimitBuyViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LimitBuyViewController.h"
#import "OnsaleListViewController.h"
#import "GDataXMLNode.h"
#import "OnSale.h"
#import "Willsale.h"
#import "Calender.h"
#import "TellFriendViewController.h"

@implementation LimitBuyViewController
@synthesize receivedData;
@synthesize calenderArray;


//时间字段处理
- (NSString *)changeStr:(NSString*)string
{
    //NSString * newStr = [NSString string];
    //NSLog(@"zong_str = %@",string);
    if (string != nil) 
    {
        //NSLog(@"timestr = %@",string);
        NSArray * strArray = [string componentsSeparatedByString:@"|"];
        
        NSMutableString * str = [NSMutableString stringWithString:[strArray objectAtIndex:0]];//[strArray objectAtIndex:0];   
        if([str length]>5)
        {
            //NSLog(@"str = %@",str);
            [str deleteCharactersInRange:NSMakeRange(0, 5)];
            [str deleteCharactersInRange:NSMakeRange([str length]-3, 3)];
            //NSLog(@"timestr_1 = %@",str);
            str = (NSMutableString *)[str stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            str = (NSMutableString *)[str stringByReplacingOccurrencesOfString:@" " withString:@"日"];
            //NSLog(@"timestr_2 = %@",str);
        }
        NSMutableString * str1 = [NSMutableString stringWithString:[strArray objectAtIndex:1]]; 
        if ([str1 length]>5)
        {
            //NSLog(@"str1 = %@",str1);
            [str1 deleteCharactersInRange:NSMakeRange(0, 5)];
            [str1 deleteCharactersInRange:NSMakeRange([str1 length]-3, 3)];
            //NSLog(@"timestr_1 = %@",str1);
            str1 = (NSMutableString *)[str1 stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            str1 = (NSMutableString *)[str1 stringByReplacingOccurrencesOfString:@" " withString:@"日"];
            //NSLog(@"timestr_2 = %@",str1);
        }
        
        NSString * newStr = [NSString stringWithFormat:@"%@-%@",str,str1];
        return newStr;
    }
    return nil;
}




#pragma mark -
#pragma mark 初始化


- (void)loadView 
{

    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoTittle.png"]];
    logoImageView.center = CGPointMake(160, [logoImageView center].y);
    self.navigationItem.titleView =  logoImageView;
    [logoImageView release];
  

      //self.navigationItem.hidesBackButton = YES; 
//    UIButton * ladyButton = [UIButton buttonWithType:UIButtonTypeCustom];                //女士按钮
//    ladyButton.tag = 300;
//    ladyButton.frame = CGRectMake(10, 7, 50, 30);
//    [ladyButton setBackgroundImage:[UIImage imageNamed:@"gender.png"] forState:UIControlStateNormal];
//    [ladyButton setTitle:@"女士" forState:UIControlStateNormal];
//    [ladyButton setTitleColor:[UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.0f] forState:UIControlStateNormal];
//    ladyButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//    ladyButton.showsTouchWhenHighlighted = YES;
//    [ladyButton addTarget:self action:@selector(changeGender:) forControlEvents:UIControlEventTouchUpInside];

//    UIBarButtonItem *backBI = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(returnBack)];
//    self.navigationItem.leftBarButtonItem = backBI;
//    [backBI release];
//
//    [backBI setImage:[UIImage imageNamed:@"BackAll.png"]];
    
//    UIButton * gentryButton = [UIButton buttonWithType:UIButtonTypeCustom];               //男士按钮
//    gentryButton.tag = 301;
//    gentryButton.frame = CGRectMake(255, 7, 50, 30);
//    [gentryButton setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal];
//    [gentryButton setTitle:@"男士" forState:UIControlStateNormal];
//    [gentryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    gentryButton.showsTouchWhenHighlighted = YES;
//    gentryButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//    //gentryButton.titleLabel.textColor  = [UIColor whiteColor];
//    [gentryButton addTarget:self action:@selector(changeGender:) forControlEvents:UIControlEventTouchUpInside];
    
  //  [self readGender];
    
//    OnlyAccount * account = [OnlyAccount defaultAccount];
//    gender = account.gender;
//    if ([gender isEqualToString:@"1"]) {
//        [ladyButton setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal];
//        [ladyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        
//         [gentryButton setBackgroundImage:[UIImage imageNamed:@"gender.png"] forState:UIControlStateNormal];
//        [gentryButton setTitleColor:[UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.0f] forState:UIControlStateNormal];
//        
//    }else
//    {
//        [ladyButton setBackgroundImage:[UIImage imageNamed:@"gender.png"] forState:UIControlStateNormal];
//        [ladyButton setTitleColor:[UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.0f] forState:UIControlStateNormal];
//        
//        [gentryButton setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal];
//        [gentryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        
//    }
//
//    UIBarButtonItem * leftNavigationButton = [[UIBarButtonItem alloc] initWithCustomView:ladyButton];
//    self.navigationItem.leftBarButtonItem = leftNavigationButton;
//    [leftNavigationButton release];
//
//    UIBarButtonItem * rightNavigationButton = [[UIBarButtonItem alloc]initWithCustomView:gentryButton];
//    self.navigationItem.rightBarButtonItem = rightNavigationButton;
//    [rightNavigationButton release];

    
    NSArray *segArray = [[NSArray alloc] initWithObjects:@"正在出售",@"即将出售",@"预售日历",nil];
	//分段控制（正在出售 即将出售 预售日历）
	segControl = [[UISegmentedControl alloc] initWithItems:segArray];
	segControl.frame = CGRectMake(5, 6, 300, 30);
	segControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[segControl addTarget:self action:@selector(doChangeMode:) forControlEvents:UIControlEventValueChanged];
	segControl.tintColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
    segControl.tag = 2001;
    //self.navigationItem.titleView = segControl;
    
    
    //添加 分段控制器的 toolbar
    UIToolbar  * toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -2, 320, 42)];
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.tag = 201;
    [toolBar addSubview:segControl];
    
    UIView *limitBuyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	limitBuyView.backgroundColor = [UIColor blackColor];
    [limitBuyView addSubview:toolBar];
    [toolBar release];
    [segControl release];
	[segArray release];

    self.view = limitBuyView;
	[limitBuyView release];
	
	segControl.selectedSegmentIndex = 0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        [self doChangeMode:segControl];
    }
    
}

//改变性别调用方法
- (void)changeGender:(UIButton *)sender
{
    UIButton  * genderBtn = (UIButton *)sender;
    NSNumber * genderNum = [[NSNumber alloc] initWithUnsignedInteger:(genderBtn.tag-300)];
    gender = [genderNum stringValue];
    [genderNum release];
    UIButton * ladyBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView; 
    UIButton * genBtn = (UIButton *)self.navigationItem.rightBarButtonItem.customView; 
    OnlyAccount * account = [OnlyAccount defaultAccount];

    if ([gender isEqualToString:@"1"]) {
       
        account.gender = @"1";
        [ladyBtn setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal];
        [ladyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [genBtn setBackgroundImage:[UIImage imageNamed:@"gender.png"] forState:UIControlStateNormal];
        [genBtn setTitleColor:[UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.0f] forState:UIControlStateNormal];
        
    }else
    {
        account.gender = @"0";
        [ladyBtn setBackgroundImage:[UIImage imageNamed:@"gender.png"] forState:UIControlStateNormal];
        [ladyBtn setTitleColor:[UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.0f] forState:UIControlStateNormal];
        
        [genBtn setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal];
        [genBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    [self doChangeMode:segControl];
}
//{
//    UIButton * ladyBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView; 
//    UIButton * genBtn = (UIButton *)self.navigationItem.rightBarButtonItem.customView; 
//    OnlyAccount * account = [OnlyAccount defaultAccount];
//    gender = account.gender;
//    if ([gender isEqualToString:@"1"]) {
//        [ladyBtn setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal];
//        [ladyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        
//        [genBtn setBackgroundImage:[UIImage imageNamed:@"gender.png"] forState:UIControlStateNormal];
//        [genBtn setTitleColor:[UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.0f] forState:UIControlStateNormal];
//
//    }else
//    {
//        [ladyBtn setBackgroundImage:[UIImage imageNamed:@"gender.pngg"] forState:UIControlStateNormal];
//        [ladyBtn setTitleColor:[UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.0f] forState:UIControlStateNormal];
//        
//        [genBtn setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal];
//        [genBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//    }
//
//    
//}


- (void)viewDidLoad 
{
    [super viewDidLoad];
	//[self showOnsaleView];
}


#pragma mark -
#pragma mark 进入售卖   告诉朋友  
-(void) doEnterSold:(OnSale *)onsale
{
	if(onsaleListVC == nil)
	{
		onsaleListVC = [[OnsaleListViewController alloc] init];
	}
	[self.navigationController pushViewController:onsaleListVC animated:YES];
	[onsaleListVC onsaleList:onsale.ID name:onsale.Name];
}


-(void) doTellFriendOnsale:(OnSale *)onsale
{
	//TellFriendViewController *tellVC = [TellFriendViewController getTellFriendInstanse];
	TellFriendViewController *tellVC = [[TellFriendViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tellVC];
	nav.navigationBar.barStyle = UIBarStyleBlack;
	[self presentModalViewController:nav animated:YES];
	[tellVC showImageViewWithUrl:onsale.img andId:onsale.ID andTheme:onsale.Name];
	[tellVC release];
	[nav release];
}

-(void) doTellFriendWillSale:(Willsale *)willsale
{
	//TellFriendViewController *tellVC = [TellFriendViewController getTellFriendInstanse];
	TellFriendViewController *tellVC = [[TellFriendViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tellVC];
	nav.navigationBar.barStyle = UIBarStyleBlack;
	[self presentModalViewController:nav animated:YES];
	[tellVC showImageViewWithUrl:willsale.img andId:willsale.ID andTheme:willsale.Name];
	[tellVC release];
	[nav release];
}

-(void) doTellFriendCalender:(Willsale *)willsale
{
	//TellFriendViewController *tellVC = [TellFriendViewController getTellFriendInstanse];
	TellFriendViewController *tellVC = [[TellFriendViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tellVC];
	nav.navigationBar.barStyle = UIBarStyleBlack;
	[self presentModalViewController:nav animated:YES];
	[tellVC showImageViewWithUrl:willsale.img andId:willsale.ID andTheme:willsale.Name];
	[tellVC release];
	[nav release];
}



#pragma mark -
#pragma mark 切换 正在出售  即将出售  预售日历

-(void) showOnsaleView
{
	//活动列表
	if(onsaleView == nil)
	{
		onsaleView = [[OnsaleView alloc] initWithFrame:CGRectMake(0, 40, 320, 327)];
		onsaleView.dataSource = onsaleView;
		onsaleView.delegate = onsaleView;
		onsaleView.onsaleDelegate = self;
		[self.view addSubview:onsaleView];
	}
	[self.view bringSubviewToFront:onsaleView];
	OnlyAccount *account = [OnlyAccount defaultAccount];
	
	NSString *parameters = [NSString stringWithFormat:@"%@|%@",account.account,account.gender];
    
    
    //NSString *parameters = [NSString stringWithFormat:@"%@|%@",account.account,gender];
    
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	NSString *onsaleStr = [NSString stringWithFormat:@"%@=OnSale&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"正在出售:%@",onsaleStr);
	
	NSURL *onSaleUrl = [[NSURL alloc] initWithString:onsaleStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:onSaleUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:onsaleView.frame];
	[self.view addSubview:loadingView];
	onSaleConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[onSaleUrl release];
}

-(void) showWillsaleView
{
	if(willsaleView == nil)
	{
		willsaleView = [[WillSaleView alloc] initWithFrame:CGRectMake(0, 40, 320, 327)];
		willsaleView.delegate = willsaleView;
		willsaleView.dataSource = willsaleView;
		[self.view addSubview:willsaleView];
	}
	[self.view bringSubviewToFront:willsaleView];
	OnlyAccount *account = [OnlyAccount defaultAccount];
	
	//NSString *parameters = [NSString stringWithFormat:@"%@",account.account];
    
    NSString *parameters = [NSString stringWithFormat:@"%@|%@",account.account,account.gender];
    
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	NSString *willsaleStr = [NSString stringWithFormat:@"%@=Willsale&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"即将出售:%@",willsaleStr);
	
	NSURL *willsaleUrl = [[NSURL alloc] initWithString:willsaleStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:willsaleUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:willsaleView.frame];
	[self.view addSubview:loadingView];
	willSaleConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[willsaleUrl release];
	
}

-(void) showCalenderView
{
	NSMutableArray * nArray = [[NSMutableArray alloc] init];
    self.calenderArray = nArray;
    [nArray release];
	OnlyAccount *account = [OnlyAccount defaultAccount];
	//NSString *parameters = [NSString stringWithFormat:@"%@",account.account];
    
    NSString *parameters = [NSString stringWithFormat:@"%@|%@",account.account,account.gender];
    
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	
	NSString *presellCalenderStr = [NSString stringWithFormat:@"%@=PresellCalender&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"出售日历:%@",presellCalenderStr);
	
	NSURL *calenderUrl = [[NSURL alloc] initWithString:presellCalenderStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:calenderUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 40, 320, 327)];
	[self.view addSubview:loadingView];
	calenderConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[calenderUrl release];
	
	if(calenderView)
	{
		[self.view bringSubviewToFront:calenderView];
	}
}

-(void) doChangeMode:(UISegmentedControl *) sender
{
	
    UISegmentedControl *_segControl = sender;
	_segControl.enabled = NO;
	NSLog(@"index = %d",_segControl.selectedSegmentIndex);
	switch (_segControl.selectedSegmentIndex) 
	{
		case 0:
		{
			[self showOnsaleView];
			break;
		}
		case 1:
		{
			[self showWillsaleView];
			break;
		}
		case 2:
		{
			[self showCalenderView];
			break;
		}
		default:
			break;
	}
	
}

#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
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
	NSError *error = nil;
	GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
	
	if(onSaleConnection == connection)
	{
		if(error)
		{
			[document release];
			[onSaleConnection release];
			return;
		}
		
		[MobClick event:@"onsale"];
		[onsaleView.onSaleArray removeAllObjects];
		GDataXMLElement *root = [document rootElement];
		NSArray *onsaleList = [root elementsForName:@"onsale"];
		for(GDataXMLElement *element in onsaleList)
		{
			OnSale *onsale = [[OnSale alloc] init];
			GDataXMLElement *ID = [[element elementsForName:@"id"] objectAtIndex:0];
			onsale.ID = [ID stringValue];
            
            
            //新接口添加代码处
            GDataXMLElement *date = [[element elementsForName:@"date"]objectAtIndex:0];
            NSString * dateStr = [date stringValue];
            onsale.date = [self changeStr:dateStr];

            //onsale.date = [date stringValue];
            GDataXMLElement *title = [[element elementsForName:@"title"]objectAtIndex:0];
            onsale.title = [title stringValue];
            GDataXMLElement *text = [[element elementsForName:@"text"]objectAtIndex:0];
            onsale.text = [text stringValue];
            /*
                        */ 
            
			GDataXMLElement *name = [[element elementsForName:@"name"] objectAtIndex:0];
			onsale.Name = [name stringValue];		
			GDataXMLElement *img = [[element elementsForName:@"img"] objectAtIndex:0];
			onsale.img = [img stringValue];
			[onsaleView.onSaleArray addObject:onsale];
			[onsale release];
		}
		[onsaleView reloadData];
		[onSaleConnection release];
		
		UISegmentedControl *seg =(UISegmentedControl *)[[self.view viewWithTag:201] viewWithTag:2001];// (UISegmentedControl *)self.navigationItem.titleView;
		seg.enabled = YES;
	}
	
	if(willSaleConnection == connection)
	{
		if(error)
		{
			[document release];
			[willSaleConnection release];
			return;
		}
		[MobClick event:@"willsale"];
		[willsaleView.willSaleArray removeAllObjects];
		GDataXMLElement *root = [document rootElement];
		NSArray *willsaleList = [root elementsForName:@"willsale"];
		for(GDataXMLElement *element in willsaleList)
		{
			Willsale *willsale = [[Willsale alloc] init];
			GDataXMLElement *ID = [[element elementsForName:@"id"] objectAtIndex:0];
			willsale.ID = [ID stringValue];	
            
            // 新接口添加代码处

           
            GDataXMLElement *date = [[element elementsForName:@"date"]objectAtIndex:0];
            NSString * dateStr = [date stringValue];
            willsale.date = [self changeStr:dateStr];
            //willsale.date = [date stringValue];
            GDataXMLElement *title = [[element elementsForName:@"title"]objectAtIndex:0];
            willsale.title = [title stringValue];
            GDataXMLElement *text = [[element elementsForName:@"text"]objectAtIndex:0];
            willsale.text = [text stringValue];



			GDataXMLElement *name = [[element elementsForName:@"name"] objectAtIndex:0];
			willsale.Name = [name stringValue];
			GDataXMLElement *img = [[element elementsForName:@"img"] objectAtIndex:0];
			willsale.img = [img stringValue];		
			[willsaleView.willSaleArray addObject:willsale];
			[willsale release];
		}
		[willsaleView reloadData];
		[willSaleConnection release];
		//UISegmentedControl *seg = (UISegmentedControl *)self.navigationItem.titleView;
		UISegmentedControl *seg =(UISegmentedControl *)[[self.view viewWithTag:201] viewWithTag:2001];
        seg.enabled = YES;
	}
	
	if(calenderConnection == connection)
	{
		if(error)
		{
			[document release];
			[calenderConnection release];
			return;
		}
		[MobClick event:@"calender"];
		[self.calenderArray removeAllObjects];
		GDataXMLElement *root = [document rootElement];
		NSArray *calenderList = [root elementsForName:@"calender"];
		for(GDataXMLElement *element in calenderList)
		{
			Calender *calender = [[Calender alloc] init];
			GDataXMLElement *date = [[element elementsForName:@"date"] objectAtIndex:0];            
            calender.date = [date stringValue];		
			GDataXMLElement *hot = [[element elementsForName:@"hot"] objectAtIndex:0];
			calender.hot = [hot stringValue];		
			[self.calenderArray addObject:calender];
			[calender release];
		}
		if(calenderView == nil)
		{
			calenderView = [[CalenderView alloc]initWithFrame:CGRectMake(0, 40, 320, 327) andArray:self.calenderArray];
			
			[self.view addSubview:calenderView];
			//[calenderView showFirstDayProductList];
		}
		calenderView.calenderArray = self.calenderArray;
		[calenderView showFirstDayProductList];
		
		[calenderConnection release];
		//UISegmentedControl *seg = (UISegmentedControl *)self.navigationItem.titleView;
		UISegmentedControl *seg =(UISegmentedControl *)[[self.view viewWithTag:201] viewWithTag:2001];
        seg.enabled = YES;
	}
	self.receivedData = nil;	
	[document release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	UISegmentedControl *seg = (UISegmentedControl *)self.navigationItem.titleView;
	seg.enabled = YES;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];	
	[connection release];
	self.receivedData = nil;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}


#pragma mark -
#pragma mark 释放相关
- (void)dealloc 
{
	self.receivedData = nil;
	[onsaleView release];
	if(onsaleListVC)
	{
		[onsaleListVC release];
	}
    [super dealloc];
}

@end
