    //
//  AddressListViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-3-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddressListViewController.h"
#import "Address.h"
#import "AddressViewController.h"
#import "Receiver.h"
#import "ConsigneeInfoViewController.h"

@implementation AddressListViewController
@synthesize addressArray;
@synthesize CIVC;

#pragma mark -
#pragma mark 返回 我的账户界面
- (void)returnBack
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 初始化 收货地址列表

- (void)loadView 
{
	self.title = @"收货地址列表";
//	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	backButton.frame = CGRectMake(0, 0, 53, 29);
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
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
	
    UIBarButtonItem *saveBI = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStyleBordered target:self action:@selector(doAdd)];
	
    self.navigationItem.rightBarButtonItem = saveBI;
	[saveBI release];
	UIView *addressListView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	addressListView.backgroundColor = [UIColor blackColor];
	
	m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped];
	m_tableView.backgroundColor = [UIColor blackColor];
	m_tableView.delegate = self;
	m_tableView.dataSource = self;
	[addressListView addSubview:m_tableView];    
	self.view = addressListView;
	[addressListView release];
    
 }

#pragma mark -
#pragma mark 刷新列表  添加新收货地址
-(void) showList
{
	[m_tableView reloadData];
}

-(void) doAdd
{
	AddressViewController *addressVC = [AddressViewController defaultAVC];
	[self.navigationController pushViewController:addressVC animated:YES];
	[addressVC showBlank];
    [addressVC changePrompt];
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDatasource

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [self.addressArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Address *address = [self.addressArray objectAtIndex:indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if(cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
		cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x60.png"]];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	cell.textLabel.text = address.Name;
	cell.textLabel.textColor = WORDCOLOR;
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.detailTextLabel.text = address.address;
	cell.detailTextLabel.textColor = WORDCOLOR;
	cell.detailTextLabel.backgroundColor = [UIColor clearColor];
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(CIVC)
	{
		Receiver *address = [self.addressArray objectAtIndex:indexPath.row];
		[CIVC changeToChoosedReceiver:address];
		[self.navigationController popViewControllerAnimated:YES];
	}
	else
	{
		Address *address = [self.addressArray objectAtIndex:indexPath.row];
		//AddressViewController *addressVC = [AddressViewController defaultAVC];
		AddressViewController *addressVC = [[AddressViewController alloc] init];
		[self.navigationController pushViewController:addressVC animated:YES];
		[addressVC showDetailAddress:address];
		[addressVC release];
	}
}

#pragma mark -
#pragma mark 收货地址列表 释放相关
- (void)dealloc 
{
	[m_tableView release];
	self.addressArray = nil;
    [super dealloc];
}


@end
