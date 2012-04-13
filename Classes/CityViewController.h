//
//  CityViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-3-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 城市视图控制器
 用于显示某省份下全部的城市
 */

#import <UIKit/UIKit.h>
@class NameValue;
@class ProvinceViewController;

@interface CityViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
	ProvinceViewController *pVC;		//全部省份
	NameValue *province;				//选中的省份
	UITableView *cityTableView;			//城市列表
	NSMutableArray *cityArray;			//存放某省份下全部城市的数组
}

@property(nonatomic,retain) ProvinceViewController *pVC;
@property(nonatomic,retain) NSMutableArray *cityArray;
@property(nonatomic,retain) NameValue *province;



//根据指定的省份获得该省全部的城市
-(void) loadCityFromProvinceId:(NameValue *) theProvince;


@end
