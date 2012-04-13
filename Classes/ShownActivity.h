//
//  ShownActivity.h
//  ShangPin
//
//  Created by 唐彬琪 on 11-8-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
/*
 首页图片展示活动
 
*/ 



#import <Foundation/Foundation.h>


@interface ShownActivity : NSObject {
    NSString * activityID;
    NSString * activityNO;
    NSString * time;
    NSString * pic;
 }
@property(nonatomic, copy)NSString * activityID;
@property(nonatomic, copy)NSString * activityNO;
@property(nonatomic, copy)NSString * time;
@property(nonatomic, copy)NSString * pic;

@end
