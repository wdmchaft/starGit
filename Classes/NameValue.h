//
//  NameValue.h
//  ShangPin
//
//  Created by apple_cyy on 11-3-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 省、市、县 元素模型
 每个元素包含2部分
 1、name 例如:北京
 2、value 例如:1
 */

#import <Foundation/Foundation.h>

@interface NameValue : NSObject 
{
	int value;
	NSString *name;
}


@property int value;
@property(nonatomic,copy) NSString *name;



+(NSMutableArray *) finaAllProvince;										//查询数据库中全部省份
+(NSMutableArray *) finaAllCityFromProvinceValue:(int) theProvinceValue;	//查询某省份下的全部城市
+(NSMutableArray *) finaAllAreaFromCityValue:(int) theCityValue;			//查询某城市下的全部地区

+(NSString *)findAddressWithValue:(NSString *)theValue; //根据value查看name 例如：传入1-1-1 得到：北京 北京市 海淀区
+(NSString *)findProvinceFromValue:(int) provinceValue;	//根据 省份value 获得 省份name
+(NSString *)findCityFromValue:(int) cityValue;			//根据 城市value 获得 城市name
+(NSString *)findAreaFromValue:(int) areaValue;			//根据 地区value 获得 地区name

+(int)findProvinceValueFromName:(NSString *)theName;	//根据 省份的name 获得 省份value
+(int)findCityValueFromName:(NSString *)theName;		//根据 城市的name 获得 城市value
+(int)findAreaValueFromName:(NSString *)theName;		//根据 地区的name 获得 地区value

@end
