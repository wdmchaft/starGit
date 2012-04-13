//
//  OnsaleView.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 正在出售 视图
 
 对应界面 限时抢购－正在出售
 */

#import <UIKit/UIKit.h>
@class OnSale;

@protocol OnsaleDelegate	//代理方法  进入售卖 告诉朋友

-(void) doEnterSold:(OnSale *)onsale;
-(void) doTellFriendOnsale:(OnSale *)onsale;

@end


@interface OnsaleView0 : UITableView <UITableViewDelegate,UITableViewDataSource>
{
	id<OnsaleDelegate> onsaleDelegate;			//代理方法
	NSMutableArray *onSaleArray;				//UITableView的数据源
}

@property(nonatomic,assign) id<OnsaleDelegate> onsaleDelegate;
@property(nonatomic,retain) NSMutableArray *onSaleArray;


@end
