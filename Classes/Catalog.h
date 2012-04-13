//
//  Catalog.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 每个分类包含的属性
 */

#import <Foundation/Foundation.h>


@interface Catalog : NSObject 
{
	NSString *ID;					//分类id
	NSString *Name;					//分类的名称 例如:皮包
	NSMutableArray *itemArray;		//该分类下全部的商品
}

@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *Name;
@property(nonatomic,retain) NSMutableArray *itemArray;

@end
