//
//  MyPageControl.m
//  ScrollImageDemo
//
//  Created by 唐彬琪 on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MyPageControl.h"
//@interface
//MyPageControl(protect) // 声明一个私有方法, 该方法不允许对象直接使用
//-(void)updateDots;
//@end 



@implementation MyPageControl
@synthesize imagePageStateNormal,imagePageStateHighlighted;


-(id)initWithFrame:(CGRect)frame { // 初始化
    self = [super initWithFrame:frame];
    return self;
}

-(void)setImagePageStateNormal:(UIImage *)image { // 设置正常状态点按钮的图片
    [imagePageStateHighlighted release];
    imagePageStateHighlighted = [image retain];
    [self updateDots];
}

-(void)setImagePageStateHighlighted:(UIImage *)image { // 设置高亮状态点按钮图片
    [imagePageStateNormal release];
    imagePageStateNormal = [image retain];
    [self updateDots];
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { // 点击事件
    
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

-(void)updateDots { // 更新显示所有的点按钮
    if
        (imagePageStateNormal || imagePageStateHighlighted)
    {
        
        NSArray*subview = self.subviews; // 获取所有子视图
        for(NSInteger i = 0; i < [subview count]; i++)
        {
            
            UIImageView*dot = [subview objectAtIndex:i]; 
            dot.image  = self.currentPage == i ? imagePageStateNormal : imagePageStateHighlighted;
            
        }
        
    }
    
}

-(void)dealloc { // 释放内存
    [imagePageStateNormal release];
    imagePageStateNormal = nil;
    [imagePageStateHighlighted release];
    imagePageStateHighlighted = nil;
    [super dealloc];
} 


@end
