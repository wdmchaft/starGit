//
//  MyOrderView.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyOrderView.h"
#import "GDataXMLNode.h"
#import "Order.h"
#import "Goods.h"
#import "CustomLabel.h"

@implementation MyOrderView

@synthesize orderArray;
@synthesize orderDelegate;
@synthesize receivedData;

#pragma mark -
#pragma mark 我的订单 初始化方法

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) 
	{
        NSMutableArray * pArray = [[NSMutableArray alloc]init];
        self.orderArray = pArray;
        [pArray release];
        self.backgroundColor = [UIColor blackColor];
		self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}

#pragma mark -
#pragma mark 加载订单列表
-(void) loadMyOrder
{
    if(myOrderListConnection == nil)
    {
        NSMutableArray * pArray = [[NSMutableArray alloc]init];
        self.orderArray = pArray;
        [pArray release];
        OnlyAccount *account = [OnlyAccount defaultAccount];
        NSString *parameters = [NSString stringWithFormat:@"%@|%@|%@",account.account,@"1",@"100"];
        NSString *encodedString = [URLEncode encodeUrlStr:parameters];
        NSString *md5Str = [MD5 md5Digest:[NSString stringWithFormat:@"%@%@",parameters,KEY]];
        
        [MobClick event:@"MyOrderList"];
        
        
        NSString *myOrderList = [NSString stringWithFormat:@"%@=MyOrderList&parameters=%@&md5=%@&u=%@&w=%@",ADDRESS,encodedString,md5Str,account.account,account.password];
        NSLog(@"我的账户-订单列表:%@",myOrderList);
        NSURL *myOrderListUrl = [[NSURL alloc] initWithString:myOrderList];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:myOrderListUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        //loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, self.contentOffset.y, 320, 246)];
        loadingView = [[LoadingView alloc] initWithFrame:self.frame];
        [self.superview addSubview:loadingView];
        self.scrollEnabled = NO;
        myOrderListConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [request release];
        [myOrderListUrl release];
    }
}


#pragma mark -
#pragma mark UITableViewDelegate UITableViewDatasource

-(float)contentWidth: (NSString *)string
{
	CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(260, 500) lineBreakMode:UILineBreakModeCharacterWrap];
	float width = size.width;
	return width;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.orderArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.orderArray count] != 0)
    {
        Order *order = [self.orderArray objectAtIndex:section];
        return [order.goodsArray count];
    }
	return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"identifier";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if(cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
		cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x110.png"]];
		//箭头
		UIImageView *accImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Accessary.png"]];
		cell.accessoryView = accImg;
		[accImg release];
		
		//商品图片
		UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 66, 88)];
		imgV.backgroundColor = [UIColor grayColor];
		imgV.tag = 300;
		[cell.contentView addSubview:imgV];
		[imgV release];
		//商品名称
		CustomLabel *titleLabel = [[CustomLabel alloc] initWithFrame:CGRectMake(86, 8, 200, 32)];
		titleLabel.font = [UIFont systemFontOfSize:14];
		titleLabel.numberOfLines = 0;
		titleLabel.verticalAlignment = VerticalAlignmentTop;
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.textColor = WORDCOLOR;
		titleLabel.tag = 301;
		[cell.contentView addSubview:titleLabel];
		[titleLabel release];
		//专柜价
		UILabel *originPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 45, 232, 20)];
		originPriceLabel.backgroundColor = [UIColor clearColor];
		originPriceLabel.font = [UIFont systemFontOfSize:14];
		originPriceLabel.textColor = [UIColor whiteColor];
		originPriceLabel.tag = 302;
		[cell.contentView addSubview:originPriceLabel];
		[originPriceLabel release];
		//横线
		UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(84, 55, 117, 1)];
		line.tag = 299;
		line.backgroundColor = [UIColor lightGrayColor];
		[cell.contentView addSubview:line];
		[line release];
		//限时价
		UILabel *nowPrice = [[UILabel alloc] initWithFrame:CGRectMake(86, 65, 232, 20)];
		nowPrice.backgroundColor = [UIColor clearColor];
		nowPrice.font = [UIFont systemFontOfSize:14];
		nowPrice.textColor = [UIColor whiteColor];
		nowPrice.tag = 303;
		[cell.contentView addSubview:nowPrice];
		[nowPrice release];
	}
	
    if([self.orderArray count] != 0)
    {
        Order *order = [self.orderArray objectAtIndex:indexPath.section];
        Goods *goods = [order.goodsArray objectAtIndex:indexPath.row];
        
        UIImageView *leftView = (UIImageView *)[cell.contentView viewWithTag:300];
        [ImageCacheManager setImg:leftView  withUrlString:goods.img];
        
        CustomLabel *titleLabel = (CustomLabel *)[cell.contentView viewWithTag:301];
        titleLabel.text = goods.Name;
        
        UILabel *originPriceLabel = (UILabel *)[cell.contentView viewWithTag:302];
        originPriceLabel.text = [NSString stringWithFormat:@"专柜价:¥%@ ",goods.rackrate];
        
        float width = [self contentWidth:originPriceLabel.text];
        UILabel *line = (UILabel *)[cell.contentView viewWithTag:299];
        line.frame = CGRectMake(84, 55, width, 1);
        
        UILabel *nowPrice = (UILabel *)[cell.contentView viewWithTag:303];
        nowPrice.text = [NSString stringWithFormat:@"¥%@",goods.limitedprice];
    }
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{	
    if([self.orderArray count] != 0)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x30.png"]];
        
        Order *order = [self.orderArray objectAtIndex:section];
        //订单编号
        UILabel *orderNO = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 220, 20)];
        orderNO.backgroundColor = [UIColor clearColor];
        orderNO.textColor = [UIColor lightGrayColor];
        orderNO.font = [UIFont systemFontOfSize:14];
        orderNO.text = [NSString stringWithFormat:@"订单编号:%@",order.orderid];
        [headerView addSubview:orderNO];
        [orderNO release];
        //订单状态
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 5, 85, 20)];
        stateLabel.backgroundColor = [UIColor clearColor];
        stateLabel.textAlignment = UITextAlignmentRight;
        stateLabel.textColor = [UIColor lightGrayColor];
        stateLabel.font = [UIFont systemFontOfSize:14];
        stateLabel.text = order.orderstate;
        [headerView addSubview:stateLabel];
        [stateLabel release];
        
        return [headerView autorelease];
    }
	return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"KKKKKKKKKKKKKKKKKKKKKKKKKKK");
    Order *order = [self.orderArray objectAtIndex:indexPath.section];
	[orderDelegate showDetailOrder:order.orderid];

}

#pragma mark -
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"订单列表 获得服务器 回应");
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
    [myOrderListConnection release];
    myOrderListConnection = nil;
    [self.superview bringSubviewToFront:self];
	NSError *error = nil;
	GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:self.receivedData options:0 error:&error];
	
	if(error)
	{
		[document release];
		return;
	}
	GDataXMLElement *root = [document rootElement];
	NSArray *array = [root elementsForName:@"order"];
	for(GDataXMLElement *order in array)
	{
		Order *theOrder = [[Order alloc] init];
		GDataXMLElement *orderid = [[order elementsForName:@"orderid"] objectAtIndex:0];
		theOrder.orderid = [orderid stringValue];		//订单编号
		GDataXMLElement *orderstate = [[order elementsForName:@"orderstate"] objectAtIndex:0];
		theOrder.orderstate = [orderstate stringValue];//订单状态
		NSArray *goodsArray = [order elementsForName:@"goods"];
        NSMutableArray * goodArray_self = [[NSMutableArray alloc] init];
        theOrder.goodsArray = goodArray_self;
        [goodArray_self release];

		for(GDataXMLElement *goods in goodsArray)
		{
			Goods *theGoods = [[Goods alloc] init];
			GDataXMLElement *ID = [[goods elementsForName:@"id"] objectAtIndex:0];
			theGoods.ID = [ID stringValue];		//商品编号
			NSLog(@"ID = %@",theGoods.ID);
			GDataXMLElement *name = [[goods elementsForName:@"name"] objectAtIndex:0];
			theGoods.Name = [name stringValue];	//商品名称
			GDataXMLElement *rackrate = [[goods elementsForName:@"rackrate"] objectAtIndex:0];
			theGoods.rackrate = [rackrate stringValue];	//专柜价
			GDataXMLElement *limitedprice = [[goods elementsForName:@"limitedprice"] objectAtIndex:0];
			theGoods.limitedprice = [limitedprice stringValue];	//限时价
			GDataXMLElement *img = [[goods elementsForName:@"img"] objectAtIndex:0];
			theGoods.img = [img stringValue];	//商品图片
			[theOrder.goodsArray addObject:theGoods];
			[theGoods release];
		}
		[self.orderArray addObject:theOrder];
		[theOrder release];
	}
	if([self.orderArray count] != 0)
    {
        [self reloadData];
    }
	self.scrollEnabled = YES;
	[document release];
	self.receivedData = nil;
	//[orderDelegate didOrderViewFinishLaunching];
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	//[orderDelegate didOrderViewFinishLaunching];
	[myOrderListConnection release];
	self.receivedData = nil;
	[loadingView finishLoading];
	[loadingView removeFromSuperview];
	[loadingView release];
	self.scrollEnabled = YES;
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}


- (void)dealloc 
{
	[orderArray release];
	self.receivedData = nil;
    [super dealloc];
}


@end
