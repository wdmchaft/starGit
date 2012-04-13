//
//  Address.h
//  ShangPin
//
//  Created by apple_cyy on 11-3-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 收货地址 数据模型
 
 每个地址都包含9部分内容
 1、收货人姓名
 2、省份(名称以及编号)
 3、市(名称以及编号)
 4、县(名称以及编号)
 5、详细地址
 6、邮政编码
 7、电话号码
 8、手机号码
 9、收货地址编号
 */

#import <Foundation/Foundation.h>


@interface Address : NSObject 
{
	NSString *Name;
	NSString *city;
	NSString *address;
	NSString *postcode;
	NSString *phone;
	NSString *mobile;
	NSString *consigneeid;
}

@property(nonatomic,copy) NSString *Name;
@property(nonatomic,copy) NSString *city;
@property(nonatomic,copy) NSString *address;
@property(nonatomic,copy) NSString *postcode;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *mobile;
@property(nonatomic,copy) NSString *consigneeid;

@end
