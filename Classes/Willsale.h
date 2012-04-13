//
//  Willsale.h
//  ShangPin
//
//  Created by apple_cyy on 11-2-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 即将出售 每个活动包含的属性
 */

#import <Foundation/Foundation.h>


//@interface Willsale : NSObject 
//{
//	NSString *ID;		//活动id
//	NSString *Name;		//活动名称
//	NSString *img;		//活动图片
//}
//
//@property(nonatomic,copy) NSString *ID;
//@property(nonatomic,copy) NSString *Name;
//@property(nonatomic,copy) NSString *img;
//
//@end


@interface Willsale : NSObject 
{
	NSString *ID;				//活动的id
    NSString *Name;				//活动的名称
    NSString *img;				//活动图片
	NSString *title;            //品牌名称
    NSString *text;             
    NSString *date;             //活动时间
	
    
}

@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *Name;
@property(nonatomic,copy) NSString *date;
@property(nonatomic,copy) NSString *img;
@property(nonatomic,copy) NSString *text;


@end
