    //
//  BlogDetailViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BlogDetailViewController.h"
#import "GDataXMLNode.h"

@implementation BlogDetailViewController
@synthesize receivedData;

- (void)returnBack
{
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UIWebViewDelegate
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//	loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
//	[self.view addSubview:loadingView];
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	self.navigationItem.leftBarButtonItem.enabled = YES;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	self.navigationItem.leftBarButtonItem.enabled = YES;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
}
#pragma mark -
#pragma mark 初始化

- (void)loadView
{
	//尚品logo
	//UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(84, 8, 148, 30)];
//	logoImageView.image = [UIImage imageNamed:@"Logo.png"];
//	self.navigationItem.titleView = logoImageView;
//	[logoImageView release];

    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoTittle.png"]];
    logoImageView.center = CGPointMake(160, [logoImageView center].y-5);
    self.navigationItem.titleView = logoImageView;
    [logoImageView release];

	
	//返回按钮
//	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	backButton.frame = CGRectMake(10, 7, 50, 30);
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//	[backButton setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal];
//	[backButton addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
//	
//	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//	self.navigationItem.leftBarButtonItem = backItem;
//	[backItem release];

    UIBarButtonItem *backBI = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(returnBack)];
    self.navigationItem.leftBarButtonItem = backBI;
    [backBI release];

	
	UIScrollView *blogDetailView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	blogDetailView.backgroundColor = [UIColor blackColor];
	blogDetailView.tag = 100;
	blogDetailView.scrollEnabled = YES;
	blogDetailView.autoresizesSubviews = YES;
	
	
	//标题   时间   内容
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5.0f, 320.0f, 20.0f)];
	titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
	titleLabel.textColor = WORDCOLOR;
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.backgroundColor = [UIColor clearColor];
	[blogDetailView addSubview:titleLabel];
	
	UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 25.0f, 300.0f, 1.0f)];
	lineLabel.backgroundColor = [UIColor darkGrayColor];
	[blogDetailView addSubview:lineLabel];
	[lineLabel release];
	
	timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30.0f, 310.0f, 15.0f)];
	timeLabel.font = [UIFont systemFontOfSize:14.0f];
	timeLabel.textColor = [UIColor grayColor];
	timeLabel.textAlignment = UITextAlignmentRight;
	timeLabel.backgroundColor = [UIColor clearColor];
	[blogDetailView addSubview:timeLabel];
	
	contentView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 45.0f, 320.0f, 320.0f)];
	contentView.backgroundColor = [UIColor clearColor];
	contentView.delegate = self;
    
	//contentView.scalesPageToFit = YES;
	
	[blogDetailView addSubview:contentView];
	
	self.view = blogDetailView;
	[blogDetailView release];
	
}

-(void) blogDetailContent:(NSString *) theID
{
	self.navigationItem.leftBarButtonItem.enabled = NO;
	NSString *parameters = [NSString stringWithFormat:@"%@",theID];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	NSString *blogDetailUrlStr = [NSString stringWithFormat:@"%@=BlogDetail&parameters=%@&md5=%@&u=&w=",ADDRESS,encodedString,md5Str];
	NSLog(@"博客明细:%@",blogDetailUrlStr);
	
	NSURL *blogDetailUrl = [[NSURL alloc] initWithString:blogDetailUrlStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:blogDetailUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:loadingView];
	detailConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[blogDetailUrl release];
}

#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"博客详情 获得服务器 回应");
	NSMutableData * nData = [[NSMutableData alloc] init];
    self.receivedData = nData;
    [nData release];
	[self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSLog(@"接收到 数据");
	[self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
	//[loadingView finishLoading];
//	[loadingView removeFromSuperview];
//	[loadingView release];
	NSError *error = nil;
	GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
	
	if(error)
	{
		[document release];
		[detailConnection release];
		return;
	}
	
	GDataXMLElement *root = [document rootElement];
	GDataXMLElement *title = [[root elementsForName:@"title"] objectAtIndex:0];
    titleLabel.text = [title stringValue];
	//self.title = @"尚品资讯";//titleLabel.text;
	GDataXMLElement *time = [[root elementsForName:@"time"] objectAtIndex:0];
	timeLabel.text = [time stringValue];
	GDataXMLElement *content = [[root elementsForName:@"content"] objectAtIndex:0];
	NSURL *blogUrl = [[NSURL alloc] initWithString:[content stringValue]];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:blogUrl];
	[contentView loadRequest:request];
	[request release];
	[blogUrl release];
	//[contentView loadHTMLString:[content stringValue] baseURL:nil];
	
	[document release];
	[detailConnection release];
	self.receivedData = nil;
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	self.navigationItem.leftBarButtonItem.enabled = YES;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	[detailConnection release];
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
	[titleLabel release];
	[timeLabel release];
	[contentView release];
    [super dealloc];
}


@end
