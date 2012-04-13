//
//  Voucher.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 代金券 数据模型
 
 每个代金券包含3部分信息
 1、代金券面值
 2、代金券名字
 3、代金券使用期限
 */

#import <Foundation/Foundation.h>


@interface Voucher : NSObject 
{
	NSString *Type;			//代金券面值
	NSString *Name;			//代金券名字
	NSString *Date;			//代金券使用期限
	NSString *isvalid;		//代金券时候可用 
}

@property(nonatomic,copy) NSString *Type;
@property(nonatomic,copy) NSString *Name;
@property(nonatomic,copy) NSString *Date;
@property(nonatomic,copy) NSString *isvalid;


@end
