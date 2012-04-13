    //
//  AreaViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-3-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AreaViewController.h"
#import "NameValue.h"
#import "AddressViewController.h"
#import "ProvinceViewController.h"
#import "CityViewController.h"
#import "ConsigneeInfoViewController.h"
#import "AddressViewController.h"

@implementation AreaViewController
@synthesize areaArray;
@synthesize province;
@synthesize city;
@synthesize cVC;

#pragma mark -
#pragma mark 地区视图控制器 初始化
- (void)loadView
{
	self.title = @"地区";
	
	areaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped];
	areaTableView.backgroundColor = [UIColor blackColor];
	areaTableView.delegate = self;
	areaTableView.dataSource = self;
	self.view = areaTableView;
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDatasource

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [self.areaArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = indexPath.row;
	NameValue *areaNameValue = [self.areaArray objectAtIndex:row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if(cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
		cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x40.png"]];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	cell.textLabel.text = areaNameValue.name;
	cell.textLabel.textColor = WORDCOLOR;
	cell.textLabel.backgroundColor = [UIColor clearColor];
	
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NameValue *areaNameValue = [self.areaArray objectAtIndex:indexPath.row];
	NSString *test = [NSString stringWithFormat:@"%d-%d-%d",province.value,city.value,areaNameValue.value];
	
	if(self.cVC.pVC.ciVC)
	{
		NSArray *array = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",province.value],[NSString stringWithFormat:@"%d",city.value],[NSString stringWithFormat:@"%d",areaNameValue.value],[NameValue findAddressWithValue:test],nil];
		[self.cVC.pVC.ciVC.delegate didFinishChooseAddressWithArray:array];
		[array release];
		[self.navigationController popToViewController:self.cVC.pVC.ciVC animated:YES];
	}
	
	if(self.cVC.pVC.aVC)
	{
		NSArray *array = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",province.value],[NSString stringWithFormat:@"%d",city.value],[NSString stringWithFormat:@"%d",areaNameValue.value],[NameValue findAddressWithValue:test],nil];
		[self.cVC.pVC.aVC.delegate didFinishChooseAddressArray:array];
		[array release];
		[self.navigationController popToViewController:self.cVC.pVC.aVC animated:YES];
	}
}

-(void) loadAreaFromProvinceId:(NameValue *) theProvince andCityId:(NameValue *) theCity
{
	self.province = theProvince;
	self.city = theCity;
	[areaTableView reloadData];
}

#pragma mark -
#pragma mark 地区视图控制器 释放相关

- (void)dealloc
{
	self.province = nil;
	self.city = nil;
	self.areaArray = nil;
	self.cVC = nil;
	[areaTableView release];
    [super dealloc];
}


@end
