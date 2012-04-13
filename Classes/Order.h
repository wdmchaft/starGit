//
//  Order.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 订单 数据模型
 
 订单包括3部分信息
 1、订单号
 2、订单状态
 3、订单中包含的商品，此处用一个可变数组存放各种goods
 */

#import <Foundation/Foundation.h>


@interface Order : NSObject 
{
	NSString *orderid;				//订单号
	NSString *orderstate;			//订单状态
	NSMutableArray *goodsArray;		//订单中包含的商品（各种goods）
}

@property(nonatomic, copy) NSString *orderid;
@property(nonatomic, copy) NSString *orderstate;
@property(nonatomic, retain) NSMutableArray *goodsArray;

@end
