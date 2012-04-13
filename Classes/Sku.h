//
//  Sku.h
//  ShangPin
//
//  Created by apple_cyy on 11-3-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 单品属性
 */

#import <Foundation/Foundation.h>


@interface Sku : NSObject 
{
	NSString *skuNo;			//单品编号
	NSString *color;			//属性1
	NSString *size;				//属性2
	NSString *quantity;			//库存
	NSString *level;			//会员等级
	NSString *limitedprice;		//限时价
	NSString *image;			//图片小图
	NSString *bigimg;			//图片大图
}

@property(nonatomic,copy) NSString *skuNo;
@property(nonatomic,copy) NSString *color;
@property(nonatomic,copy) NSString *size;
@property(nonatomic,copy) NSString *quantity;
@property(nonatomic,copy) NSString *level;
@property(nonatomic,copy) NSString *limitedprice;
@property(nonatomic,copy) NSString *image;
@property(nonatomic,copy) NSString *bigimg;

@end
