//
//  Item2.h
//  ShangPin
//
//  Created by cyy on 11-3-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 同类产品
 */

#import <Foundation/Foundation.h>


@interface Item2 : NSObject
{
	NSString *productNo;			//商品编号
	NSString *catNo;				//商品种类编号
	NSString *img;					//商品图片
}

@property(nonatomic,copy) NSString *productNo;
@property(nonatomic,copy) NSString *catNo;
@property(nonatomic,copy) NSString *img;

@end
