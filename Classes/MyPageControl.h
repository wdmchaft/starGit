//
//  MyPageControl.h
//  ScrollImageDemo
//
//  Created by 唐彬琪 on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyPageControl : UIPageControl {
    UIImage*imagePageStateNormal;
    UIImage*imagePageStateHighlighted; 
    
}

-(id)initWithFrame:(CGRect)frame;
-(void)updateDots;
@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHighlighted; 


@end
