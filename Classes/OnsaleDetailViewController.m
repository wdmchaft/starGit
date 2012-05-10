    //
//  LimitBuyDetailViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OnsaleDetailViewController.h"
#import "OnsaleGroomFriendsViewController.h"
#import "GDataXMLNode.h"
#import "ConsigneeInfoViewController.h"
#import "Sku.h"
#import "Item2.h"
#import "Receiver.h"
#import "LoadingView.h"

@implementation OnsaleDetailViewController
@synthesize nameArray,valueArray;
@synthesize receivedData;
@synthesize skuArray;
@synthesize intro;
@synthesize smallImageArray,bigImageArray;
@synthesize skuNo,proNO,catNO;
@synthesize similarArray;
@synthesize receiverArray;
@synthesize voucherUrlStr;
@synthesize comKeepDelegate;
@synthesize changeImagDelegate;

#pragma mark -
#pragma mark 去掉电话号码里面的 空格 - ()
-(NSString*)trim:(NSString*)string
{
	NSString* returnStr = string;
	returnStr = [returnStr stringByTrimmingCharactersInSet:([NSCharacterSet whitespaceAndNewlineCharacterSet])];
	returnStr = [returnStr stringByReplacingOccurrencesOfString: @"<" withString: @""];
	returnStr = [returnStr stringByReplacingOccurrencesOfString: @">" withString: @""];
	returnStr = [returnStr stringByReplacingOccurrencesOfString: @"P" withString: @""];
	returnStr = [returnStr stringByReplacingOccurrencesOfString:@"B" withString: @""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString: @"R" withString: @""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString: @"/" withString: @""];
	return returnStr;
}



#pragma mark -
#pragma mark 推荐给好友
- (void)linkman
{
	NSString *theTitle = [Trim trim:titleLabel.text];
	NSString *shopPrice = [Trim trim:shoppePriceLabel.text];
	NSString *limitPrice = [Trim trim:VIPLabel.text];
	NSString *img = [self.smallImageArray objectAtIndex:pageControl.currentPage];
	NSArray *array = [[NSArray alloc] initWithObjects:theTitle,shopPrice,limitPrice,img,self.catNO,self.proNO,nil];
	OnsaleGroomFriendsViewController *groomFriendsVC = [[OnsaleGroomFriendsViewController alloc] init];
	UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:groomFriendsVC];	
	nv.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	nv.navigationBar.barStyle = UIBarStyleBlack;
	[self presentModalViewController:nv animated:YES];
	[groomFriendsVC showInfoWithArray:array];
	[groomFriendsVC release];
	[array release];
	[nv release];
}

#pragma mark -
#pragma mark 加入收藏 
//-(void) addKeep
//{
////    NSLog(@"    加入收藏                    ");
////    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"收藏商品成功" message:nil delegate:self cancelButtonTitle:@"查看我的收藏" otherButtonTitles:@"继续购物", nil];
////    alert.tag = 402;   
////    [alert show];
////    [alert release];
//
//	
//    OnlyAccount *account = [OnlyAccount defaultAccount];
//	NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@|%@",account.account,catPrice,self.proNO,self.catNO,@"1"];
//	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
//	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
//	
//	//[MobClick event:[NSString stringWithFormat:@"MyPrompt"] label:willsale.Name];
//    
//	
//	NSString *addKeep = [NSString stringWithFormat:@"%@=AddFavorite&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
//	NSLog(@"加入收藏:%@",addKeep);
//	NSURL *addKeepUrl = [[NSURL alloc] initWithString:addKeep];
//	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:addKeepUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//	loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
//	[self.view addSubview:loadingView];
//    addKeepConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//	[request release];
//	[addKeepUrl release];
//}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag ==400) 
    {
        
        if(buttonIndex == 0)
        {
//            [self.tabBarController setSelectedIndex:2];
//            [self performSelector:@selector(comeKeep) withObject:nil afterDelay:0.3f];
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            self.navigationItem.leftBarButtonItem.enabled = NO;
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
            NSString *attrName1 = nil;
            NSString *attrValue1 = nil;
            NSString *attrName2 = nil;
            NSString *attrValue2 = nil;
            if([self.nameArray count] == 1)
            {
                //attrName1 = [self.nameArray objectAtIndex:0];
                //attrValue1 = [self.valueArray objectAtIndex:0];
                
                attrName1 = [self.valueArray objectAtIndex:0];
                attrValue1 = colTextfield.text;
                
                attrName2 = @"";
                attrValue2 = @"";
            }
            if([self.nameArray count] == 2)
            {
                //attrName1 = [self.nameArray objectAtIndex:0];
                //			attrValue1 = [self.valueArray objectAtIndex:0];
                
                attrName1 = [self.valueArray objectAtIndex:0];
                attrValue1 = colTextfield.text;
                
                //attrName2 = [self.nameArray objectAtIndex:1];
                //			attrValue2 = [self.valueArray objectAtIndex:1];
                
                attrName2 = [self.valueArray objectAtIndex:1];
                attrValue2 = sizeTextfield.text;
            }	
            OnlyAccount *account = [OnlyAccount defaultAccount];
            NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@",account.account,self.proNO,self.catNO,@"1",attrName1,attrValue1,attrName2,attrValue2];
            NSString *encodedString = [URLEncode encodeUrlStr:parameters];
            NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
            
            self.voucherUrlStr = [NSString stringWithFormat:@"%@=GetAvailableVouchers&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
            //NSLog(@"不知道是什么 :%@",self.voucherUrlStr);
            NSString *buyproduct = [NSString stringWithFormat:@"%@=Receiver&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
            NSLog(@"购买:%@",buyproduct);
            NSURL *buyproductUrl = [[NSURL alloc] initWithString:buyproduct];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:buyproductUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
            [self.view addSubview:loadingView];
            buyProductConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [request release];
            [buyproductUrl release];
            
        }
    }
    else
    {
        if (buttonIndex == 0)
        {
            [self.tabBarController setSelectedIndex:2];
            [changeImagDelegate changeMyAccountImagNum:2];
            NSLog(@"%s",__FUNCTION__);
            [self performSelector:@selector(comeKeep) withObject:nil afterDelay:0.3f];
        }
    }    
}

//注册进入“我的收藏的通知”
- (void)comeKeep
{
    //注册通知中心，接收通知的类为 MyAccountViewController
    NSNotificationCenter * comeKeepNotice = [NSNotificationCenter defaultCenter];
    NSString * const  comeKeepNotifiction = @"comeKeep";
    [comeKeepNotice   postNotificationName:comeKeepNotifiction object:nil];
    NSLog(@"注册通知");
}

- (void)hideKeepButton
{
    addKeepButton.hidden = YES;
}



#pragma mark -
#pragma mark 购买
- (void)buy
{
	if(canBuy)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"亲爱的会员" message:@"所有商品限时抢购,请您在15分钟内提交订单.谢谢!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 400;
		[alert show];
		[alert release];
		
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"该商品已售罄" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

#pragma mark -
#pragma mark 回收pick 选择别款产品
-(void) down
{
	if(blackView.superview)
	{
		[UIView beginAnimations:@"up" context:nil];
		[UIView setAnimationDuration:0.3];
		blackView.frame = CGRectMake(0, 367, 320, 150);
		[UIView commitAnimations];
		[propPicker removeFromSuperview];
		[propPicker release];
		[blackView removeFromSuperview];
		[blackView release];
		blackView = nil;
	}
}

-(void) choose
{
	int selectRow = [propPicker selectedRowInComponent:0];	
	for(UIView *aview in scrollVC.subviews)
	{
		[aview removeFromSuperview];
	}
	
	Sku *sku = [self.skuArray objectAtIndex:selectRow];
	self.skuNo = sku.skuNo;
	colTextfield.text = sku.color;
	sizeTextfield.text = sku.size;
	quantityLabel.text = [NSString stringWithFormat:@"原价:%@",sku.quantity];
	VIPLabel.text = [NSString stringWithFormat:@"限时价:%@",sku.limitedprice];
	self.smallImageArray = [sku.image componentsSeparatedByString:@","];
	self.bigImageArray = [sku.bigimg componentsSeparatedByString:@","];
	pageControl.currentPage = 0;
	pageControl.numberOfPages = [self.smallImageArray count];
	scrollVC.contentSize = CGSizeMake(99 * [self.smallImageArray count], 133);
	for(int i = 0; i < [self.smallImageArray count]; i++)
	{
		TouchImagView *imgv = [[TouchImagView alloc] initWithFrame:CGRectMake(i * 100, 0, 99, 132)];
		imgv.delegate = self;
		imgv.tag = i;
		[scrollVC addSubview:imgv];
		[ImageCacheManager setImg:imgv withUrlString:[self.smallImageArray objectAtIndex:i]];
		[imgv release];
	}
	if([sku.quantity intValue])
	{
		canBuy = TRUE;
	}
	else
	{
		canBuy = FALSE;
	}
    UIImage * buy_common_image = [[UIImage imageNamed:@"YellowButtonBig.png"]stretchableImageWithLeftCapWidth:1.0f topCapHeight:0.0f];

    [buyButton setBackgroundImage:canBuy?buy_common_image:[UIImage imageNamed:@"buy-none.png"] forState:UIControlStateNormal];
	[buyButton setBackgroundImage:[UIImage imageNamed:@"buy-trap.png"] forState:UIControlStateHighlighted];
	[self down];
}

- (void)selectSize
{
	if(!blackView.superview)
	{
		blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 367, 320, 150)];
		blackView.backgroundColor = [UIColor blackColor];
		UIButton *downButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		downButton.frame = CGRectMake(240, 25, 60, 40);
		[downButton setTitle:@"确定" forState:UIControlStateNormal];
		[downButton addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
		[blackView addSubview:downButton];
		UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		cancelButton.frame = CGRectMake(240, 85, 60, 40);
		[cancelButton setTitle:@"取消" forState:UIControlStateNormal];
		[cancelButton addTarget:self action:@selector(down) forControlEvents:UIControlEventTouchUpInside];
		[blackView addSubview:cancelButton];
		propPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
		propPicker.frame = CGRectMake(0, 0, 220, 140);
		propPicker.showsSelectionIndicator = YES;
		propPicker.delegate = self;
		propPicker.dataSource =self;
		[blackView addSubview:propPicker];
		[self.view addSubview:blackView];
		[UIView beginAnimations:@"up" context:nil];
		[UIView setAnimationDuration:0.3];
		blackView.frame = CGRectMake(0, 367 - 140, 320, 140);
		[UIView commitAnimations];
	}
}

#pragma mark -
#pragma mark 返回列表
- (void)returnBack
{
	[self down];
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 商品详情 初始化
- (void)loadView
{
	//self.title = @"推荐给好友";
//	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	backButton.frame = CGRectMake(0, 0, 53, 29);
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [backButton setTitle:@"  返回" forState:UIControlStateNormal];
//    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//	[backButton setBackgroundImage:[UIImage imageNamed:@"BackAll.png"] forState:UIControlStateNormal];
//	[backButton addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
//	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//	self.navigationItem.leftBarButtonItem = backItem;
//	[backItem release];
    
    UIBarButtonItem *backBI = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(returnBack)];
    self.navigationItem.leftBarButtonItem = backBI;
    [backBI release];

    
	//推荐给好友
//	UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	rightButton.frame = CGRectMake(280, 0, 41, 29);
//	[rightButton setBackgroundImage:[UIImage imageNamed:@"linkman.png"] forState:UIControlStateNormal];
//	[rightButton addTarget:self action:@selector(linkman) forControlEvents:UIControlEventTouchUpInside];
//	UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//	self.navigationItem.rightBarButtonItem = right;
//	[right release];
	
	UIScrollView *limitBuyListView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	limitBuyListView.backgroundColor = [UIColor clearColor];
    limitBuyListView.contentSize = CGSizeMake(320, 500);
			
	scrollVC = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0f, 30.0f, 100.0f, 133.0f)];
	scrollVC.backgroundColor = [UIColor grayColor];
	scrollVC.scrollEnabled = YES;
	scrollVC.pagingEnabled = YES;
	scrollVC.delegate = self;
	[limitBuyListView addSubview:scrollVC];
	
	pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(30.0f, 165.0f, 60.0f, 15.0f)];
	pageControl.backgroundColor = [UIColor clearColor];
	pageControl.hidesForSinglePage = YES;
	[limitBuyListView addSubview:pageControl];
	
	bigScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(25, 4, 270, 360)];
	bigScrollV.backgroundColor = [UIColor grayColor];
	bigScrollV.scrollEnabled = YES;
	bigScrollV.pagingEnabled = YES;
	bigScrollV.delegate = self;
	
	bigPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(70, 345, 180, 20)];
	bigPageControl.backgroundColor = [UIColor clearColor];
	bigPageControl.hidesForSinglePage = YES;
	
	
	// 标题 类似prada女士棕色手提
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, 320.0f, 20.0f)];
	titleLabel.text = @"";
	titleLabel.font = [UIFont systemFontOfSize:14.0f];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.textColor = WORDCOLOR;
	titleLabel.backgroundColor = [UIColor clearColor];
	[limitBuyListView addSubview:titleLabel];
	
	// 原价
	shoppePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(115.0f, 30.0f, 200.0f, 20.0f)];
	shoppePriceLabel.text = @"原价:";
	shoppePriceLabel.font = [UIFont boldSystemFontOfSize:14.0f];
	shoppePriceLabel.textColor = [UIColor whiteColor];;
	shoppePriceLabel.backgroundColor = [UIColor clearColor];
	[limitBuyListView addSubview:shoppePriceLabel];
	
	//贯穿线
	lineThrough = [[UILabel alloc] initWithFrame:CGRectMake(115.0f, 40.0f, 0, 1.0f)];
	lineThrough.backgroundColor = [UIColor lightGrayColor];
	[limitBuyListView addSubview:lineThrough];
	
	//限时价
	VIPLabel = [[UILabel alloc] initWithFrame:CGRectMake(115.0f, 50.0f, 200.0f, 20.0f)];
	VIPLabel.text = @"限时价:";
	VIPLabel.font = [UIFont boldSystemFontOfSize:14.0f];
	VIPLabel.textColor = [UIColor whiteColor];;
	VIPLabel.backgroundColor = [UIColor clearColor];
	[limitBuyListView addSubview:VIPLabel];
	//属性1名称
	colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(115.0f, 80.0f, 70, 20.0f)];
	colorLabel.font = [UIFont boldSystemFontOfSize:14.0f];
	colorLabel.textColor = [UIColor whiteColor];;
	colorLabel.backgroundColor = [UIColor clearColor];
	colorLabel.hidden = TRUE;
	[limitBuyListView addSubview:colorLabel];
	//属性1值
	colTextfield = [[UITextField alloc] initWithFrame:CGRectMake(180, 80.0f, 50, 25.0f)];
	colTextfield.font = [UIFont boldSystemFontOfSize:14.0f];
	//colTextfield.inputView = colorPicker;
	colTextfield.enabled = NO;
	colTextfield.textColor = [UIColor blackColor];//colorWithRed:0.635f green:0.51f blue:0.29f alpha:1.0f];
	colTextfield.textAlignment = UITextAlignmentCenter;
	colTextfield.backgroundColor = [UIColor colorWithRed:0.988f green:0.859f blue:0.384f alpha:1.0f];
    colTextfield.layer.borderWidth = 1.0f;
    colTextfield.layer.borderColor = [[UIColor colorWithRed:0.635f green:0.51f blue:0.29f alpha:1.0f]CGColor];

	colTextfield.hidden = TRUE;
	[limitBuyListView addSubview:colTextfield];
	//属性1选择别的款
	colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
	colorButton.frame = CGRectMake(240, 80.0f, 60.0f, 25.0f);
	[colorButton setTitle:@"请选择" forState:UIControlStateNormal];
	[colorButton setTitleColor:WORDCOLOR forState:UIControlStateNormal];
    colorButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    colorButton.layer.borderWidth = 1.0f;
    colorButton.layer.borderColor = [[UIColor colorWithRed:0.635f green:0.51f blue:0.29f alpha:1.0f]CGColor];
	[colorButton addTarget:self action:@selector(selectSize) forControlEvents:UIControlEventTouchUpInside];
	colorButton.hidden = TRUE;
	[limitBuyListView addSubview:colorButton];
	//属性2名称
	sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 110.0f, 70, 20.0f)];
	sizeLabel.font = [UIFont boldSystemFontOfSize:14.0f];
	sizeLabel.textColor = [UIColor whiteColor];;
	sizeLabel.backgroundColor = [UIColor clearColor];
	sizeLabel.hidden = TRUE;
	[limitBuyListView addSubview:sizeLabel];
	//属性2值
	sizeTextfield = [[UITextField alloc] initWithFrame:CGRectMake(180, 110.0f, 50, 20.0f)];
	sizeTextfield.font = [UIFont boldSystemFontOfSize:14.0f];
	//sizeTextfield.inputView = sizePicker;
	sizeTextfield.enabled = NO;
	sizeTextfield.textColor = [UIColor colorWithRed:0.635f green:0.51f blue:0.29f alpha:1.0f];
	sizeTextfield.textAlignment = UITextAlignmentCenter;
	sizeTextfield.backgroundColor = [UIColor whiteColor];
    sizeTextfield.layer.borderWidth = 1.0f;
    sizeTextfield.layer.borderColor = [[UIColor colorWithRed:0.635f green:0.51f blue:0.29f alpha:1.0f]CGColor];

	sizeTextfield.hidden = TRUE;
	[limitBuyListView addSubview:sizeTextfield];
	//属性2选择别的款
	sizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	sizeButton.frame = CGRectMake(240, 110.0f, 60.0f, 20.0f);
	[sizeButton setTitle:@"请选择" forState:UIControlStateNormal];
	[sizeButton setTitleColor:WORDCOLOR forState:UIControlStateNormal];
    sizeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    sizeButton.layer.borderWidth = 1.0f;
    sizeButton.layer.borderColor = [[UIColor colorWithRed:0.635f green:0.51f blue:0.29f alpha:1.0f]CGColor];
	[sizeButton addTarget:self action:@selector(selectSize) forControlEvents:UIControlEventTouchUpInside];
	sizeButton.hidden = TRUE;
	[limitBuyListView addSubview:sizeButton];
	//剩余数量
//	quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 140, 80, 20)];
//	quantityLabel.textColor = [UIColor redColor];
//	quantityLabel.font = [UIFont boldSystemFontOfSize:14.0f];
//	quantityLabel.backgroundColor = [UIColor clearColor];
//	[limitBuyListView addSubview:quantityLabel];
	
	//购买按钮    
    buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	buyButton.frame = CGRectMake(240.0f, 140.0f, 74, 31);
    buyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [buyButton setTitle:@"购买" forState:UIControlStateNormal];
    buyButton.showsTouchWhenHighlighted = YES;
    buyButton.layer.masksToBounds = YES;
    buyButton.layer.cornerRadius = 2.0f;
    [buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	[buyButton addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
	[limitBuyListView addSubview:buyButton];
    
//    addKeepButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	addKeepButton.frame = CGRectMake(156.0f, 140.0f, 74, 31);
//    addKeepButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [addKeepButton setTitle:@"收藏" forState:UIControlStateNormal];
//    addKeepButton.showsTouchWhenHighlighted = YES;
//    addKeepButton.layer.masksToBounds = YES;
//    addKeepButton.layer.cornerRadius = 2.0f;
//    [addKeepButton setBackgroundImage:[UIImage imageNamed:@"shoucang.png"] forState:UIControlStateNormal];
//    [addKeepButton setBackgroundImage:[UIImage imageNamed:@"shoucanglight.png"] forState:UIControlStateHighlighted];
//    [addKeepButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [addKeepButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//	[addKeepButton addTarget:self action:@selector(addKeep) forControlEvents:UIControlEventTouchUpInside];
//	[limitBuyListView addSubview:addKeepButton];

	
	UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(-5, 183, 330, 70.0f)];
	pageView.backgroundColor = [UIColor colorWithRed:0.098f green:0.098f blue:0.098f alpha:1.0f];
	pageView.opaque = 0.25f;
    pageView.layer.borderWidth = 0.5f;
    pageView.layer.borderColor = [[UIColor colorWithRed:0.235f green:0.235f blue:0.235f alpha:1.0f]CGColor];

	[limitBuyListView addSubview:pageView];
	
    
    
    
	detailInfoWebview = [[UIWebView alloc] initWithFrame:CGRectMake(10, 263, 300.f, 200.0f)];
	detailInfoWebview.backgroundColor = [UIColor whiteColor];//colorWithRed:0.149f green:0.149f blue:0.149f alpha:1.0f];
    
//    UIFont * fontSize = [UIFont systemFontOfSize:16.0f];
//    UIColor * fontColor = [UIColor whiteColor];
//    NSString * stringValue = nil;
//    [NSString stringWithFormat:@"<html> \n"
//     "<head> \n"
//     "<style type=\"text/css\"> \n"
//     "body {font-family: \"%@\"; font-size: %f; color: %@;}\n"
//     "</style> \n"
//     "</head> \n"
//     "<body>%@</body> \n"
//     "</html>", @"宋体", fontSize,fontColor,stringValue];
//    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.color=%@",fontColor];
//    [detailInfoWebview stringByEvaluatingJavaScriptFromString:jsString];
//    [jsString release]; 
//    
//    UIColor * textColor = [UIColor whiteColor];
//    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextColorAdjust= '%@%%'",textColor];
//    [detailInfoWebview stringByEvaluatingJavaScriptFromString:jsString];
//    [jsString release];
//    detailInfoWebview.font = [UIFont systemFontOfSize:16.0f];
//    detailInfoWebview.textColor = [UIColor whiteColor];
//    detailInfoWebview.editable = NO;
    
    detailInfoWebview.layer.masksToBounds = YES;
    detailInfoWebview.layer.cornerRadius = 3.0f;
    detailInfoWebview.layer.borderColor = [[UIColor colorWithRed:0.235f green:0.235f blue:0.235f alpha:1.0f]CGColor];
    detailInfoWebview.layer.borderWidth = 1.0f;
    //detailInfoWebview.userInteractionEnabled = NO;
    detailInfoWebview.opaque = NO;
    [limitBuyListView addSubview:detailInfoWebview];
	
	UILabel *goodsView = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 20.0f, 66.0f)];
	goodsView.text = @"同类商品";
	goodsView.numberOfLines = 0;
	goodsView.textColor = [UIColor whiteColor];
	goodsView.font = [UIFont boldSystemFontOfSize:13.0f];
	goodsView.backgroundColor = [UIColor clearColor];
	//同类产品scroll
	otherProductScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(35, 0, 330, 70)];
	otherProductScroll.contentSize = CGSizeMake(340, 70.0f);
    otherProductScroll.backgroundColor = [UIColor clearColor];
    otherProductScroll.showsHorizontalScrollIndicator = NO;
//    otherProductScroll.layer.masksToBounds = YES;
//    otherProductScroll.layer.cornerRadius = 1.0f;
	[pageView addSubview:otherProductScroll];
    [pageView addSubview:goodsView];
	[goodsView release];
    [pageView release];
	
	
	
    UIView * mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    mainView.backgroundColor = [UIColor clearColor];
    [mainView addSubview: limitBuyListView];
    [limitBuyListView release];
	self.view = mainView;
    [mainView release];
	//[limitBuyListView release];
}

#pragma mark -
#pragma mark 加载产品信息
-(void) detailInfo:(NSString *)theProductID catID:(NSString *)catID
{
	NSLog(@"加载产品信息");
    [MobClick event:[NSString stringWithFormat:@"productDetail"] label:[NSString stringWithFormat:@"%@-%@",theProductID,catID]];
	
	self.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	OnlyAccount *account = [OnlyAccount defaultAccount];
	self.proNO = theProductID;
	self.catNO = catID;
	NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@",account.account,theProductID,catID];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	NSString *detailStr = [NSString stringWithFormat:@"%@=OnSaleDetail&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"商品详细:%@",detailStr);
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	NSURL *detailUrl = [[NSURL alloc] initWithString:detailStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:detailUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:loadingView];
	detailConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[detailUrl release];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [self.skuArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	Sku *sku = [self.skuArray objectAtIndex:row];
	if([self.nameArray count] == 1)
	{
		NSString *color = sku.color;
		return color;
	}
	else
	{
		NSString *color = sku.color;
		NSString *size = sku.size;
		return [NSString stringWithFormat:@"%@----%@",color,size];
	}
	
}

#pragma mark -
#pragma mark NSURLConnection delegate
-(float)contentWidth: (NSString *)string
{
	CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(260, 500) lineBreakMode:UILineBreakModeCharacterWrap];
	float width = size.width;
	return width;
}

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
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
	NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	// 商品详情解析
    if(connection == detailConnection)
	{
		NSError *error = nil;
		GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
		if(error)
		{
			[document release];
			[detailConnection release];
            self.navigationItem.leftBarButtonItem.enabled = YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
			return;
		}
		
		GDataXMLElement *root = [document rootElement];
		GDataXMLElement *productname = [[root elementsForName:@"productname"] objectAtIndex:0];		//商品的标题
		
		titleLabel.text = [NSString stringWithFormat:@"%@",[Trim trim:[productname stringValue]]];
		self.title = titleLabel.text;
		GDataXMLElement *marketprice = [[root elementsForName:@"marketprice"] objectAtIndex:0];		//专柜价
		NSString *rackrate = [NSString stringWithFormat:@"原价:%@",[Trim trim:[marketprice stringValue]]];
		shoppePriceLabel.text = rackrate;
		float width = [self contentWidth:rackrate];
		lineThrough.frame = CGRectMake(115, 40, width, 1);
		
		GDataXMLElement *prop = [[root elementsForName:@"prop"] objectAtIndex:0];
		NSArray *array1 = [prop elementsForName:@"propname"];		//属性名称
		NSMutableArray * newArray = [[NSMutableArray alloc] init];
        self.nameArray = newArray;
        [newArray release];
		for(GDataXMLElement *propname in array1)
		{
			if([[Trim trim:[propname stringValue]] length] != 0)
			{
				[self.nameArray addObject:[propname stringValue]];
			}
		}
		NSArray *array2 = [prop elementsForName:@"propvalue"];		//属性值
		NSMutableArray * nArray = [[NSMutableArray alloc] init];
        self.valueArray = nArray;
        [nArray release];
		for(GDataXMLElement *propvalue in array2)
		{
			if([[Trim trim:[propvalue stringValue]] length] != 0)
			{
				[self.valueArray addObject:[propvalue stringValue]];
			}
		}
		for(UIView *aview in scrollVC.subviews)
		{
			[aview removeFromSuperview];
		}
		for(UIView *bigView in bigScrollV.subviews)
		{
			[bigView removeFromSuperview];
		}
		
		NSArray *array3 = [prop elementsForName:@"sku"];
		NSMutableArray * sArray = [[NSMutableArray alloc] init];
        self.skuArray = sArray;
        [sArray release];
		for(GDataXMLElement *sku in array3)
		{
			Sku *theSku = [[Sku alloc] init];
			GDataXMLElement *theskuNo = [[sku elementsForName:@"skuNo"] objectAtIndex:0];		//单品编号
			theSku.skuNo = [theskuNo stringValue];
			GDataXMLElement *color = [[sku elementsForName:@"color"] objectAtIndex:0];		//属性1
			theSku.color = [color stringValue];
			GDataXMLElement *size = [[sku elementsForName:@"size"] objectAtIndex:0];		//属性2
			theSku.size = [size stringValue];
			GDataXMLElement *quantity = [[sku elementsForName:@"quantity"] objectAtIndex:0];//库存
			theSku.quantity = [quantity stringValue];
			GDataXMLElement *level = [[sku elementsForName:@"level"] objectAtIndex:0];		//会员等级
			theSku.level = [level stringValue];
			GDataXMLElement *limitedprice = [[sku elementsForName:@"limitedprice"] objectAtIndex:0];	//限时价
			theSku.limitedprice = [Trim trim:[limitedprice stringValue]];
			GDataXMLElement *image = [[sku elementsForName:@"image"] objectAtIndex:0];		//小图
			theSku.image = [Trim trim:[image stringValue]];
			GDataXMLElement *bigimg = [[sku elementsForName:@"bigimg"] objectAtIndex:0];	//大图
			theSku.bigimg = [Trim trim:[bigimg stringValue]];
			[self.skuArray addObject:theSku];
			[theSku release];
		}
		
		Sku *sku = nil;
		int first = 0;
		for(;first < [self.skuArray count];first ++)
		{
			sku	= [self.skuArray objectAtIndex:first];
			if([sku.quantity intValue] != 0)
			{
				break;
			}
		}
		if(first == [self.skuArray count])
		{
			first = 0;
		}
		
		
		sku = [self.skuArray objectAtIndex:first];
		self.smallImageArray = [sku.image componentsSeparatedByString:@","];
		self.bigImageArray = [sku.bigimg componentsSeparatedByString:@","];
		
		pageControl.currentPage = 0;
		pageControl.numberOfPages = [self.smallImageArray count];
		bigPageControl.currentPage = 0;
		bigPageControl.numberOfPages = [self.bigImageArray count];
		
		self.skuNo = sku.skuNo;
		VIPLabel.text = [NSString stringWithFormat:@"限时价:%@",sku.limitedprice];
		catPrice = sku.limitedprice;
        quantityLabel.text = [NSString stringWithFormat:@"剩余数量:%@",sku.quantity];
		scrollVC.contentSize = CGSizeMake(100 * [self.smallImageArray count], 133);
		bigScrollV.contentSize = CGSizeMake(270 * [self.bigImageArray count], 360);
		for(int i = 0; i < [self.smallImageArray count]; i++)
		{
			TouchImagView *imgv = [[TouchImagView alloc] initWithFrame:CGRectMake(i * 100, 0, 100, 133)];
			imgv.delegate = self;
			imgv.tag = i;
			[scrollVC addSubview:imgv];
			[ImageCacheManager setImg:imgv withUrlString:[self.smallImageArray objectAtIndex:i]];
			[imgv release];
			
			
			UIImageView *bigImgv = [[UIImageView alloc] initWithFrame:CGRectMake(i * 270, 0, 270, 360)];
			[bigScrollV addSubview:bigImgv];
			[ImageCacheManager setImg:bigImgv withUrlString:[self.bigImageArray objectAtIndex:i]];
			[bigImgv release];
		}
		
		
		colorLabel.hidden = FALSE;
		colTextfield.hidden = FALSE;
		if([sku.quantity intValue])				//判断是否有货物
		{
			canBuy = TRUE;
		}
		else
		{
			canBuy = FALSE;
		}

        UIImage * buy_common_image = [[UIImage imageNamed:@"YellowButtonBig.png"]stretchableImageWithLeftCapWidth:1.0f topCapHeight:0.0f];
        [buyButton setBackgroundImage:canBuy?buy_common_image:[UIImage imageNamed:@"buy-none.png"] forState:UIControlStateNormal];
		[buyButton setBackgroundImage:[UIImage imageNamed:@"buy-trap.png"] forState:UIControlStateHighlighted];
		
		if([self.nameArray count] == 1)	//如果只有一个属性
		{
			NSString *attr1 = [NSString stringWithFormat:@"%@:",[Trim trim:[self.nameArray objectAtIndex:0]]];
			float width = [self contentWidth:attr1] + 5;
			colorLabel.frame = CGRectMake(115, 80, width, 20);
			colorLabel.text = attr1;
			
			float width2 = [self contentWidth:sku.color] + 5;
			colTextfield.frame = CGRectMake(116+width, 80, width2, 20);
			colTextfield.text = sku.color;
			colorButton.frame = CGRectMake(115+width+width2, 80, 60, 20);
			
			sizeLabel.hidden = TRUE;
			sizeTextfield.hidden = TRUE;
			sizeButton.hidden = TRUE;
			
			if([self.skuArray count] == 1)
			{
				colorButton.hidden = TRUE;
			}
			if([self.skuArray count] > 1)
			{
				colorButton.hidden = NO;
			}
		}
		if([self.nameArray count] == 2)  //如果两个属性
		{
			NSString *attr1 = [NSString stringWithFormat:@"%@:",[Trim trim:[self.nameArray objectAtIndex:0]]];
			float width = [self contentWidth:attr1] + 5;
			colorLabel.frame = CGRectMake(115, 80, width, 20);
			colorLabel.text = attr1;
			
			float width2 = [self contentWidth:sku.color] + 5;
			colTextfield.frame = CGRectMake(116+width, 80, width2, 20);
			colTextfield.text = sku.color;
			colorButton.frame = CGRectMake(115+width+width2, 80, 60, 20);
			
			NSString *attr2 = [NSString stringWithFormat:@"%@:",[Trim trim:[self.nameArray objectAtIndex:1]]];
			float width3 = [self contentWidth:attr2] +5 ;
			sizeLabel.frame = CGRectMake(115, 110, width3, 20);
			sizeLabel.text = attr2;
			sizeLabel.hidden = FALSE;
			
			float width4 = [self contentWidth:sku.size] + 5;
			sizeTextfield.frame = CGRectMake(116 + width3, 110, width4, 20);
			sizeTextfield.text = sku.size;
			sizeTextfield.hidden = FALSE;
			sizeButton.frame = CGRectMake(115 + width3 +width4, 110, 60, 20);
			if([self.skuArray count] == 1)
			{
				colorButton.hidden = TRUE;
				sizeButton.hidden = YES;
			}
			if([self.skuArray count] > 1)
			{
				colorButton.hidden = NO;
				sizeButton.hidden = NO;
			}
			
		}
		
		GDataXMLElement *theIntro = [[root elementsForName:@"intro"] objectAtIndex:0];		//产品描述
		self.intro = [theIntro stringValue];
        //NSLog(@"self.intro = %@",self.intro);
		//detailInfoWebview.text = self.intro;
		[detailInfoWebview loadHTMLString:self.intro baseURL:nil];
		
		[document release];
		[detailConnection release];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;

        
		[self similarProductlistWithCatNo:self.catNO andProductNo:self.proNO];
	}
	//同类产品解析
	if(similarConnection == connection)
	{
		NSError *error = nil;
		GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
		if(error)
		{
			[document release];
			[similarConnection release];
            self.navigationItem.leftBarButtonItem.enabled = YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
			return;
		}
		GDataXMLElement *root = [document rootElement];
		NSArray *array = [root elementsForName:@"item"];
		NSMutableArray * nArray = [[NSMutableArray alloc] init];
        self.similarArray = nArray;
        [nArray release];
		for(GDataXMLElement *item in array)
		{
			Item2 *similarItem = [[Item2 alloc] init];
			GDataXMLElement *productNo = [[item elementsForName:@"id"] objectAtIndex:0];
			similarItem.productNo = [productNo stringValue];
			GDataXMLElement *catNo = [[item elementsForName:@"cat"] objectAtIndex:0];
			similarItem.catNo = [catNo stringValue];
			GDataXMLElement *img = [[item elementsForName:@"img"] objectAtIndex:0];
			similarItem.img = [img stringValue];
			[self.similarArray addObject:similarItem];
			[similarItem release];
		}
		for(UIView *aview in otherProductScroll.subviews)
		{
			[aview removeFromSuperview];
		}
		for(int i = 0; i < [self.similarArray count]; i++)
		{
			SimilarProductImageView *spIV = [[SimilarProductImageView alloc] initWithFrame:CGRectMake(10+i * 50 , 5, 45, 60)];
			spIV.delegate = self;
			Item2 *similarItem = [self.similarArray objectAtIndex:i];
			spIV.catNo = similarItem.catNo;
			spIV.productNo = similarItem.productNo;
			[otherProductScroll addSubview:spIV];
			[ImageCacheManager setImg:spIV withUrlString:similarItem.img];
			[spIV release];
		}
		[document release];
		[similarConnection release];
		self.navigationItem.leftBarButtonItem.enabled = YES;
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
	// 购买解析
	if (buyProductConnection == connection) 
	{
		NSError *error = nil;
		GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
		if(error)
		{
			[document release];
			[buyProductConnection release];
            self.navigationItem.leftBarButtonItem.enabled = YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
			return;
		}
		GDataXMLElement *root = [document rootElement];
		NSArray *array = [root elementsForName:@"receiver"];
		self.receiverArray = [NSMutableArray array];
		
		
		for(GDataXMLElement *receiver in array)
		{
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
			Receiver *theReceiver = [[Receiver alloc] init];
			GDataXMLElement *name = [[receiver elementsForName:@"name"] objectAtIndex:0];
			theReceiver.Name = [name stringValue];
			GDataXMLElement *city = [[receiver elementsForName:@"city"] objectAtIndex:0];
			theReceiver.city = [city stringValue];
			GDataXMLElement *address = [[receiver elementsForName:@"address"] objectAtIndex:0];
			theReceiver.address = [address stringValue];
			GDataXMLElement *postcode = [[receiver elementsForName:@"postcode"] objectAtIndex:0];
			theReceiver.postcode = [postcode stringValue];
			GDataXMLElement *phone = [[receiver elementsForName:@"phone"] objectAtIndex:0];
			theReceiver.phone = [phone stringValue];
			GDataXMLElement *mobile = [[receiver elementsForName:@"mobile"] objectAtIndex:0];
			theReceiver.mobile = [mobile stringValue];
			GDataXMLElement *consigneeid = [[receiver elementsForName:@"consigneeid"] objectAtIndex:0];
			theReceiver.consigneeid = [consigneeid stringValue];
			GDataXMLElement *isdefault = [[receiver elementsForName:@"isdefault"] objectAtIndex:0];
			theReceiver.isdefault = [isdefault stringValue];
			[self.receiverArray addObject:theReceiver];
			[theReceiver release];
			[pool drain];
		}
		self.navigationItem.leftBarButtonItem.enabled = YES;
		self.navigationItem.rightBarButtonItem.enabled = YES;
		if ([self.receiverArray count] != 0) 
		{
			ConsigneeInfoViewController *consigneeVC = [[ConsigneeInfoViewController alloc] init];
			consigneeVC.receiverArray = self.receiverArray;
			consigneeVC.proNO = self.proNO;
			consigneeVC.voucherUrlStr = self.voucherUrlStr;
			self.receiverArray = nil;
			self.voucherUrlStr = nil;
			[self.navigationController pushViewController:consigneeVC animated:YES];
			[consigneeVC defaultReceiverInfo];
			[consigneeVC release];
		}
		
		[document release];
		[buyProductConnection release];
	}
	//加入收藏 解析
//    if (addKeepConnection == connection) 
//    {
//        NSLog(@"解析 来自  加入收藏链接  的 返回数据");
//        
//        NSString *str = [NSString stringWithCString:[self.receivedData bytes] encoding:NSASCIIStringEncoding];
//        char flag = [str characterAtIndex:0];
//        if(flag == '1')
//        {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"收藏商品成功" message:nil delegate:self cancelButtonTitle:@"查看我的收藏" otherButtonTitles:@"继续购物", nil];
//        alert.tag = 401;   
//        [alert show];
//        [alert release];
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""	message:@"加入收藏失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//            [alert release];
//        }
//
//    }
    self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	self.receivedData = nil;
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
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
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if(scrollView == scrollVC)
	{
		int page = (scrollVC.contentOffset.x/100);
		pageControl.currentPage = page;
	}
	if(scrollView == bigScrollV)
	{
		int page = (bigScrollV.contentOffset.x/270);
		bigPageControl.currentPage = page;
	}
}

#pragma mark 关闭大图 显示大图
-(void) doCloseBigImage
{
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	//[bigImgV removeFromSuperview];
	[bigScrollV removeFromSuperview];
	[backView removeFromSuperview];
	[bigPageControl removeFromSuperview];
	UIButton *close = (UIButton *)[self.view viewWithTag:1026];
	[close removeFromSuperview];
}

-(void)bigImageWithIndex:(int) index
{
	self.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	if(backView == nil)
	{
		backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
		backView.backgroundColor = [UIColor blackColor];
		backView.alpha = 0.3;
		//bigImgV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 4, 270, 360)];
//		bigImgV.backgroundColor = [UIColor whiteColor];
//		bigImgV.userInteractionEnabled = YES;
		//UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
//		close.frame = CGRectMake(225, 10, 35, 38);
//		[close setBackgroundImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
//		[close addTarget:self action:@selector(doCloseBigImage) forControlEvents:UIControlEventTouchUpInside];
		//[bigImgV addSubview:close];
	}
	UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
	close.frame = CGRectMake(250, 14, 35, 38);
	close.tag = 1026;
	[close setBackgroundImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
	[close addTarget:self action:@selector(doCloseBigImage) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backView];
	//[self.view addSubview:bigImgV];
	[self.view addSubview:bigScrollV];
	[self.view addSubview:close];
	[self.view addSubview:bigPageControl];
	bigScrollV.contentOffset = CGPointMake(270 * index, 0);
	bigPageControl.currentPage = index;
	//[ImageCacheManager setImg:bigImgV withUrlString:[self.bigImageArray objectAtIndex:index]];
	//NSLog(@"bigimage:%@",[self.bigImageArray objectAtIndex:index]);
}


//点击商品图片，出现大图
-(void) didTouchEndImagViewWithIndex:(int) index
{
	[self bigImageWithIndex:index];
}

#pragma mark-
#pragma alertViewDelegate  Method
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//
//}

#pragma mark -
#pragma mark 获得同类产品信息
-(void) similarProductlistWithCatNo:(NSString *)theCatNo andProductNo:(NSString *)theProductNo
{
	self.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	OnlyAccount *account = [OnlyAccount defaultAccount];
	NSString *parameters = [NSString stringWithFormat:@"%@|%@",theCatNo,theProductNo];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	NSString *similarProduct = [NSString stringWithFormat:@"%@=Similarproductlist&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"同类商品:%@",similarProduct);
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	NSURL *similarProductUrl = [[NSURL alloc] initWithString:similarProduct];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:similarProductUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:loadingView];
	similarConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[similarProductUrl release];
}

-(void) didTouchEndSimilarProduct:(id) similarProduct
{
	SimilarProductImageView *spIV = (SimilarProductImageView *)similarProduct;
	[self detailInfo:spIV.productNo catID:spIV.catNo];
}

#pragma mark -
#pragma mark 释放相关

- (void)dealloc 
{
	[titleLabel release];
	[shoppePriceLabel release];
	[lineThrough release];
	[VIPLabel release];
	[colorLabel release];
	[sizeLabel release];
	[colTextfield release];
	[sizeTextfield release];
	[quantityLabel release];
	
	[pageControl release];
	[scrollVC release];
	[backView release];
	[bigImgV release];
	
	[otherProductScroll release];
	[detailInfoWebview release];
	
	self.proNO = nil;
	self.catNO = nil;
	self.skuNo = nil;
	self.smallImageArray = nil;
	self.bigImageArray = nil;
	self.receivedData = nil;
	self.receiverArray = nil;
	self.similarArray = nil;
	self.nameArray = nil;
	self.valueArray = nil;
	self.skuArray = nil;
	self.intro = nil;
	self.voucherUrlStr = nil;

    [super dealloc];
}


@end
