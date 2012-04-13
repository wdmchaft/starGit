//
//  textFeilview.h
//  ScrollImageDemo
//
//  Created by 唐彬琪 on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
/*
 尚品资讯文字内容显示视图控制
*/ 


#import <UIKit/UIKit.h>


@interface NewsTextView : UIViewController {
  
    UITextView * textView;   //资讯内容
    UILabel * titleLabel;    //资讯标题
    UILabel * timeLabel;     //资讯时间
}
@property(nonatomic, retain)UITextView * textView;
@property(nonatomic, copy)UILabel * titleLabel;
@property(nonatomic, copy)UILabel * timeLabel;

@end
