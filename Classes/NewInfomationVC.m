//
//  NewInfomationVC.m
//  ShangPin
//
//  Created by 唐彬琪 on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NewInfomationVC.h"
#import "NewsTextView.h"
#import "MyPageControl.h"
#import "CustomLabel.h"
#import "Blog.h"
#import "ShownActivity.h"
#import "SuperAct.h"
#import "GDataXMLNode.h"
#import "TouchImagView.h"
#import "OnsaleListViewController.h"

#import <QuartzCore/QuartzCore.h>



@implementation NewInfomationVC
@synthesize receivedData,blogArray,superActArray,showTime,NewsTableView;



- (void)dealloc
{
    
    [super dealloc];
    [textViewVC release];
    [pageControl release];
    [scrollImage release];
    [NewsTableView release];
    [blogArray release];
    self.receivedData = nil;
    
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
     UIView * bottomView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
     bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"inforBack.JPG"]];//[UIColor colorWithRed:0.18f green:0.18f blue:0.18f alpha:1.0f];
     //self.view = _windons;
 
     //导航栏logo
     mainView = [[UIScrollView alloc] initWithFrame:bottomView.frame];
     mainView.backgroundColor = [UIColor clearColor];
     mainView.contentSize = CGSizeMake(320, 680);
     mainView.showsVerticalScrollIndicator = NO;
     [bottomView addSubview:mainView];
     [mainView release];
     
     
     UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoTittle.png"]];
     //logoImageView.center = CGPointMake(160, [logoImageView center].y);
     self.navigationItem.titleView = logoImageView;
     [logoImageView release];
     
     
//     scrollImage = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
//     scrollImage.contentSize = CGSizeMake(320*8, 220);
//     scrollImage.pagingEnabled = YES;
//     scrollImage.showsHorizontalScrollIndicator = NO;
//     scrollImage.backgroundColor = [UIColor clearColor];
//     scrollImage.clipsToBounds = NO;
//     scrollImage.delegate = self;
//     [mainView addSubview:scrollImage];
    
     
//     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                          NSUserDomainMask, YES);
//     NSString *documentsDirectory = [paths objectAtIndex:0];
//     NSLog(@"documents path = %@",documentsDirectory);
     
     
     NewsTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 240, 310, 320) style:UITableViewStylePlain];
     NewsTableView.backgroundColor = [UIColor clearColor];
     NewsTableView.delegate = self;
     NewsTableView.dataSource = self;
     NewsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     NewsTableView.showsVerticalScrollIndicator = NO;
     NewsTableView.scrollEnabled = NO;
     [mainView addSubview:NewsTableView];
     self.view = bottomView;
     [bottomView release];
     
     //通知中心，添加接受通知的observer
     NSNotificationCenter * timerNT = [NSNotificationCenter defaultCenter];
     [timerNT addObserver:self selector:@selector(initTimer) name:@"StarTimer" object:nil];
     [timerNT addObserver:self selector:@selector(stopTimer) name:@"StopTimer" object:nil];
     NSLog(@"Rigestered whit notifiction Center");
     
}
-(void)setPageControl
{
    pageControl = [[MyPageControl alloc] initWithFrame:CGRectMake(0,225, 320, 10)];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.currentPage = 0;
    pageControl.enabled = NO;
    pageControl.numberOfPages = superCount;
    [pageControl setImagePageStateNormal:[UIImage imageNamed:@"WhitePoint.png"]];
    [pageControl setImagePageStateHighlighted:[UIImage imageNamed:@"YellowPoint.png"]];
    [mainView addSubview:pageControl];
    //[pageControl release]; 

}

- (void)loadImageNew{

    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%d",[superActArray count]);
    NSInteger scrollImageNum = [superActArray count];
    scrollImage = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
    scrollImage.contentSize = CGSizeMake(320*scrollImageNum, 220);
    scrollImage.pagingEnabled = YES;
    scrollImage.showsHorizontalScrollIndicator = NO;
    scrollImage.backgroundColor = [UIColor clearColor];
    scrollImage.clipsToBounds = NO;
    //scrollImage.scrollIndicatorInsets = UIEdgeInsetsMake(0, 320, 0, 0);
    [scrollImage setContentOffset:CGPointMake(320, 0) animated:NO];
    scrollImage.delegate = self;
    [mainView addSubview:scrollImage];

    
    
    NSInteger imageNum ;
    for (imageNum = 0; imageNum <scrollImageNum; imageNum++)
    {
        TouchImagView * showSellActView = [[TouchImagView alloc] initWithFrame:CGRectMake(320*imageNum, 0, 320, 220)];
        showSellActView.tag = imageNum+300;
        showSellActView.backgroundColor = [UIColor clearColor];
        ShownActivity * shownPic = [superActArray objectAtIndex:imageNum];
        [ImageCacheManager setImg:showSellActView withUrlString:shownPic.pic];
        showSellActView.delegate = self;
         [scrollImage addSubview:showSellActView];
        [showSellActView release];
        
    }
    [self setPageControl];
}

- (void)didTouchEndImagViewWithIndex:(int)index
{
    [self doRegister:index];
}

//初始化一个定时器
-(void)initTimer
{
      if (![showTime isValid]) 
      {
       // NSLog(@"启动定时器");
        //时间间隔
        NSTimeInterval timeInterval =4.0;
        //定时器
        showTime = [[NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                     target:self
                                                   selector:@selector(handleMaxShowTimer:)
                                                   userInfo:nil
                                                    repeats:YES] retain] ;

    }
}
//关闭定时器
-(void)stopTimer
{
    if ([showTime isValid]) 
    {
        //NSLog(@"关闭定时器");
        [showTime invalidate];
        //NSLog(@"%@",showTime);
        //[showTime release];
    }
}

//定时器触发事件
- (void)handleMaxShowTimer:(NSTimer *)theTimer
{
    NSLog(@"%s",__FUNCTION__);
    
    NSInteger autoScrollNum = [superActArray count] - 1;
    
    if (scrollImage.contentOffset.x == 320*autoScrollNum) {
        [scrollImage setContentOffset:CGPointMake(0, scrollImage.contentOffset.y) animated:YES];
    }
    else 
    {
        [scrollImage setContentOffset:CGPointMake(scrollImage.contentOffset.x+320, scrollImage.contentOffset.y) animated:YES];
    }
}

#pragma mark -
#pragma mark 登陆
-(void) doRegister:(int)index
{
	NSLog(@"%s",__FUNCTION__);
    [self stopTimer];
    if(loginVC == nil)
	{
		loginVC = [LogInViewController defaultLoginViewController];
	}
	
	if(loginVC.haslogin == FALSE)
	{
		[self presentModalViewController:loginVC animated:YES];
	}else
    {
    	if(onsaleListVC == nil)
        {
            onsaleListVC = [[OnsaleListViewController alloc] init];
        }
//     NSLog(@"%d",index);
        ShownActivity * picActivity = [superActArray objectAtIndex:(index-300)];
        [self.navigationController pushViewController:onsaleListVC animated:YES];
        [onsaleListVC onsaleList:picActivity.activityNO name:nil];

    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *parameters = [NSString stringWithFormat:@""];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	NSString *blogListUrlStr = [NSString stringWithFormat:@"%@=BlogList&parameters=%@&md5=%@&u=&w=",ADDRESS,encodedString,md5Str];
	NSLog(@"博客列表:%@",blogListUrlStr);
	
	NSURL *blogListUrl = [[NSURL alloc] initWithString:blogListUrlStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:blogListUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
	
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//self.view.frame];
	[self.view addSubview:loadingView];
	infoConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[blogListUrl release];
}

//加载图片展示活动接口
- (void)loadSuperAct{
    
    NSLog(@"%s",__FUNCTION__);
    NSString *parameters = [NSString stringWithFormat:@""];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	NSString *superActUrlStr = [NSString stringWithFormat:@"%@=LoopPicList&parameters=%@&md5=%@&u=&w=",ADDRESS,encodedString,md5Str];                                     //新接口到了即改正
	NSLog(@"活动推荐:%@",superActUrlStr);
	
	NSURL *superActUrl = [[NSURL alloc] initWithString:superActUrlStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:superActUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];

    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//self.view.frame];
	[self.view addSubview:loadingView];
	superActConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[superActUrl release];
}


#pragma  mark  -
#pragma  mark  UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSInteger pageNum = (scrollImage.contentOffset.x+160)/320;
//    pageControl.currentPage = pageNum;
//    [pageControl updateDots];
    int pagscroll  = scrollImage.contentOffset.x;
    
//    if (pagscroll/320 == superCount) 
//    {
//        scrollImage.contentOffset = CGPointMake(0, 0);
//    }
    if (pagscroll%320 ==0) {
        if (pagscroll/320==superCount+1) {
            pageControl.currentPage = 0;
            scrollImage.contentOffset = CGPointMake(320, 0);
        }else
            if (pagscroll ==0) {
                pageControl.currentPage = superCount;
                scrollImage.contentOffset = CGPointMake(320*superCount, 0);
            }
            pageControl.currentPage = pagscroll/320-1;
        
        [pageControl updateDots];
    }

}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
   int pagscroll  = scrollImage.contentOffset.x;
    //实现轮播的关键语句
//    if (pagscroll/320 == superCount) 
//    {
//        scrollImage.contentOffset = CGPointMake(0, 0);
//    }
    if (pagscroll%320 ==0) {
        if (pagscroll/320==superCount+1) {
            pageControl.currentPage = 0;
            scrollImage.contentOffset = CGPointMake(320, 0);
        }else 
            if (pagscroll ==0) {
                pageControl.currentPage = superCount;
                scrollImage.contentOffset = CGPointMake(320*superCount, 0);
            }
            pageControl.currentPage = pagscroll/320-1;
        
        [pageControl updateDots];
    }
}


#pragma mark -
#pragma mark  UITableviewDelegate and UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  [self.blogArray count];
    NSLog(@"%d",[self.blogArray count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"indcell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"indcell"]autorelease];
        cell.backgroundColor = [UIColor colorWithRed:0.898f green:0.898f blue:0.898f alpha:0.9f];
            
        UIView * cellBackView = [[UIView alloc] initWithFrame:cell.frame];//cell的选中背景视图
        cellBackView.backgroundColor = [UIColor colorWithRed:0.737f green:0.58f blue:0.114f alpha:0.2f];
        cell.selectedBackgroundView = cellBackView;
        [cellBackView release];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithRed:0.761f green:0.639f blue:0.259f alpha:1.0f];
        cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
        UIImageView * accessView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Accessary.png"]];
        cell.accessoryView = accessView;
        [accessView release];
    }
    Blog * blog = [self.blogArray objectAtIndex:indexPath.row];
    cell.textLabel.text = blog.title;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (textViewVC == nil) {
//        textViewVC = [[NewsTextView alloc] init];
//    }
//    [self.navigationController pushViewController:textViewVC animated:YES];
//    NSString * bolgText = [@"        "stringByAppendingString:[[self.blogArray objectAtIndex:indexPath.row] content]];
//    textViewVC.textView.text = bolgText;//[[self.blogArray objectAtIndex:indexPath.row] content];
//    textViewVC.titleLabel.text = [[self.blogArray objectAtIndex:indexPath.row] title];
//    textViewVC.timeLabel.text = [[self.blogArray objectAtIndex:indexPath.row] time];
//    //延迟取消cell选中状态
//    [self performSelector:@selector(deselect:) withObject:nil afterDelay:0.1f];
//    
//    [self stopTimer];
    
    if(blogVC == nil)
	{
		blogVC = [[BlogDetailViewController alloc] init];
	}
	
	Blog *blog = [self.blogArray objectAtIndex:indexPath.row];
	NSString *ID = blog.ID;
	
	[self.navigationController pushViewController:blogVC animated:YES];
	[blogVC blogDetailContent:ID];
    
    //延迟取消cell选中状态
    [self performSelector:@selector(deselect:) withObject:nil afterDelay:0.1f];

    [self stopTimer];
}

//取消选cell中状态
- (void)deselect:(id)sender
{
    [self.NewsTableView deselectRowAtIndexPath:[self.NewsTableView indexPathForSelectedRow] animated:YES];
}



#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"博客列表 获得服务器 回应1");
	
    NSMutableData * nData = [[NSMutableData alloc] init];
    self.receivedData = nData;
    [nData release];
	[self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSLog(@"接收到列表 数据1");
	[self.receivedData appendData:data];
    //data = nil ;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Succeeded! Received %d bytes of data_1",[self.receivedData length]);
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
       
    if (connection == infoConnection) 
    {
        NSError *error = nil;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
        
        if(error)
        {
            [document release];
            return;
        }
        GDataXMLElement *root = [document rootElement];
        NSArray *blogList = [root elementsForName:@"blog"];
        self.blogArray = [[[NSMutableArray alloc] init] autorelease];
        for(GDataXMLElement *element in blogList)
        {
            Blog *blog = [[Blog alloc] init];
            GDataXMLElement *ID = [[element elementsForName:@"id"] objectAtIndex:0];
            blog.ID = [ID stringValue];
            GDataXMLElement *title = [[element elementsForName:@"title"] objectAtIndex:0];
            blog.title = [title stringValue];
            GDataXMLElement *time = [[element elementsForName:@"time"] objectAtIndex:0];
            blog.time = [time stringValue];
            GDataXMLElement *content = [[element elementsForName:@"content"] objectAtIndex:0];
            blog.content = [content stringValue];
            //NSLog(@"blog.ID = %@,blog.title = %@,blog.time = %@,blog.content = %@",blog.ID,blog.title,blog.time,blog.content);
            [self.blogArray addObject:blog];
            [blog release];
        }
        
        [NewsTableView reloadData];
        [document release];
        [infoConnection release];
        self.receivedData = nil;
    
        //[self setPageControl];
        [self loadSuperAct];
        [self initTimer];

    //pageControl.numberOfPages = [blogArray count];
    }
        

    if (connection == superActConnection)
    {
        NSError *error = nil;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
        
        if(error)
        {
            [document release];
            return;
        }
        GDataXMLElement *root = [document rootElement];
        NSArray *blogList = [root elementsForName:@"pic"];
        //--self.superActArray
         NSMutableArray * mutableSuperActArray= [[NSMutableArray alloc] init];
        for(GDataXMLElement *element in blogList)
        {
            //SuperAct * superAct = [[SuperAct alloc] init];
            ShownActivity * picAct = [[ShownActivity alloc] init];
            GDataXMLElement *ID = [[element elementsForName:@"id"] objectAtIndex:0];
            picAct.activityID = [ID stringValue];
            GDataXMLElement *num = [[element elementsForName:@"no"] objectAtIndex:0];
            picAct.activityNO = [num stringValue];
            GDataXMLElement *Time = [[element elementsForName:@"time"] objectAtIndex:0];
            picAct.time = [Time stringValue];
            GDataXMLElement *Pic = [[element elementsForName:@"pic"] objectAtIndex:0];
            picAct.pic = [Pic stringValue];
          //NSLog(@"picAct.activityID = %@,picAct.activityNO = %@,picAct.time = %@,picAct.Pic = %@",picAct.activityID,picAct.activityNO,picAct.time,picAct.pic);
            [mutableSuperActArray addObject:picAct];
            NSLog(@"mutableSuperActArray   count = %d",[mutableSuperActArray count]);
            [picAct release];
        }
        //[self.superActArray initWithArray:mutableSuperActArray];
        superActArray  = [[NSMutableArray alloc] init];
        [superActArray addObjectsFromArray:mutableSuperActArray];
        [superActArray addObject:[mutableSuperActArray objectAtIndex:0]];
        [superActArray insertObject:[mutableSuperActArray objectAtIndex:(mutableSuperActArray.count-1)] atIndex:0];
        NSLog(@"self.superActArray    count = %d    %@",[self.superActArray count],superActArray);
        superCount = [self.superActArray count]-2;
        [mutableSuperActArray release];
        [self loadImageNew];
        [document release];
        [superActConnection release];

    }
    
   self.receivedData = nil; 
    
    

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	[infoConnection release];
	[textViewVC release];
    self.receivedData = nil;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


@end
