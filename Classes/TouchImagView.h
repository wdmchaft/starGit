//
//  untitled.h
//  ShangPin
//
//  Created by ibokan on 11-3-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


/*
 自定义的UIImageView
 
 添加了点击事件，商品详情中用到了。
 点击小图能够察看大图。
 */


#import <UIKit/UIKit.h>

@protocol TouchImagViewDelegate//代理 用来实现点击事件 点击查看大图

-(void) didTouchEndImagViewWithIndex:(int) index;

@end


@interface TouchImagView : UIImageView 
{
	id<TouchImagViewDelegate> delegate;
}

@property(nonatomic,assign) id<TouchImagViewDelegate> delegate;

@end
