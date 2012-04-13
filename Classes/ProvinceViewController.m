    //
//  ProvinceViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-3-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProvinceViewController.h"
#import "NameValue.h"
#import "CityViewController.h"

@implementation ProvinceViewController
@synthesize provinceArray;
@synthesize ciVC;
@synthesize aVC;

#pragma mark -
#pragma mark 省份视图控制器 初始化

- (void)loadView 
{
	self.title = @"省份";
	
	self.provinceArray = [NameValue finaAllProvince];
	
	provinceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped];
	provinceTableView.backgroundColor = [UIColor blackColor];
	provinceTableView.delegate = self;
	provinceTableView.dataSource = self;
	self.view = provinceTableView;
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDatasource

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [self.provinceArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = indexPath.row;
	NameValue *provinceNameValue = [self.provinceArray objectAtIndex:row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if(cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x40.png"]];
	}
	cell.textLabel.text = provinceNameValue.name;
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
	int row = indexPath.row;
	NameValue *provinceNameValue = [self.provinceArray objectAtIndex:row];
	CityViewController *cityVC = [[CityViewController alloc] init];
	cityVC.pVC = self;
	cityVC.cityArray = [NameValue finaAllCityFromProvinceValue:provinceNameValue.value];
	[self.navigationController pushViewController:cityVC animated:YES];
	[cityVC loadCityFromProvinceId:provinceNameValue];
	[cityVC release];
}

#pragma mark -
#pragma mark 省份视图控制器 释放相关

- (void)dealloc 
{
	self.aVC = nil;
	self.ciVC = nil;
	[provinceTableView release];
	self.provinceArray = nil;
    [super dealloc];
}


@end
