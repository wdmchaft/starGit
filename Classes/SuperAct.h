//
//  SuperAct.h
//  ShangPin
//
//  Created by 唐彬琪 on 11-8-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
/*
 尚品资讯里面滑动图片对应的活动,仅限已开始的当日活动
 包含3个部分:
 1.活动大图;
 2.活动名称;
 3.活动ID;
*/ 

#import <Foundation/Foundation.h>


@interface SuperAct : NSObject {
    NSString * Name;
    NSString * ID;
    NSString * bigImage;
    
}
@property(nonatomic, copy)NSString * Name;
@property(nonatomic, copy)NSString * ID;
@property(nonatomic, copy)NSString * bigImage;

@end
