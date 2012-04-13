//
//  Item.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 具体商品的相关属性
 */

#import <Foundation/Foundation.h>


@interface Item : NSObject
{
	NSString *ID;				//商品id
	NSString *Name;				//商品名称
	NSString *rackrate;			//专柜价
	NSString *Level;			//会员等级
	NSString *limitedprice;		//限时价
	NSString *img;				//商品图片
	NSString *Type;				//商品类型 1-推荐  3-新品 4-售罄
	NSString *Count;			//产品剩余数量
}	

@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *Name;
@property(nonatomic,copy) NSString *rackrate;
@property(nonatomic,copy) NSString *Level;
@property(nonatomic,copy) NSString *limitedprice;
@property(nonatomic,copy) NSString *img;
@property(nonatomic,copy) NSString *Type;
@property(nonatomic,copy) NSString *Count;

@end
