//
//  OnsaleView0.m
//  ShangPin
//
//  Created by 唐彬琪 on 11-8-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "OnsaleView.h"
#import "CustomTableViewCell.h"
#import "OnSale.h"

@implementation OnsaleView
@synthesize onSaleArray;
@synthesize onsaleDelegate;

#pragma mark -
#pragma mark 初始化 正在出售 视图
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) 
	{
		self.onSaleArray = [[[NSMutableArray alloc] init] autorelease];
        self.backgroundColor = [UIColor blackColor];
		self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark -
#pragma mark 进入售卖   告诉朋友 
-(void) enterSold:(UIButton *)tap
{
	int row = tap.tag;
	OnSale *onsale = [self.onSaleArray objectAtIndex:row];
	[onsaleDelegate doEnterSold:onsale];
}

-(void) tellFriend:(UIButton *)tap
{
	int row = tap.tag;
	OnSale *onsale = [self.onSaleArray objectAtIndex:row];
	[onsaleDelegate doTellFriendOnsale:onsale];
}


#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.onSaleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"indexCell";	
	CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil)
	{
		cell = [[[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.invButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cell.invButton.frame = CGRectMake(275, 30, 30, 30);
        cell.invButton.showsTouchWhenHighlighted = YES;
        cell.invButton.tag = indexPath.row;
        
        UIImageView * invButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tellFriends.png"]];
        invButtonView.frame = CGRectMake(5, 5, 26, 23);
        [cell.invButton addSubview:invButtonView];
        [invButtonView release];
        [cell.contentView addSubview:cell.invButton];

	}
	OnSale *onsale = [self.onSaleArray objectAtIndex:indexPath.row];
	//cell.m_imageView.image = nil; 
	cell.act_imageView.image = [UIImage imageNamed:@"shang.png"];
    [ImageCacheManager setImg:cell.act_imageView  withUrlString:onsale.img];
    
    cell.brandName.text = onsale.title;
    cell.activityName.text = onsale.Name;
    cell.activityTime.text = onsale.date;
	[cell.invButton addTarget:self action:@selector(tellFriend:) forControlEvents:UIControlEventTouchUpInside];
    
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	OnSale *onsale = [self.onSaleArray objectAtIndex:indexPath.row];
	[onsaleDelegate doEnterSold:onsale];
}


#pragma mark -
#pragma mark 释放相关
- (void)dealloc 
{
	[onSaleArray release];
    [super dealloc];
}


@end
