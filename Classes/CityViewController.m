    //
//  CityViewController.m
//  ShangPin
//
//  Created by apple_cyy on 11-3-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CityViewController.h"
#import "NameValue.h"
#import "AreaViewController.h"

@implementation CityViewController
@synthesize cityArray;
@synthesize province;
@synthesize pVC;

#pragma mark -
#pragma mark 城市视图控制器 初始化

- (void)loadView 
{
	self.title = @"城市";
	
	cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped];
	cityTableView.backgroundColor = [UIColor blackColor];
	cityTableView.delegate = self;
	cityTableView.dataSource = self;
	self.view = cityTableView;
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDatasource

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [self.cityArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = indexPath.row;
	NameValue *cityNameValue = [self.cityArray objectAtIndex:row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if(cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"1x40.png"]];
	}
	cell.textLabel.text = cityNameValue.name;
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
	NameValue *cityNameValue = [self.cityArray objectAtIndex:indexPath.row];
	AreaViewController *area = [[AreaViewController alloc] init];
	area.cVC = self;
	area.areaArray = [NameValue finaAllAreaFromCityValue:cityNameValue.value];
	[self.navigationController pushViewController:area animated:YES];
	[area loadAreaFromProvinceId:province andCityId:cityNameValue];
	NSLog(@"%@-%d  %@-%d",province.name,province.value,cityNameValue.name,cityNameValue.value);
	[area release];
}

-(void) loadCityFromProvinceId:(NameValue *) theProvince
{
	self.province = theProvince;
	[cityTableView reloadData];
}

#pragma mark -
#pragma mark 城市视图控制器 释放相关

- (void)dealloc 
{
	[cityTableView release];
	self.province = nil;
	self.cityArray = nil;
	self.pVC = nil;
	
    [super dealloc];
}


@end
