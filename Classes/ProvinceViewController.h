//
//  ProvinceViewController.h
//  ShangPin
//
//  Created by apple_cyy on 11-3-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 省份视图控制器
 用于显示全部的省份
 */

#import <UIKit/UIKit.h>
@class ConsigneeInfoViewController;
@class AddressViewController;

@interface ProvinceViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
	AddressViewController *aVC;				//我的账户-收获地址
	ConsigneeInfoViewController *ciVC;		//购买-收获地址
	UITableView *provinceTableView;			//省份列表
	NSMutableArray *provinceArray;			//存放全部省份的数组
}

@property(nonatomic,retain) NSMutableArray *provinceArray;
@property(nonatomic,retain) ConsigneeInfoViewController *ciVC;
@property(nonatomic,retain) AddressViewController *aVC;

@end
