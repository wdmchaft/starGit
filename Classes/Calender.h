//
//  Calender.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 日历里面每天包含的属性
 */

#import <Foundation/Foundation.h>


@interface Calender : NSObject 
{
	NSString *date;			//日期
	NSString *hot;			//是否是商品一小时
}

@property(nonatomic,copy) NSString *date;
@property(nonatomic,copy) NSString *hot;

@end


//@interface Calender : NSObject 
//{
//	NSString *ID;				//活动的id
//	NSString *BrandName;        //品牌名称
//    NSString *Name;				//活动的名称
//    NSString *Time;             //活动时间
//	NSString *img;				//活动图片
//    
//}
//
//@property(nonatomic,copy) NSString *ID;
//@property(nonatomic,copy) NSString *BrandName;
//@property(nonatomic,copy) NSString *Name;
//@property(nonatomic,copy) NSString *Time;
//@property(nonatomic,copy) NSString *img;
//
//@end
