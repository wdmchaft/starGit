//
//  AreaViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-3-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 地区视图控制器
 用于显示指定省份指定城市下全部的地区
 */

#import <UIKit/UIKit.h>
@class NameValue;
@class CityViewController;

@interface AreaViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
	CityViewController *cVC;		//指定省份下的全部城市
	NameValue *province;			//指定的省份
	NameValue *city;				//指定省份下指定的城市
	UITableView *areaTableView;		//地区列表
	NSMutableArray *areaArray;		//指定省份指定城市下全部的地区 存放于本书组中
}

@property(nonatomic,retain) CityViewController *cVC;
@property(nonatomic,retain) NSMutableArray *areaArray;
@property(nonatomic,retain) NameValue *province;
@property(nonatomic,retain) NameValue *city;

//根据指定的省份和城市 获得全部地区
-(void) loadAreaFromProvinceId:(NameValue *) theProvince andCityId:(NameValue *) theCity;

@end
