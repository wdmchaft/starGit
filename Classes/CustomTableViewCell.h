//
//  CustomTableViewCell0.h
//  ShangPin
//
//  Created by 唐彬琪 on 11-8-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
/*
 自定义cell
 
 正在出售,即将出售以及出售日历的tableviewcell
*/ 


#import <UIKit/UIKit.h>


@interface CustomTableViewCell : UITableViewCell {
    UILabel * brandName;                 //折扣信息
    UILabel * activityName;              //活动名称
    UILabel * activityTime;              //活动时间
    UIImageView * act_imageView;          //活动视图
    UIButton * addRemindButton;           //加入提醒/进入活动
    UIButton * invButton;                 //邀请好友
}
@property(nonatomic, retain) UILabel * brandName;
@property(nonatomic, retain) UILabel * activityName;
@property(nonatomic, retain) UILabel * activityTime;
@property(nonatomic, retain) UIImageView * act_imageView; 
@property(nonatomic, retain) UIButton * addRemindButton;
@property(nonatomic, retain) UIButton * invButton;
@end
