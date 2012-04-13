//
//  Goods.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 商品(订单中包含的商品) 数据模型
 
 每件商品包含5个部分
 1、商品id
 2、商品名称
 3、商品专柜价
 4、商品限时价
 5、商品图片
 */

#import <Foundation/Foundation.h>


@interface Goods : NSObject 
{
	NSString *ID;				//商品id
	NSString *Name;				//商品名称
	NSString *rackrate;			//商品专柜价
	NSString *limitedprice;		//商品限时价
	NSString *img;				//商品图片
}

@property(nonatomic, copy) NSString *ID;
@property(nonatomic, copy) NSString *Name;
@property(nonatomic, copy) NSString *rackrate;
@property(nonatomic, copy) NSString *limitedprice;
@property(nonatomic, copy) NSString *img;

@end
