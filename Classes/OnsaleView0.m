//
//  OnsaleView.m
//  ShangPin
//
//  Created by apple_cyy on 11-2-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OnsaleView0.h"
#import "CustomTableViewCell.h"
#import "OnSale.h"

@implementation OnsaleView0
@synthesize onSaleArray;
@synthesize onsaleDelegate;

#pragma mark -
#pragma mark 初始化 正在出售 视图
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) 
	{
		self.onSaleArray = [[NSMutableArray alloc] init];
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
	}
	OnSale *onsale = [self.onSaleArray objectAtIndex:indexPath.row];
	//cell.m_imageView.image = nil;
	
	[ImageCacheManager setImg:cell.m_imageView  withUrlString:onsale.img];
    
    cell.leftButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [cell.leftButton setTitle:@"进入售卖" forState:UIControlStateNormal];
    [cell.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cell.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[cell.leftButton setBackgroundImage:[UIImage imageNamed:@"AddAlertNormal.png"] forState:UIControlStateNormal];
	[cell.leftButton setBackgroundImage:[UIImage imageNamed:@"AddAlertClick.png"] forState:UIControlStateHighlighted];
	cell.leftButton.tag = indexPath.row;
	[cell.leftButton addTarget:self action:@selector(enterSold:) forControlEvents:UIControlEventTouchUpInside];
	
    cell.rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [cell.rightButton setTitle:@"告诉好友" forState:UIControlStateNormal];
    [cell.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cell.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[cell.rightButton setBackgroundImage:[UIImage imageNamed:@"AddAlertNormal.png"] forState:UIControlStateNormal];
	[cell.rightButton setBackgroundImage:[UIImage imageNamed:@"AddAlertClick.png"] forState:UIControlStateHighlighted];
	cell.rightButton.tag = indexPath.row;
	[cell.rightButton addTarget:self action:@selector(tellFriend:) forControlEvents:UIControlEventTouchUpInside];
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 95;
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
