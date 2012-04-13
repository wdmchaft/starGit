    //
//  LimitBuyListViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OnsaleListViewController.h"
#import "OnsaleDetailViewController.h"
#import "GDataXMLNode.h"
#import "Item.h"
#import "Catalog.h"
#import "CustomLabel.h"

@implementation OnsaleListViewController
@synthesize onsaleCatalogArray;
@synthesize receivedData;


- (void)returnBack
{
	[self.navigationController popViewControllerAnimated:YES];
    NSNotificationCenter * noticeCenter = [NSNotificationCenter defaultCenter];
    NSString * const StarTimerNotification = @"StarTimer";
    [noticeCenter postNotificationName:StarTimerNotification object:self];

}

#pragma mark -
#pragma mark 初始化

- (void)loadView 
{
	listMode = TRUE;
	
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
    
	//模式切换 （列表模式，九宫格）
	UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
	rightButton.frame = CGRectMake(280, 0, 41, 29);
	[rightButton setBackgroundImage:[UIImage imageNamed:@"Square.png"] forState:UIControlStateNormal];
	[rightButton addTarget:self action:@selector(doChangeMode) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *changeModeBI = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
	self.navigationItem.rightBarButtonItem = changeModeBI;
    [changeModeBI release];
	
	
	UIView *limitBuyListView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	limitBuyListView.backgroundColor = [UIColor blackColor];
	
	//产品列表
	onSaleTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	onSaleTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
	onSaleTableview.backgroundColor = [UIColor blackColor];
	onSaleTableview.dataSource = self;
	onSaleTableview.delegate = self;
	[limitBuyListView addSubview:onSaleTableview];
	
	self.view = limitBuyListView;
	[limitBuyListView release];
}

#pragma mark -
#pragma mark tableview methods

-(float)contentWidth: (NSString *)string
{
	CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(260, 500) lineBreakMode:UILineBreakModeCharacterWrap];
	float width = size.width;
	return width;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.onsaleCatalogArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	Catalog *catalog = [self.onsaleCatalogArray objectAtIndex:section];
	NSMutableArray *items = catalog.itemArray;
	return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
		cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x110.png"]];
		
		UIImageView *accImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Accessary.png"]];
		cell.accessoryView = accImg;
		[accImg release];
		
		UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 66.0f, 88.0f)];
		leftView.backgroundColor = [UIColor grayColor];
		leftView.tag = 100;
		[cell.contentView addSubview:leftView];
		[leftView release];
		
		//UIImageView *stateImgV = [[UIImageView alloc] initWithFrame:CGRectMake(54, 10, 22, 17)];
//		stateImgV.tag = 101;
//		[cell.contentView addSubview:stateImgV];
//		[stateImgV release];
		
		CustomLabel *firstLb = [[CustomLabel alloc] initWithFrame:CGRectMake(86.0f, 8, 200, 32)];
		firstLb.tag = 200;
		firstLb.font = [UIFont systemFontOfSize:14];
		firstLb.textColor = WORDCOLOR;
		firstLb.numberOfLines = 0;
		firstLb.verticalAlignment = VerticalAlignmentTop;
		firstLb.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:firstLb];
		[firstLb release];
		
		UILabel *secondLb = [[UILabel alloc] initWithFrame:CGRectMake(86.0f, 40, 240.0f, 20.0f)];
		secondLb.tag = 201;
		secondLb.textColor = [UIColor whiteColor];
		secondLb.font = [UIFont systemFontOfSize:14];
		secondLb.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:secondLb];
		[secondLb release];
		
		UILabel *lineLB = [[UILabel alloc] initWithFrame:CGRectMake(86.0f, 50, 100.0f, 1.0f)];
		lineLB.tag = 199;
		lineLB.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
		[cell.contentView addSubview:lineLB];
		[lineLB release];
		
		UILabel *thirdLb = [[UILabel alloc] initWithFrame:CGRectMake(86.0f, 60, 240.0f, 20.0f)];
		thirdLb.tag = 202;
		thirdLb.textColor = [UIColor whiteColor];
		thirdLb.font = [UIFont systemFontOfSize:14];
		thirdLb.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:thirdLb];
		[thirdLb release];
		
		UILabel *fourLb = [[UILabel alloc] initWithFrame:CGRectMake(86.0f, 80, 240.0f, 20.0f)];
		fourLb.tag = 203;
		fourLb.textColor = [UIColor whiteColor];
		fourLb.font = [UIFont systemFontOfSize:14];
		fourLb.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:fourLb];
		[fourLb release];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	Catalog *catalog = [self.onsaleCatalogArray objectAtIndex:indexPath.section];
	Item *item = [catalog.itemArray objectAtIndex:indexPath.row];
	
	UIImageView *leftView = (UIImageView *)[cell.contentView viewWithTag:100];
	[ImageCacheManager setImg:leftView  withUrlString:item.img];
	
	//UIImageView *stateImgV = (UIImageView *)[cell.contentView viewWithTag:101];
//	int type = [item.Type intValue];
//	switch (type)
//	{
//		case 1:
//		{
//			stateImgV.image = [UIImage imageNamed:@"TuiJian.png"];
//			break;
//		}
//		case 3:
//		{
//			stateImgV.image = [UIImage imageNamed:@"New.png"];
//			break;
//		}
//		case 4:
//		{
//			stateImgV.image = [UIImage imageNamed:@"ShQ.png"];
//			break;
//		}
//		default:
//		{
//			stateImgV.image = nil;
//			break;
//		}
//	}
	CustomLabel *firstLb = (CustomLabel *)[cell.contentView viewWithTag:200];
	firstLb.text = item.Name;
	
	UILabel *secondLb = (UILabel *)[cell.contentView viewWithTag:201];
	secondLb.text = [NSString stringWithFormat:@"专柜价:%@",item.rackrate];
	
	float width = [self contentWidth:secondLb.text];
	UILabel *line = (UILabel *)[cell.contentView viewWithTag:199];
	line.frame = CGRectMake(86, 50, width, 1);
	
	UILabel *thirdLb = (UILabel *)[cell.contentView viewWithTag:202];
	thirdLb.text = [NSString stringWithFormat:@"限时价:%@",item.limitedprice];
	
	if([item.Count intValue] < 10)
	{
		UILabel *fourLb = (UILabel *)[cell.contentView viewWithTag:203];
		fourLb.text = [NSString stringWithFormat:@"剩余数量:%@",item.Count];
	}
	else
	{
		UILabel *fourLb = (UILabel *)[cell.contentView viewWithTag:203];
		fourLb.text = @"货源充足";
	}
	
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 110.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	Catalog *catalog = [self.onsaleCatalogArray objectAtIndex:section];
	
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 30)] autorelease];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5, 300.0f, 20.0f)];
	label.text = catalog.Name;
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	[headerView addSubview:label];
	[label release];
	headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x30.png"]];
	return headerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(buyDetailVC == nil)
	{
		buyDetailVC = [[OnsaleDetailViewController alloc] init];
	}
	Catalog *catalog = [self.onsaleCatalogArray objectAtIndex:indexPath.section];
	Item *item = [catalog.itemArray objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:buyDetailVC animated:YES];
	[buyDetailVC detailInfo:item.ID catID:catalog.ID];
}

#pragma mark -
#pragma mark 列表与九宫格切换

-(void) doChangeMode
{
	[UIView beginAnimations:@"ChangeMode" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    
    UIButton *rightButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
	if(listMode)
	{
		[rightButton setBackgroundImage:[UIImage imageNamed:@"List.png"] forState:UIControlStateNormal];
        [UIView beginAnimations:@"ChangeModeButton" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];

        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:rightButton cache:YES];
        [UIView commitAnimations];
		if (nil == imageScrollView)
		{
			imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
			imageScrollView.backgroundColor = [UIColor clearColor];
			imageScrollView.scrollEnabled = YES;
		}
		for(UIView *aView in [imageScrollView subviews])
		{
			[aView removeFromSuperview];
		}
		
		int count = 0;		
		CGFloat x = 5.0;
		CGFloat y = 5.0;
		CGFloat width = 100.0;
		CGFloat height = 133.0;
		for(Catalog *catalog in self.onsaleCatalogArray)
		{
			count += [catalog.itemArray count];
			for(Item *item in catalog.itemArray)
			{
				CustomImageView *customImgV = [[CustomImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
				[ImageCacheManager setImg:customImgV withUrlString:item.img];
				customImgV.productNO = item.ID;
				customImgV.catalogNO = catalog.ID;
				customImgV.Name = item.Name;
				customImgV.delegate = self;
				x += (width +5);
				if( x > 300)
				{
					x = 5.0;
					y += (height + 5.0);
				}
				
				
				[imageScrollView addSubview:customImgV];
				[customImgV release];
			}
		}
		NSLog(@"count = %d",count);
		
		int colume = 3;
		int row = (count % colume == 0) ? (count / colume) : (count / colume + 1);
		imageScrollView.contentSize = CGSizeMake(320, 10 + 138 * row);
		
		[self.view addSubview:imageScrollView];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        [onSaleTableview removeFromSuperview];
		
		listMode = FALSE;
	}
	else
	{
        [UIView beginAnimations:@"ChangeModeButton_s" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"Square.png"] forState:UIControlStateNormal];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:rightButton cache:YES];
        [UIView commitAnimations];
        
		[self.view addSubview:onSaleTableview];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
		[imageScrollView removeFromSuperview];
		
		listMode = TRUE;
	}
    [UIView commitAnimations];
}


-(void) onsaleList:(NSString *)theID name:(NSString *)theName
{
	[MobClick event:[NSString stringWithFormat:@"OnSaleList"] label:theName];

	self.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	self.title = theName;
	NSMutableArray * nArray = [[NSMutableArray alloc]init];
    self.onsaleCatalogArray = nArray;
    [nArray release];
	OnlyAccount *account = [OnlyAccount defaultAccount];
	
	NSString *parameters = [NSString stringWithFormat:@"%@|%@",theID,account.account];
	NSString *encodedString = [URLEncode encodeUrlStr:parameters];
	NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
	NSString *onsaleListStr = [NSString stringWithFormat:@"%@=OnSaleList&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
	NSLog(@"商品列表:%@",onsaleListStr);
	
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
	NSURL *onSaleListUrl = [[NSURL alloc] initWithString:onsaleListStr];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:onSaleListUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:loadingView];
	onSaleListConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
	[onSaleListUrl release];
}

-(void) showNine
{
	if(imageScrollView)
	{
		for(UIView *aView in [imageScrollView subviews])
		{
			[aView removeFromSuperview];
		}
		
		int count = 0;		
		CGFloat x = 5.0;
		CGFloat y = 5.0;
		CGFloat width = 100.0;
		CGFloat height = 133.0;
		for(Catalog *catalog in self.onsaleCatalogArray)
		{
			count += [catalog.itemArray count];
			for(Item *item in catalog.itemArray)
			{
				CustomImageView *customImgV = [[CustomImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
				[ImageCacheManager setImg:customImgV withUrlString:item.img];
				customImgV.productNO = item.ID;
				customImgV.catalogNO = catalog.ID;
				customImgV.Name = item.Name;
				customImgV.delegate = self;
				x += (width +5);
				if( x > 300)
				{
					x = 5.0;
					y += (height + 5.0);
				}
				UIImageView *stateImgV = [[UIImageView alloc] initWithFrame:CGRectMake(67.0f, 0.0f, 33.0f, 25.0f)];
				int type = [item.Type intValue];
				switch (type)
				{
					case 1:
					{
						stateImgV.image = [UIImage imageNamed:@"TuiJian.png"];
						break;
					}
					case 3:
					{
						stateImgV.image = [UIImage imageNamed:@"New.png"];
						break;
					}
					case 4:
					{
						stateImgV.image = [UIImage imageNamed:@"ShQ.png"];
						break;
					}
					default:
					{
						stateImgV.image = nil;
						break;
					}
				}
				[customImgV addSubview:stateImgV];
				[stateImgV release];				
				
				[imageScrollView addSubview:customImgV];
				[customImgV release];
			}
		}
		NSLog(@"count = %d",count);
		
		int colume = 3;
		int row = (count % colume == 0) ? (count / colume) : (count / colume + 1);
		imageScrollView.contentSize = CGSizeMake(320, 10 + 138 * row);
	}
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

-(void) customImageViewPressed:(CustomImageView *)customImgV
{
	NSLog(@"proID = %@  catID = %@",customImgV.productNO,customImgV.catalogNO);
	if(buyDetailVC == nil)
	{
		buyDetailVC = [[OnsaleDetailViewController alloc] init];
	}
	[self.navigationController pushViewController:buyDetailVC animated:YES];
	[buyDetailVC detailInfo:customImgV.productNO catID:customImgV.catalogNO];
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
    //NSLog(@"self.receivedData  Length = %d",[self.receivedData length]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
	NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	NSError *error = nil;
	GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
	
	if(error)
	{
		[document release];
		[onSaleListConnection release];
		return;
	}
	
	GDataXMLElement *root = [document rootElement];
	NSArray *catalogList = [root elementsForName:@"catalog"];
	for(GDataXMLElement *catalogElement in catalogList)
	{
		Catalog *catalog = [[Catalog alloc] init];
		GDataXMLElement *ID = [[catalogElement elementsForName:@"id"] objectAtIndex:0];
		catalog.ID = [ID stringValue];		
		GDataXMLElement *name = [[catalogElement elementsForName:@"name"] objectAtIndex:0];
		catalog.Name = [name stringValue];
		
		NSArray *items = [catalogElement elementsForName:@"item"];
        //catalog.itemArray = [[NSMutableArray alloc] init];
        NSMutableArray * itemArray_self = [[NSMutableArray alloc] init];
        catalog.itemArray = itemArray_self;
        [itemArray_self release];
		for(GDataXMLElement *itemElement in items)
		{
			Item *item = [[Item alloc] init];
			GDataXMLElement *ID = [[itemElement elementsForName:@"id"] objectAtIndex:0];
			item.ID = [ID stringValue];
			GDataXMLElement *name = [[itemElement elementsForName:@"name"] objectAtIndex:0];
			item.Name = [name stringValue];
			GDataXMLElement *rackrate = [[itemElement elementsForName:@"rackrate"] objectAtIndex:0];
			item.rackrate = [rackrate stringValue];
			GDataXMLElement *level = [[itemElement elementsForName:@"level"] objectAtIndex:0];
			item.Level = [level stringValue];
			GDataXMLElement *limitedprice = [[itemElement elementsForName:@"limitedprice"] objectAtIndex:0];
			item.limitedprice = [limitedprice stringValue];
			GDataXMLElement *img = [[itemElement elementsForName:@"img"] objectAtIndex:0];
			item.img = [img stringValue];
			GDataXMLElement *type = [[itemElement elementsForName:@"type"] objectAtIndex:0];
			item.Type = [type stringValue];
			GDataXMLElement *count = [[itemElement elementsForName:@"count"] objectAtIndex:0];
			item.Count = [count stringValue];
			[catalog.itemArray addObject:item];
			[item release];
		}
		NSLog(@"catalog.itemArray count = %d",[catalog.itemArray count]);
		[self.onsaleCatalogArray addObject:catalog];
		[catalog release];
	}
	
	[onSaleTableview reloadData];
	[document release];
	[onSaleListConnection release];
	self.receivedData = nil;
	[self showNine];
	
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];	
	[onSaleListConnection release];
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
	[onsaleCatalogArray release];
	[onSaleTableview release];
	[imageScrollView release];
	if(buyDetailVC)
	{
		[buyDetailVC release];
	}
    [super dealloc];
}


@end
