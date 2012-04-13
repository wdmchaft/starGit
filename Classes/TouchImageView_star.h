//
//  TouchImageView_star.h
//  ShangPin
//
//  Created by binqi tang on 11-11-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
/*
 自定义的UIImageView
 添加了点击事件，应用启动时候的开场动画用到了该该类，点击动画可触发delegate的方法；
*/ 


#import <UIKit/UIKit.h>


@protocol TouchImageView_starDealegate

-(void)TouchStopAnimation;

@end

@interface TouchImageView_star : UIImageView
{
    id<TouchImageView_starDealegate>delegate;
}

@property(nonatomic, assign)id<TouchImageView_starDealegate>delegate;

@end
